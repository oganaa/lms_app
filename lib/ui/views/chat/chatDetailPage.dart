import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lms_app/controller/chatDetail_controller.dart';
import 'package:lms_app/controller/chat_controller.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/chatMessageModel.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatDetailPage extends StatefulWidget{
  String name;
  String imageUrl;
  String time;
  String roomId;
  String userId;
  bool isMessageRead;
  IO.Socket socket;
  ChatDetailPage({ this.name,this.roomId,this.userId ,this.socket,this.imageUrl, this.time, this.isMessageRead});
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {

  final ScrollController _scrollController = ScrollController();
  TextEditingController sendMessagectrl = new TextEditingController();
  List<ChatDetailController> chatdeatilCtrl = [];
  List data = List();
  String userSocketId='';
  String sendmessage ='';
  Map<String, dynamic> wasd;
  Future<List<ChatDetailController>> getSWData() async {
    // String url = '';

    var postbody = {'roomId':'${widget.roomId}'};
    var res = await http.post("${globuri}/api/message/yourMessage",body: postbody);
    // print("res ${res.body}");
    if (res.statusCode == 200) {
      var resBody = json.decode(res.body);
      // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      // setState(() {
      // print("resBody ${resBody}");
      data = resBody['messages'];
      print("asdfg ${data.length}");
      // // });
      // user = data.map<User>((json) => User.fromJson(json)).toList();
    }

    // print("body datatatat}");
    // print("body datatatat${data}");
    return data.map<ChatDetailController>((json) => ChatDetailController.fromJson(json))
        .toList();
  }
  @override
  void initState() {

    // print("sfsagfdsfsdfawhrew");
    print("my id ${myUserId}");
    getSWData().then((datas) {
      setState(() {
        // print("init ${slidesss[0].title}");
        // print("fdsagferherwhrew");
        this.chatdeatilCtrl = datas;
        print("sdfadfsdfa${chatdeatilCtrl[0].roomId.name}");
        // _children[0] = new ChatPage(chatCtrl:chatCtrl);

        // _scrollController.animateTo(
        //     _scrollController.position.maxScrollExtent,
        //     duration: Duration(milliseconds: 100),
        //     curve: Curves.easeInOut);
        // print("mail= "+widget.mail +"pass= "+ widget.pass);
      });
    });
    widget.socket.on("setRoomMessage",(data) => {
      if (this.mounted) {

        setState(() {
          print("data set room messages ${data}");
          bool isActive = false;
          ChatDetailController update= ChatDetailController.fromJson(data);
          for(var i = 0;i<chatdeatilCtrl.length;i++){
            if(chatdeatilCtrl[i].sId.toString().trim()==update.sId.toString().trim()){
              isActive = true;
            }
          }
          if(!isActive){
            chatdeatilCtrl.add(update);
          }

          // sendMessagectrl.text='';
        })
      }
    });
    toSocket();
    // var scrollPosition = _scrollController.position;
    //
    // if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
    //   _scrollController.animateTo(
    //     scrollPosition.maxScrollExtent,
    //     duration: new Duration(milliseconds: 200),
    //     curve: Curves.easeOut,
    //   );
    // }
    // _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // TODO: implement initState
    super.initState();
  }
void toSocket(){
  print("users datas ${UsersData}");
    for(int i=0;i<UsersData.length;i++){
      if(UsersData[i]["userId"]==widget.userId){
        print("dorjoogiin socket id ${UsersData[i]["id"]}");
        userSocketId=UsersData[i]["id"];
      }
    };
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: AssetImage("${widget.imageUrl}"),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${widget.name}",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text(widget.isMessageRead?"Offline":"Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                  Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            reverse: true,

            child: ListView.builder(
              itemCount: chatdeatilCtrl.length,
              shrinkWrap: true,
                // primary: true,
              // reverse: true,
              controller: _scrollController,
              padding: EdgeInsets.only(top: 10,bottom: 60),
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return Container(
                  padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                  child: Align(
                    alignment: (chatdeatilCtrl[index].senderId != myUserId ?Alignment.topLeft:Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (chatdeatilCtrl[index].senderId != myUserId ?Colors.grey.shade200:Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(chatdeatilCtrl.length>0?chatdeatilCtrl[index].content:"hi", style: TextStyle(fontSize: 15),),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(

                      controller: sendMessagectrl,
                      // onChanged: (text){
                      //   setState(() {
                      //     sendmessage = text;
                      //     // print(sendMessagectrl.text);
                      //   });
                      // },
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none

                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      int s=0;
                      print("send data");
                      send();
                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );

  }
  void send() async {
    // widget.socket.emit("createUser")
     widget.socket.emit("privateMessage", ({
      'toSocketId': userSocketId,
      'fromName': widget.name,
      'fromId': myUserId,
      'toUserId': widget.userId,
      'roomId': widget.roomId,
      'content': sendMessagectrl.text
    })
    );

     print({
       'toSocketId': userSocketId,
       'fromName': widget.name,
       'fromId': myUserId,
       'toUserId': widget.userId,
       'roomId': widget.roomId,
       'content': sendMessagectrl.text
     });
     sendMessagectrl.text='';
    // chatdeatilCtrl.add({});
    //  widget.socket.on("setRoomMessage",(data) => {
    //   if (this.mounted) {
    //
    //     setState(() {
    //       bool isActive = false;
    //       ChatDetailController update= ChatDetailController.fromJson(data);
    //       for(var i = 0;i<chatdeatilCtrl.length;i++){
    //             if(chatdeatilCtrl[i].sId.toString().trim()==update.sId.toString().trim()){
    //               isActive = true;
    //             }
    //       }
    //       if(!isActive){
    //         chatdeatilCtrl.add(update);
    //       }
    //
    //
    //     })
    //   }
    // }
    // );
  }
}