import 'package:flutter/material.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:lms_app/controller/chat_controller.dart';
import 'package:lms_app/models/chatUsersModel.dart';
import 'package:lms_app/ui/widget/ConversationList.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../home_view.dart';

class ChatPage extends StatefulWidget {
  List<ChatController> chatCtrl;
  IO.Socket socket;
  ChatPage({this.chatCtrl, this.socket});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  // List<UserId> chatUsersss = [

    // UserId(name: "Jane Russel", messageText: "Awesome Setup", avatar: "assets/images/userImage1.png"),
    // ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "assets/images/userImage2.png", time: "Yesterday"),
    // ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "assets/images/userImage3.png", time: "31 Mar"),
    // ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "assets/images/userImage4.png", time: "28 Mar"),
    // ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "assets/images/userImage5.png", time: "23 Mar"),
    // ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "assets/images/userImage6.png", time: "17 Mar"),
    // ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "assets/images/userImage7.png", time: "24 Feb"),
    // ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "assets/images/userImage8.png", time: "18 Feb"),
  // ];
  // List<ChatUsers> chatUsers = [
  //   ChatUsers(name: "Jane Russel", messageText: "Awesome Setup", imageURL: "assets/images/userImage1.png", time: "Now"),
  //   ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "assets/images/userImage2.png", time: "Yesterday"),
  //   ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "assets/images/userImage3.png", time: "31 Mar"),
  //   ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "assets/images/userImage4.png", time: "28 Mar"),
  //   ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "assets/images/userImage5.png", time: "23 Mar"),
  //   ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "assets/images/userImage6.png", time: "17 Mar"),
  //   ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "assets/images/userImage7.png", time: "24 Feb"),
  //   ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "assets/images/userImage8.png", time: "18 Feb"),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    print(widget.chatCtrl.length);
    setState(() {

      widget.chatCtrl.sort((a, b)=> a.userId[0].name.compareTo(b.userId[0].name));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.black87,
        //     ),
        //     onPressed: () => Navigator.push(
        //         context, MaterialPageRoute(builder: (_) => HomeView()))),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16,right: 16,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[

                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back,color: Colors.black,),
                    ),
                    Text("Conversations",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.pink[50],
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add,color: Colors.pink,size: 20,),
                      SizedBox(width: 2,),
                      Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ListView.builder(
              itemCount: widget.chatCtrl.length,
              shrinkWrap: true,
              // reverse: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return
                  // widget.chatCtrl[index].roomId.messages.length>0?
                ConversationList(
                  socket:widget.socket,
                  name: widget.chatCtrl[index].userId[0].name,
                  userId: widget.chatCtrl[index].userId[0].sId,
                  messageText: widget.chatCtrl[index].roomId.messages.length>0?widget.chatCtrl[index].roomId.messages[0].content:'Hi',
                  imageUrl: widget.chatCtrl[index].userId[0].avatar!=''?widget.chatCtrl[index].userId[0].avatar: "assets/images/userImage${index+1}.png",
                  time:  widget.chatCtrl[index].roomId.messages.length>0?widget.chatCtrl[index].roomId.messages[0].time:'yesterday',
                  roomId:  widget.chatCtrl[index].roomId.sId,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                )
                      // :Container()
                ;
              },
            ),
          ],
        ),
      ),
    );
  }
}