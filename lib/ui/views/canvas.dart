import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:random_words/random_words.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/action_data.dart';
import 'package:lms_app/models/draw_action.dart';
import 'package:lms_app/models/message.dart';
import 'package:lms_app/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'live/room_client.dart';

void main() => runApp(CanvasPainting());
// void main() => runApp(MyApp());

class CanvasPainting extends StatefulWidget {
  @override
  _CanvasPaintingState createState() => _CanvasPaintingState();
  final String pass;
  IO.Socket socket;
  CanvasPainting({Key key,this.socket, this.pass}) : super(key: key);
}
Jsonobj serverData;
// List<Offsets> offsetPoint = [] ;
class _CanvasPaintingState extends State<CanvasPainting> {
  GlobalKey globalKey = GlobalKey();
  ScrollController _scrollController = new ScrollController();
  List<Offset> points = List();
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;
  List<Message> messages = [];
  bool act = false;
  List<Offsets> offset = [];
  List<User> users = [];
  int canvasWidth=360;
  int canvasHeight = 640;
  User  me;
  DrawAction actionData;
  // IO.Socket socket;
  int maxScrollX = 0;
  double minScrollX = 0;
  var minX;
  int minimum=0;
  List<RTCVideoRenderer> remoteRenderers = [];
  RTCVideoRenderer localRenderer;
  List<Consumer> consumers = [];
  List<Producer> producers = [];
  RoomClient roomClient;

  String url;
  @override
  void initState() {

    // ..addListener(() {
    //   print("offset = ${_scrollController.offset}");
    // });
    super.initState();
    // getNewsFeed().then((slidesss){
    //   setState(() {
    //     this.slides = slidesss;
    //     // print("mail= "+widget.mail +"pass= "+ widget.pass);
    //   });
    // });
    connect();
    wrtcconnect();
  }

  void wrtcconnect(){

    url='${globuri}/?roomId=test-canvas&peerId=egiiii'.toLowerCase();
    Uri uri = Uri.parse(url);
    print("uriiii ---------------------${uri}");
    roomClient = RoomClient(
      displayName: nouns[Random.secure().nextInt(2500)],
      roomId: uri.queryParameters['roomid'] ?? randomAlpha(8).toLowerCase(),
      peerId: randomAlpha(8),
      url: 'wss://${uri.host}:4443',
      onConsumer: addConsumer,
      onProducer: onProducer,
    );
    // }
    roomClient.join();
  }
  void addConsumer(Consumer consumer) async {
    consumers.add(consumer);
    if (consumer.kind != 'audio') {
      final renderer = RTCVideoRenderer();
      await renderer.initialize().then((_) {
        renderer.srcObject = consumer.stream;
        remoteRenderers.add(renderer);
      }).then((_) => setState(() {}));
    }
  }

  void onProducer(Producer producer) async {
    producers.add(producer);
    if (producer.kind != 'audio') {
      localRenderer = RTCVideoRenderer();
      await localRenderer.initialize();
      localRenderer.srcObject = producer.stream;
    }
    setState(() {});
  }

