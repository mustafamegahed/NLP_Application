# Importing the required packages for webpage_to_text
from bs4 import BeautifulSoup
import requests

# Installing the required packages for text processing
import re

# Importing the required packages for summarization ???????
from transformers import pipeline



#### Web scraping ####
######################

def webpage_to_text(url):
	# Extracting text from a web page using BeautifulSoup. return a string

	# request the web page
	response = requests.get(url)

	# Create a BeautifulSoup object to parse the HTML
	soup = BeautifulSoup(response.text, 'html.parser')

	# Use BeautifulSoup to scrape the paragraphs of the page
	# Using paragraphs ignores some iformation but returns more clean text
	paragraphs = soup.find_all('p')

	# Intiate an empty string to store the text
	text = ''

	for paragraph in paragraphs:
		text = text + ' ' + paragraph.text

	return text

# text = webpage_to_text()




#### Precessing and cleaning the text ####
##########################################

# defining text_to_sentences to convert the text to a list of sentences
def text_to_sentences(text):
	text = text.replace('.', '.<eos>')
	text = text.replace('!', '!<eos>')
	text = text.replace('?', '?<eos>')
	sentences = text.split('<eos>')
	return sentences

def cleaning_text_to_sentences(text):
	# Dropping short line or individual word lines (less than 10 words) 
	# Dropping reference brackets [number]
	lines = [re.sub("\[[0-9]+\]", '', line.replace(u'\xa0', '')) for line in text.split('\n') if len(line.split(' ')) > 10]



	# Splitting each paragraph into lines then into sentences
	sentences = [sentence.lstrip().rstrip() for line in [text_to_sentences(line) for line in lines] for sentence in line if len(sentence.split(' ')) > 1]
	return sentences

# sentences = cleaning_text_to_sentences(text)




# Split sentences to batches of sentences where the summation of their words is less than n_word (500 words for now)
def sentences_to_batches(sentences, n_words=500):

	batches = []
	current_batch = ''

	for sentence in sentences:

		if len(sentence.split(' ')) + len(current_batch.split(' ')) <= n_words:
			current_batch = current_batch + ' ' + sentence

		elif (len(sentence.split(' ')) + len(current_batch.split(' ')) > n_words ) & (len(sentence.split(' ')) < n_words):
			batches.append(current_batch)
			current_batch = sentence

		elif len(sentence.split(' ')) > n_words:
			sentence = sentence.split(' ')
			sentence = [' '.join(sentence[i : i + n_words]) for i in range(0, len(sentence), n_words)]

			for batch in sentence:
				batches.append(batch)

	if len(current_batch.split(' ')) > 1: batches.append(current_batch)

	return batches



# batches = sentences_to_batches(sentences)




#### Text Summarization using transformers ####
###############################################

def batches_to_summary(batches):

	summarizer = pipeline('summarization', model='t5-small')

	summaries = summarizer(batches, max_length = 50, min_length = 25)

	summary_to_user = ''

	for summary in summaries:
		summary_to_user = summary_to_user + ' ' + summary['summary_text']
	
	return summary_to_user

# summary = batches_to_summary(batches)


from pydantic import BaseModel
class Item(BaseModel):
	url: str

#### API ####
#############

# Import required modules
from fastapi import FastAPI, Path

app = FastAPI()

# Home
@app.get('/') 
def home():
	return {'Data': 'Home'}

#### Post 
@app.post('/summarize-webpage')
def summ_wb(item: Item):
	
	text = webpage_to_text(item.url)
	sentences = cleaning_text_to_sentences(text)
	batches = sentences_to_batches(sentences)
	summary = batches_to_summary(batches)

	return summary
