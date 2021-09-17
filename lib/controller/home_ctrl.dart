import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/cupertino.dart';
import 'package:lms_app/constants/route_names.dart';
import 'package:lms_app/controller/base_ctrl.dart';
import 'package:lms_app/models/Content.dart';
import 'package:lms_app/models/message.dart';
import 'package:lms_app/models/user.dart';
import 'package:lms_app/services/navigation_service.dart';
import 'package:lms_app/services/web_service.dart';
import 'package:lms_app/ui/router.dart';
import '../globalValues.dart';
import '../locator.dart';
import 'package:http/http.dart' as http;

class HomeCtrl extends BaseController{
  final WebService service = locator<WebService>();
  final NavigationService _navigationService= NavigationService();
  IO.Socket socket;

  User  me;
  List<User> users = [];
  List<Message> messages = [];
  int _selectedIndex = 0;
  ScrollController controller = ScrollController();
  Content content = new Content();
  List data = List();
  List<User> user =[];
  void initialise (){
    service.fetchPost().then((value) {
      if(value!=null){
        content = value;
        for (var i = 0; i< content.categories.length; i++){
          content.categories[i].items = [];
          for(var j = 0; j< content.categories[i].lessons.length; j++){
            // print('data'+content.lessons[ content.categories[i].lessons[j]-1].imgUrl);
            content.categories[i].items.add(content.lessons[ content.categories[i].lessons[j]-1]);
          }
        }
      }

      print('contents --- ${value}');
      notifyListeners();
    });
    getSWData();
    connect();
    notifyListeners();
  }

void jumpDetail(){
  _navigationService.navigateTo(DetailsViewRoute);
  }
  Future<List> getSWData() async {
    // String url = '';
    //
    var itisme =  await http.post("${globuri}/api/user/login",body: {
      'email':'eegii@gmail.com',
      'roomCode':'test0523a',
      'password':'test'
    });
    // print("me---------${itisme.body}");
    if (itisme.statusCode == 200) {
      var itme = json.decode(itisme.body);
      // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      // setState(() {
      // print("resBody ${itme}");
      // List datas = itme['success'];
      print("chat home user data ${itme['user']['_id']}");
      myUserId = itme['user']['_id'];
      // // });
      // user = data.map<User>((json) => User.fromJson(json)).toList();
    }

  }
  void connect() async {
    // print("${GlobalData.datosusuario}");
    // GlobalData.datosusuario;
    // socket = await IO.io('https://meet.oyuntan.mn/', <String, dynamic>{
    // socket = await IO.io('http://localhost:8000/', <String, dynamic>{
    socket = await IO.io('${globuri}/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((data) => print("Connected ${socket.id}"));

    // Map<String,dynamic> roomData = {
    //   "name":"erdene",
    //   "email":"erdene@gmail.com",
    //   // "name":"${widget.mail}",
    //   "room":"test0523a",
    //   "role":"teacher",
    //   "id":socket.id,
    //   "userId":myUserId,
    //   // "room": "${widget.pass}",
    //   "typingStatus":false
    // };
    Map<String,dynamic> roomData = {
      "name":"eegii",
      "email":"eegii@gmail.com",
      // "name":"${widget.mail}",
      "room":"test0523a",
      "role":"teacher",
      "id":socket.id,
      "userId":myUserId,
      // "room": "${widget.pass}",
      "typingStatus":false
    };
    socket.emit('createUser',roomData);
    socket.on('userInfo',(user)=> {
    //

    // setState(() {
    me = new User.fromJson(user),
        print(me),
    users.add(User.fromJson(user)),
    socket.emit('joinRoom', me),
    print("ococococ"),
    notifyListeners(),
    // }),

    });

    socket.on('updateUsers',(user)=>{
      // setState(() {
        print("total users ${user}"),
      UsersData=user,
      notifyListeners(),
        // me = new User.fromJson(user);
        // print(me);
        // users.add(User.fromJson(user));
        // widget.socket.emit('joinRoom',me);
        // print("ococococ");
      // }),
    });
    socket.on('newMessage',(message)=>{
      // parsed = jsonDecode(message).cast<Map<String, dynamic>>();


      // if(this.mounted){
        print("ssgfd ${message}"),
        // setState(() {
          messages.add(Message.fromJson(message)),
          // print("ssgfdsggsds"),
          print("ssgfdvdsdvsvsd ${messages}"),
        // }),

      // },
    });
    //
    // var postbody = {'userId':'6077f4550799ea26f0977bee'};
    // var res =
    // await http.post("http://192.168.17.29:8000/api/roomMember/yourRoom",body: postbody);
    // print("res ${res.body}");
    // if (res.statusCode == 200) {
    //   var resBody = json.decode(res.body);
    //   // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
    //   // setState(() {
    //   print("resBody ${resBody}");
    //   // data = resBody['user'];
    //   // print("asdfg ${data}");
    //   // // });
    //   // user = data.map<User>((json) => User.fromJson(json)).toList();
    // }
    // print("users ${user}");
    // socket.emit('joinRoom',roomData);
    // socket.on('userInfo',(user)=>{
    //   setState(() {
    //     me = new User.fromJson(user);
    //     print(me);
    //     users.add(User.fromJson(user));
    //     socket.emit('joinRoom',me);
    //     print("ococococ");
    //   }),
    // });
    // socket.on('newMessage',(message)=>{
    //   // parsed = jsonDecode(message).cast<Map<String, dynamic>>();
    //
    //
    // if(this.mounted){
    //   setState(() {
    //     messages.add(Message.fromJson(message));
    //     print("ssgfdsggsds");
    //   }),
    //
    //    },
    // });
    // socket.on('sendAnswer',(answer)=>{
    //   // parsed = jsonDecode(action).cast<Map<String, dynamic>>();
    //   //   var parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    //
    // print("answer "),
    //
    //   setState(() {
    //     // socket.emit(event)
    //     print("answer ${answer}");
    //     act=true;
    //     questionCtrl =new QuestionCtrl.fromJson(answer);
    //     String pageNum =questionCtrl.id;
    //     print("pageNum ${pageNum}");
    //     // if(pageNum.contains('.')){
    //     //
    //     //   print("true");
    //     //   curHor =int.parse(pageNum.split('.')[0])-1;
    //     //   curVer=int.parse(pageNum.split('.')[1]);
    //     // }
    //     // else if(!pageNum.contains('.')){
    //     //   print("false");
    //     //   curHor =int.parse(pageNum)-1;
    //     //   curVer = 0;
    //     // }
    //     // print("${curHor}  ${curVer}");
    //     // pageControllerHorizintal.jumpToPage((curHor)) ;
    //     // pageControllerVertical.jumpToPage((curVer)) ;
    //     // print("vert ");
    //     // pageControllerHorizintal.animateToPage(curHor, duration: Duration(milliseconds: 1000));
    //     // pageControllerHorizintal.animateToPage(curVer, duration: Duration(milliseconds: 1000));
    //     // print(pageControllerHorizintal.page);
    //
    //
    //
    //     // messages.add(Message.fromJson(message));
    //   }),
    // });
    // if(act==false){
    //   print("false");
    //   // pageControllerHorizintal = new PageController(initialPage:0);
    //   // pageControllerVertical = new PageController(initialPage:0 );
    // }
  }


}