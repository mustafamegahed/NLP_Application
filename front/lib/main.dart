import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TasksPage(),
    );
  }
}

final dio = Dio();

void request(url) async {
  Response response;
  response = await dio.post(
      'https://e79a-2a00-f29-290-1aa0-21b1-bfca-d47f-8204.in.ngrok.io/summarize-webpage',
      data: {'url': url});
  print(response.data.toString());
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Choose Task')),
          backgroundColor: Colors.grey[850],
        ),
        body: SafeArea(
          child: Column(children: [
            Center(
              child: Card(
                elevation: 5,
                color: Colors.grey[300],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SummarizationPage()));
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Center(
                        child: Text('Summarization', textScaleFactor: 1.3)),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class SummarizationPage extends StatelessWidget {
  const SummarizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Summarization')),
          backgroundColor: Colors.grey[850],
        ),
        body: SafeArea(
          child: Column(children: [
            Center(
              child: Card(
                elevation: 5,
                color: Colors.grey[300],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                margin: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WebPagePage()));
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    height: 100,
                    child:
                        Center(child: Text('Web Page', textScaleFactor: 1.3)),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// Define a custom Form widget.
class WebPagePage extends StatefulWidget {
  const WebPagePage({super.key});

  @override
  State<WebPagePage> createState() => _WebPagePage();
}

// Define a corresponding State class. This class holds the data related to the Form.
class _WebPagePage extends State<WebPagePage> {
// Create a text controller and use it to retrieve the current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Web Page')),
          backgroundColor: Colors.grey[850],
        ),
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
                controller: myController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter your URL',
                ),
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    maximumSize: const Size(150, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  print(myController.text);
                  request(myController.text);
                },
                child: const Center(child: Text('Submit')))
          ]),
        ),
      ),
    );
  }
}
