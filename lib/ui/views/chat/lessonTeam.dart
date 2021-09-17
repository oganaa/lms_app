import 'package:flutter/material.dart';
import 'package:lms_app/models/chatUsersModel.dart';
import 'package:lms_app/ui/widget/ConversationList.dart';

import '../home_view.dart';

class LessonTeam extends StatefulWidget {
  @override
  _LessonTeamState createState() => _LessonTeamState();
}

class _LessonTeamState extends State<LessonTeam> {
  List<ChatUsers> chatUsers = [
    ChatUsers(name: "leessonn", messageText: "Awesome Setup", imageURL: "assets/images/userImage1.png", time: "Now"),
    ChatUsers(name: "Glady's Murphy", messageText: "That's Great", imageURL: "assets/images/userImage2.png", time: "Yesterday"),
    ChatUsers(name: "Jorge Henry", messageText: "Hey where are you?", imageURL: "assets/images/userImage3.png", time: "31 Mar"),
    // ChatUsers(name: "Philip Fox", messageText: "Busy! Call me in 20 mins", imageURL: "images/userImage4.jpeg", time: "28 Mar"),
    // ChatUsers(name: "Debra Hawkins", messageText: "Thankyou, It's awesome", imageURL: "images/userImage5.jpeg", time: "23 Mar"),
    // ChatUsers(name: "Jacob Pena", messageText: "will update you in evening", imageURL: "images/userImage6.jpeg", time: "17 Mar"),
    // ChatUsers(name: "Andrey Jones", messageText: "Can you please share the file?", imageURL: "images/userImage7.jpeg", time: "24 Feb"),
    // ChatUsers(name: "John Wick", messageText: "How are you?", imageURL: "images/userImage8.jpeg", time: "18 Feb"),
  ];
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
              itemCount: chatUsers.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return ConversationList(
                  name: chatUsers[index].name,
                  messageText: chatUsers[index].messageText,
                  imageUrl: chatUsers[index].imageURL,
                  time: chatUsers[index].time,
                  isMessageRead: (index == 0 || index == 3)?true:false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}