  @override
  void dispose() {
    localRenderer?.dispose();
    remoteRenderers.forEach((element) {
      element?.dispose();
    });
    roomClient.close();
    super.dispose();
  }
  void connect() async {
    print("sss");

    Map<String,dynamic> roomData = {
      "name":"Eegii",
      // "role":"teacher",
      "email":"eegii@gmail.com",
      "userId":myUserId,
      "id":widget.socket.id,
      // "name":"${widget.mail}",
      // "room":"test-canvas",
      "room":"test-canvas",
      // "room": "${widget.pass}",
      "typingStatus":false
    };
    // String room = "test0429a";
    // socket.connect();
    // socket.onConnect((data) => print("Connected ${socket.id}"));
    widget.socket.emit('createUser',roomData);
    widget.socket.emit('joinRoom',roomData);
    // socket = await IO.io('https://meet.oyuntan.mn/', <String, dynamic>{
    // socket = await IO.io('192.168.17.88:8000/', <String, dynamic>{
    // socket = await IO.io('http://192.168.17.88:8000/', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    // Map<String,dynamic> roomData = {
    //   "name":"Eegiiii",
    //   // "name":"${widget.mail}",
    //   // "room":"test15",
    //   "room": "${widget.pass}",
    //   "typingStatus":false
    // };

    // print("pass = ${widget.pass}");
    // Map<String,dynamic> user = {
    //   "name":"Ganaa",
    //   "room":"test0423a",
    //   "email":"gana@gmail.com"
    // };
    // String room = "test0429a";
    // socket.connect();
    // socket.onConnect((data) => print("Connected"));
    // socket.emit('createUser',roomData);
    // socket.emit('joinRoom',roomData);
    // socket.on('userInfo',(user)=>{
    //   setState(() {
    //     me = new User.fromJson(user);
    //     print(me);
    //     users.add(User.fromJson(user));
    //     socket.emit('joinRoom',me);
    //   }),
    // });
    // socket.on('newMessage',(message)=>{
    //   // parsed = jsonDecode(message).cast<Map<String, dynamic>>();
    //
    //
    //   setState(() {
    //     messages.add(Message.fromJson(message));
    //   }),
    // });

    widget.socket.on('newAction',(action)=>{
      // parsed = jsonDecode(action).cast<Map<String, dynamic>>();
      setState(() {
        act=true;
        print("true");
        // var parsed = json.decode(action).cast<Map<String, dynamic>>();
        // actionData =new DrawAction.fromJson(action);

        print("actionData" + action.toString());

        DrawState drawState =DrawState.fromJson(action);
        Drawjson drawjson  = drawState.drawjson;
        DrawAction drawAction = drawjson.drawAction;
        // canvasWidth = drawAction.width;
        // canvasHeight = drawAction.height;
        canvasWidth = 720;
        canvasHeight = 640;
        print("hei=${canvasHeight} ${canvasWidth}");
        if(drawAction.typeid == 1){
          // offsetPoint.addAll(null);
          Jsonobj jsonObj = drawAction.jsonobj;
          String selectColor = jsonObj.sendColor;
          List<Offsets> tempOffset = jsonObj.offsets;
          for(var x in tempOffset ){
            if(x.x>maxScrollX){
              maxScrollX=x.x;
            }
            print([x.x].reduce(max));
            // print([lol].reduce(max));
            minScrollX= min(x.x.toDouble(),x.x.toDouble());
            canvasWidth= max(maxScrollX, canvasWidth);
          }
          minX = tempOffset.reduce((value, element) => value.x<element.x? value:element);
          // var lol = int.parse(minX);
          print("mins ${minX.x}");
          minimum=minX.x;
          // print([tempOffset].reduce(max));
          // for(var x in tempOffset ){
          //   minScrollX=maxScrollX;
          //   if(minScrollX>x.x){
          //     minScrollX=x.x;
          //   }
          // }
          print("min ${minScrollX}");
          // var yMax = minz.reduce(max);
          tempOffset.add(null);
          offset.addAll(tempOffset);
          serverData = jsonObj;
          // offset = [];
          // offsetPoint = offset;
        }else if(drawAction.typeid == 2){

          offset=[];
        }
        // selectedColor = new Color(selectColor);
        // print("y = ${serverData} ");
        // for(var off in offset){
        //   print("${off.x} y = ${off.y}");
        // }
        // List<Offsets> offsets = jsonObj.offsets;

        // String pageNum =actionData.jsonobj;
        // print("pageNum ${pageNum}");
        // String offsets =actionData.offsets;
        // print("offsets ${offsets}");
        //   if(pageNum.contains('.')){
        //
        //     print("true");
        //     curHor =int.parse(pageNum.split('.')[0])-1;
        //     curVer=int.parse(pageNum.split('.')[1]);
        //   }
        //   else if(!pageNum.contains('.')){
        //     print("false");
        //     curHor =int.parse(pageNum)-1;
        //     curVer = 0;
        //   }
        //   print("${curHor}  ${curVer}");
        //   pageControllerHorizintal.jumpToPage((curHor)) ;
        //   pageControllerVertical.jumpToPage((curVer)) ;
        // print("vert ");
        // pageControllerHorizintal.animateToPage(curHor, duration: Duration(milliseconds: 1000));
        // pageControllerHorizintal.animateToPage(curVer, duration: Duration(milliseconds: 1000));
        // print(pageControllerHorizintal.page);



        // messages.add(Message.fromJson(message));
      }),
    });
    if(act==false){
      print("false");
      // pageControllerHorizintal = new PageController(initialPage:0);
      // pageControllerVertical = new PageController(initialPage:0 );
    }
  }

