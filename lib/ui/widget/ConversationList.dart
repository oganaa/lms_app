import 'package:flutter/material.dart';
import 'package:socket_io_client/src/socket.dart';
import 'package:lms_app/ui/views/chat/chatDetailPage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationList extends StatefulWidget{
  String name;
  String userId;
  String messageText;
  String imageUrl;
  String time;
  String roomId;
  bool isMessageRead;
  IO.Socket socket;
  ConversationList({@required this.name,@required this.messageText,this.userId,@required this.roomId,@required this.imageUrl,@required this.time,@required this.isMessageRead, this.socket});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatDetailPage(name: widget.name,imageUrl: widget.imageUrl,userId:widget.userId,socket: widget.socket,time: widget.time,isMessageRead: widget.isMessageRead,roomId: widget.roomId,);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.messageText,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,style: TextStyle(fontSize: 12,fontWeight: widget.isMessageRead?FontWeight.bold:FontWeight.normal),),
          ],
        ),
      ),
    );
  }
}