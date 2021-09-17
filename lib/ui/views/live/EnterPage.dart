// import 'package:example/Presentation/Room.dart';
import 'package:random_words/random_words.dart';

import 'package:flutter/material.dart';

import 'Presentation/Room.dart';

// void main() {
//   runApp(MyApp());
// }

class EnterPage extends StatefulWidget {
  static const String RoutePath = '/';

  @override
  _EnterPageState createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  final TextEditingController _textEditingController = TextEditingController(text: 'https://meet.oyuntan.mn/?roomId=test0523a&peerId=eegii');
  // final TextEditingController _textEditingController = TextEditingController(text: 'http://192.168.17.23:8000/?roomId=test0523a&peerId=eegii');
  // final TextEditingController _textEditingController = TextEditingController(text: 'https://v3demo.mediasoup.org/?roomId=4qdjfjuq&peerId=eegii');
//https://v3demo.mediasoup.org/?roomid=4qdjfjuq
  @override
  void initState() {
    super.initState();

    _textEditingController.addListener(() {
      final String text = _textEditingController.text.toLowerCase();
      _textEditingController.value = _textEditingController.value.copyWith(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mediasoup-client-flutter'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: 'Room url',
              ),
            ),
            TextButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Room(url:_textEditingController.value.text.toLowerCase())),
              );
              // Navigator.pushNamed(context, Room.RoutePath, arguments: _textEditingController.value.text.toLowerCase());
            }, child: Text('Join'),),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      // ignore: missing_return
      onGenerateRoute: (settings) {
        if (settings.name == EnterPage.RoutePath) {
          return MaterialPageRoute(builder: (context) => EnterPage(),);
        }
        if (settings.name == Room.RoutePath) {
          return MaterialPageRoute(builder: (context) => Room(url: settings.arguments,),);
        }
      },
    );
  }
}