  Future<void> _pickStroke() async {
    //Shows AlertDialog
    return showDialog<void>(
      context: context,

      //Dismiss alert dialog when set true
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        //Clips its child in a oval shape
        return ClipOval(
          child: AlertDialog(
            //Creates three buttons to pick stroke value.
            actions: <Widget>[
              //Resetting to default stroke value
              FlatButton(
                child: Icon(
                  Icons.clear,
                ),
                onPressed: () {
                  strokeWidth = 3.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 24,
                ),
                onPressed: () {
                  strokeWidth = 10.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 40,
                ),
                onPressed: () {
                  strokeWidth = 30.0;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.brush,
                  size: 60,
                ),
                onPressed: () {
                  strokeWidth = 50.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _opacity() async {
    //Shows AlertDialog
    return showDialog<void>(
      context: context,

      //Dismiss alert dialog when set true
      barrierDismissible: true,

      builder: (BuildContext context) {
        //Clips its child in a oval shape
        return ClipOval(
          child: AlertDialog(
            //Creates three buttons to pick opacity value.
            actions: <Widget>[
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 24,
                ),
                onPressed: () {
                  //most transparent
                  opacity = 0.1;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 40,
                ),
                onPressed: () {
                  opacity = 0.5;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Icon(
                  Icons.opacity,
                  size: 60,
                ),
                onPressed: () {
                  //not transparent at all.
                  opacity = 1.0;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    RenderRepaintBoundary boundary =
    globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    //Request permissions if not already granted
    if (!(await Permission.storage.status.isGranted))
      await Permission.storage.request();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "canvas_image");
    print(result);
  }

  List<Widget> fabOption() {
    return <Widget>[
      FloatingActionButton(
        heroTag: "paint_save",
        child: Icon(Icons.save),
        tooltip: 'Save',
        onPressed: () {
          //min: 0, max: 50
          setState(() {
            _save();
          });
        },
      ),
      FloatingActionButton(
        heroTag: "paint_stroke",
        child: Icon(Icons.brush),
        tooltip: 'Stroke',
        onPressed: () {
          //min: 0, max: 50
          setState(() {
            _pickStroke();
          });
        },
      ),
      FloatingActionButton(
          heroTag: "erase",
          child: Icon(Icons.clear),
          tooltip: "Erase",
          onPressed: () {
            setState(() {
              points.clear();
            });
          }),
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_red",
        child: colorMenuItem(Colors.red),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.red;
          });
        },
      ),
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_green",
        child: colorMenuItem(Colors.green),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.green;
          });
        },
      ),
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_pink",
        child: colorMenuItem(Colors.pink),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.pink;
          });
        },
      ),
      FloatingActionButton(
        backgroundColor: Colors.white,
        heroTag: "color_blue",
        child: colorMenuItem(Colors.blue),
        tooltip: 'Color',
        onPressed: () {
          setState(() {
            selectedColor = Colors.black;
          });
        },
      ),
    ];
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
      // maxScrollX-(maxScrollX-minScrollX)
          minimum.toDouble()-180,
          duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    }
    // maxScrollX = 0;
  }


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: roomClient.roomId != null ? Text(roomClient.roomId,style: TextStyle(color: Colors.black87),) : null,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: Colors.black,),
          ),
          backgroundColor: Colors.white,


          actions: [
            FlatButton(onPressed: (){
              setState(() {
                roomClient.isMic==true?
                roomClient.disableMic():roomClient.enableMic();

              });

            },minWidth: 20, child: Icon( roomClient.isMic==true?Icons.mic:Icons.mic_off,color: Colors.black87,),),
          ],
        ),
        body: GestureDetector(

          child: RepaintBoundary(
            key: globalKey,
            child:
            Container(
              // color: Colors.black,
              decoration: BoxDecoration(
                  border: Border.all(color:Colors.black)
              ),
              width: canvasWidth*1.0,
              height:  canvasHeight*1.0,
              child: Stack(
                  children: [
                    ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        children:[
                          CustomPaint(
                            size:  Size(canvasWidth*1.0, canvasHeight*1.0),
                            painter: Sketcher(
                              offset,
                            ),
                          ),
                        ]
                    ),



                  ]
              ),

            ),
          ),
        ),
        // floatingActionButton: AnimatedFloatingActionButton(
        //   fabButtons: fabOption(),
        //   colorStartAnimation: Colors.blue,
        //   colorEndAnimation: Colors.cyan,
        //   animatedIconData: AnimatedIcons.menu_close,
        // ),
      ),
    );
  }

  Widget colorMenuItem(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          height: 30,
          width: 30,
          color: color,
        ),
      ),
    );
  }
}

