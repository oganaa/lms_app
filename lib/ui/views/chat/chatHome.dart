
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lms_app/controller/chat_controller.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/message.dart';
import 'package:lms_app/models/user.dart';
import 'package:lms_app/ui/views/chat/lessonTeam.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:http/http.dart' as http;
import '../home_view.dart';
import 'chatPage.dart';

class ChatHome extends StatelessWidget {
  IO.Socket socket;
  ChatHome({Key key, this.socket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatScreen(socket: socket,);
  }
}
class ChatScreen extends StatefulWidget {
  IO.Socket socket;
  ChatScreen({Key key, this.socket}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int index=0;
  User  me;
  List<User> users = [];
  List<ChatController> chatCtrl = [];
  List data = List();
  var myId ;
  List<Message> messages = [];
   List<Widget> _children = [
    ChatPage(chatCtrl:  [],),
    LessonTeam(),
    ChatPage(chatCtrl:  [],),
  ];
@override
  void initState() {
    // TODO: implement initState
  getSWData().then((datas) {
    setState(() {
      // print("init ${slidesss[0].title}");
      this.chatCtrl = datas;
      // print("sdfadfsdfafewfwef${chatCtrl}");
      _children[0] = new ChatPage(chatCtrl:chatCtrl,socket:widget.socket);

      // print("mail= "+widget.mail +"pass= "+ widget.pass);
    });
  });
  // widget.socket.on("setRoomMessage",(data) => {
  //   if (this.mounted) {
  //
  //     setState(() {
  //       print("chat home page  set room messages ${data}");
  //       // bool isActive = false;
  //       // ChatDetailController update= ChatDetailController.fromJson(data);
  //       // for(var i = 0;i<chatdeatilCtrl.length;i++){
  //       //   if(chatdeatilCtrl[i].sId.toString().trim()==update.sId.toString().trim()){
  //       //     isActive = true;
  //       //   }
  //       // }
  //       // if(!isActive){
  //       //   chatdeatilCtrl.add(update);
  //       // }
  //       // // sendMessagectrl.text='';
  //
  //     })
  //   }
  // });
  // connect();
    super.initState();
  }
  void connect() async {
    // await http.post("http://localhost:8000/api/roomMember/yourRoom");
    Map<String,dynamic> roomData = {
      // "name":"erdene",
      "email":"erdene@gmail.com",
      // "name":"${widget.mail}",
      "room":"test0523a",
      // "room": "${widget.pass}",
      "typingStatus":false
    };
    widget.socket.emit('joinRoom',roomData);

  }

  Future<List<ChatController>> getSWData() async {
    // String url = '';
    //
    // var itisme =  await http.post("http://192.168.17.23:8000/api/user/login",body: {
    //   'email':'erdene@gmail.com',
    //   'roomCode':'test0523a',
    //   'password':'test'
    // });
    // // print("me---------${itisme.body}");
    // if (itisme.statusCode == 200) {
    //   var itme = json.decode(itisme.body);
    //   // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
    //   // setState(() {
    //   print("resBody ${itme}");
    //    // List datas = itme['success'];
    //   print("chat home user data ${itme['user']['_id']}");
    //   myUserId = itme['user']['_id'];
    //   // // });
    //   // user = data.map<User>((json) => User.fromJson(json)).toList();
    // }


    var postbody = {'userId':'${myUserId}'};
    // var postbody = {'userId':'6077f4550799ea26f0977bee'};
    var res =
    await http.post("${globuri}/api/roomMember/yourRoom",body: postbody);
    // print("res ${res.body}");
    if (res.statusCode == 200) {
      var resBody = json.decode(res.body);
      // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      // setState(() {
      // print("resBody ${resBody}");
      data = resBody['messages'];
      print("chat home data ${data}");
      // // });
      // user = data.map<User>((json) => User.fromJson(json)).toList();
    }

    // print("body datatatat}");
    // print("body datatatat${data}");
    return data
        .map<ChatController>((json) => ChatController.fromJson(json))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
          // _navigateToScreens(index);
        },
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Зурвас"),

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2),
            title: Text("Хичээл"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            title: Text("Даалгавар"),
          ),
        ],
      ),
    );
  }
}