class Sketcher extends CustomPainter {
  final List<Offsets> points;
  final int revision;
  // double width;
  // double height;
  Sketcher(this.points,  [this.revision = 0]);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    print('shouldRepaint old = ${oldDelegate.revision} , new = ${revision}');
    //return false; //oldDelegate.points != points;
    return true; //oldDelegate.revision != revision;
  }
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null ){
        Offset offset = new Offset(points[i].x.toDouble(),points[i].y.toDouble());
        Offset offset1 = new Offset(points[i+1].x.toDouble(),points[i+1].y.toDouble());
        canvas.drawLine(offset, offset1, paint);
      }
    }

  }
}

// class MyPainter extends CustomPainter {
//   MyPainter({this.pointsList});
//
//   //Keep track of the points tapped on the screen
//   List<Offsets> pointsList;
//   // List<Offset> offsetPoints = List();
//
//
//   //This is where we can draw on canvas.
//   @override
//   void paint(Canvas canvas, Size size) {
//     // print("length"+ offsetPoint.length.toString());
//     final paint = Paint();
//     if(pointsList != null){
//       for (var i = 0; i < pointsList.length - 1; i++) {
//         Offset startPoint = Offset(pointsList[i].x, pointsList[i].y.toDouble());
//         Offset endPoint = Offset(pointsList[i+1].x, pointsList[i+1].y.toDouble());
//         if (pointsList[i] != null && pointsList[i + 1] != null) {
//           //Drawing line when two consecutive points are available
//           // print("length"+ serverData.offsets.length.toString());
//           // print("hello x"+ offsetPoint[i].x.toString()+"y "+ offsetPoint[i].y.toString());
//           // Offset startPoint = Offset(offsetPoint[i].x, offsetPoint[i].y.toDouble());
//           // Offset endPoint = Offset(offsetPoint[i+1].x, offsetPoint[i+1].y.toDouble());
//
//           canvas.drawLine(startPoint,endPoint ,paint);
//         }else if (pointsList[i] != null && pointsList[i + 1] == null) {
//           pointsList.clear();
//           pointsList.add(startPoint);
//           pointsList.add(Offsets(
//               pointsList[i].x + 0.1, pointsList[i].y + 0.1));
//
//           //Draw points when two points are not next to each other
//           canvas.drawPoints(
//               ui.PointMode.points, offsetPoints, paint);
//         }
//         offsetPoints.add(null);
//         // offsetPoint.clear();
//         // offsetPoints.add(null);
//         // offsetPoint.add(null);
//       }
//     }else {
//       print("null");
//       // offsetPoint.add(null);
//       // offsetPoints.clear();
//     }
//   }
//   @override
//   void paint2(Canvas canvas, Size size) {
//     for (int i = 0; i < pointsList.length - 1; i++) {
//       if (pointsList[i] != null && pointsList[i + 1] != null) {
//         //Drawing line when two consecutive points are available
//         print("point= ${pointsList[i]}");
//         canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
//             pointsList[i].paint);
//       } else if (pointsList[i] != null && pointsList[i + 1] == null) {
//         offsetPoints.clear();
//         offsetPoints.add(pointsList[i].points);
//         offsetPoints.add(Offset(
//             pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
//         print("x = ${pointsList[i].points.dx + 0.1} y=${pointsList[i].points.dy + 0.1}");
//
//         //Draw points when two points are not next to each other
//         canvas.drawPoints(
//             ui.PointMode.points, offsetPoints, pointsList[i].paint);
//       }
//     }
//   }
//
//   //Called when CustomPainter is rebuilt.
//   //Returning true because we want canvas to be rebuilt to reflect new changes.
//   @override
//   bool shouldRepaint(MyPainter oldDelegate) => true;
// }
//
// class OffsetPoints {
//   Paint paint;
//   Offset offsetPoint;
//   OffsetPoints({this.offsetPoint, this.paint});
// }
// //Class to define a point touched at canvas
// class TouchPoints {
//   Paint paint;
//   Offset points;
//   TouchPoints({this.points, this.paint});
// }