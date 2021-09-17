import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:random_words/random_words.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/action_data.dart';
import 'package:lms_app/models/message.dart';
import 'package:lms_app/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import 'live/room_client.dart';
class Slide extends StatefulWidget{
  _Slide createState() => _Slide();
  final String mail;
  final String pass;
  IO.Socket socket;
  Slide({Key key, this.mail,this.socket,this.pass}) : super(key: key);


}
class _Slide extends State<Slide> {

  List<RTCVideoRenderer> remoteRenderers = [];
  RTCVideoRenderer localRenderer;
  List<Consumer> consumers = [];
  List<Producer> producers = [];
  RoomClient roomClient;
  String url;
  List<Message> messages = [];
  bool act = false;
  List<User> users = [];
  User  me;
  ActionData actionData;
  // IO.Socket socket;
  List<SSlide> slides=[];
  PageController pageControllerHorizintal;
  PageController pageControllerVertical;
  int curVer =0, curHor = 0;
  int vertpage=0;
  @override
  void initState() {
    // isTest=true;
    super.initState();
    getNewsFeed().then((slidesss){
      setState(() {
        this.slides = slidesss;
        // print("mail= "+widget.mail +"pass= "+ widget.pass);
      });
    });
    connect();
    wrtcconnect();
    // if (widget.url != null && widget.url.isNotEmpty) {
    //   print("-----------------url${widget.url}");

    // roomClient.enableWebcam();
  }

  void wrtcconnect(){

    url='${globuri}/?roomId=test-slidem&peerId=egiiii'.toLowerCase();
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
      // "name":"${widget.mail}",
      "email":"eegii@gmail.com",
      "userId":myUserId,
      "id":widget.socket.id,
      "room":"test-slidem",
      // "room": "${widget.pass}",
      "typingStatus":false
    };
    // String room = "test0429a";
    // socket.connect();
    // socket.onConnect((data) => print("Connected ${socket.id}"));
    widget.socket.emit('createUser',roomData);
    widget.socket.emit('joinRoom',roomData);
    widget.socket.on('newAction',(action)=>{
      if(this.mounted){
        setState(() {
          print("action ${action}");
          act=true;
          actionData =new ActionData.fromJson(action);
          String pageNum =actionData.pagenum;
          print("pageNum ${pageNum}");
          if(pageNum.contains('.')){

            print("true");
            curHor =int.parse(pageNum.split('.')[0])-1;
            curVer=int.parse(pageNum.split('.')[1]);
          }
          else if(!pageNum.contains('.')){
            print("false");
            curHor =int.parse(pageNum)-1;
            curVer = 0;
          }
          print("${curHor}  ${curVer}");
          pageControllerHorizintal.jumpToPage((curHor)) ;
          // pageControllerVertical = new PageController(initialPage:curVer );
          // if(curVer>0){
          // pageControllerVertical.position.jumpTo(curVer.toDouble());
          pageControllerVertical.jumpToPage(curVer) ;
          // print("vertical ewqewqewqe "+ pageControllerVertical.page.toString());

          // }
          // pageControllerVertical.page = curVer;
          // pageControllerVertical= PageController(initialPage: curVer);
          // print("vert ");
          // pageControllerHorizintal.animateToPage(curHor, duration: Duration(milliseconds: 1000));
          // pageControllerHorizintal.animateToPage(curVer, duration: Duration(milliseconds: 1000));
          // print(pageControllerHorizintal.page);

          // messages.add(Message.fromJson(message));
        }),
      }
    });
    if(act==false){
      print("false");
      pageControllerHorizintal = new PageController(initialPage:0);
      pageControllerVertical = new PageController(initialPage:0 );
    }
  }

  Future<String> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonStr);
  }

  Future<List<SSlide>> getNewsFeed() async {
    String jsonString =  await parseJsonFromAssets('assets/lesson.json');
    var jsonResponse = json.decode(jsonString);
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    List<SSlide> slides = parsed.map<SSlide>((json) => SSlide.fromJson(json)).toList(); //jsonResponse.map((i)=>Post.fromJson(i)).toList();
    // print(' slide--- ${slides.runtimeType} '); //returns List<Img>
    // print( slides[0].runtimeType); //returns Img
    return slides;
  }

  Widget get_ppt_1(String title, String subtitle,BuildContext context){
    return Container(
      color: Colors.yellow,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(right: 35, left: 35),
              padding: EdgeInsets.only(right: 22, left: 22,top: 15, bottom: 15),
              child: Text(title, style: TextStyle(fontSize: 40),textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(right: 55, left: 55),
              padding: EdgeInsets.only(right: 20, left: 20,top: 15, bottom: 15),
              child: Text(subtitle,style: TextStyle(fontSize: 25),textAlign: TextAlign.center),
            )
          ],
        ),
      ),
    );
  }
  Widget get_child_main(SSlide top, List<SSlideChild> vChild) {
    List<Widget> temp = [];
    temp.add( get_ppt_2(top.title, top.subtitle, top.body, context ) );
    for(var i= 0; i< vChild.length; i++ ) {
      if (vChild[i].type == 1) {
        temp.add(get_ppt_1(vChild[i].title, vChild[i].subtitle, context));
      } else if ( vChild[i].type == 2) {
        temp.add(get_ppt_2(vChild[i].title, vChild[i].subtitle, vChild[i].body, context));
      }
    }
    return Container(
      color: Colors.orange,
      child:PageView(
        scrollDirection: Axis.vertical,
        controller: pageControllerVertical,
        onPageChanged: (int pagee){
          // pageControllerVertical.page = curVer.toInt();
          print("vertical sddfdsf ${pageControllerVertical.page}");
          // print("vertical sddfdsf "+ pageControllerVertical.offset.toString().split('.')[0][3]);
          print("vertical ${curVer},,, "+ pagee.toString());
        },
        children: temp,
      ),
    );
  }
  Widget get_ppt_2(String title, String subtitle, List<SSlideBody> body,BuildContext context){
    var orientation = MediaQuery.of(context).orientation;
    List<Widget> temp = [];
    // Title
    temp.add(
      Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          ),
          // borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(right: 20, left: 20),
        padding: EdgeInsets.only(right: 20, left: 20,top: 5, bottom: 5),
        child: Text(title, style: TextStyle(fontSize: orientation == Orientation.portrait ? 35: 25),textAlign: TextAlign.center,),
      ),
    );
    if(subtitle != null && subtitle.length > 0 )
      temp.add(Container(
        width: MediaQuery.of(context).size.width,

        // margin: EdgeInsets.only(right: 10, left: 10),
        padding: EdgeInsets.only(right: 20, left: 20,top: 15, bottom: 15),
        child:  Text(subtitle,textAlign: TextAlign.justify, style: TextStyle(fontSize: orientation == Orientation.portrait ? 20: 10)),
      )
      );


    for(var i= 0; i< body.length; i++){
      temp.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              Container(
                child: Icon(
                  Icons.star,
                  size: 20,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(body[i].item, style: TextStyle(fontSize: orientation == Orientation.portrait ? 16 : 10)),
                    SizedBox(
                      height: 10,
                    ),
                    orientation == Orientation.portrait ? Text(body[i].descr, style: TextStyle(fontSize: 12)): Container(),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )
      );
    }
    return
      Container(
        // color: Colors.lightGreen,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: temp
          ),
        ),
      );
  }

  List<Widget> get_main_ppt(context){
    List<Widget> temp = [];
    // print('slides.length---${slides.length}');
    for(var i= 0; i< slides.length; i++){
      if (slides[i].type == 1) {
        temp.add(get_ppt_1(slides[i].title, slides[i].subtitle, context));
      } else if ( slides[i].type == 2) {
        if(slides[i].child!=null && slides[i].child.length>0) {
          // print('Adding VERTICAL pages ... len = '+slides[i].child.length.toString());
          temp.add(get_child_main(slides[i], slides[i].child));
        }
        else {
          temp.add(get_ppt_2(slides[i].title, slides[i].subtitle, slides[i].body, context));
        }
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            widget.socket.emit('leftRoom');
          },
          icon: Icon(Icons.arrow_back,color: Colors.white,),
        ),
        actions: [
          FlatButton(onPressed: (){
            setState(() {
              roomClient.isMic==true?
              roomClient.disableMic():roomClient.enableMic();

            });

          },
            minWidth: 20,
            child: Icon( roomClient.isMic==true?Icons.mic:Icons.mic_off,color: Colors.white70,),),
        ],
      ),
      body: Container(

          child:
          slides != null && slides.length > 0 ?
          PageView(

            onPageChanged: (int page){
              print("Current Horizintal" + page.toString());
            },
            controller: pageControllerHorizintal,
            pageSnapping: true,
            scrollDirection: Axis.horizontal,
            children: get_main_ppt(context),
          ): Container()
      ),
    );
  }
}

/*
Container(
                color: Colors.red,
                child:PageView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    get_ppt_1(title,subtitle, context),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.yellow,
                        child: Center(
                          child: Text('Intoduction'),
                        )
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.green,
                        child: Center(
                          child: Text('section'),
                        )
                    ),
                    Container(
                        color: Colors.grey,
                        child: Center(
                          child: Text('Dart is a client-optimized[8] programming language for apps on multiple platforms. It is developed by Google and is used to build mobile, desktop, server, and web applications.[9]'),
                        )
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.amber,
                        child:Center(
                            child: Text('The first compiler to generate JavaScript from Dart code was dartc, but it was deprecated. The second Dart-to-JavaScript compiler was Frog. It was written in Dart, but never implemented the full semantics of the language. The third Dart-to-JavaScript compiler was dart2js. An evolution of earlier compilers, dart2js is written in Dart and intended to implement the full Dart language specification and semantics.')
                        )
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.deepPurpleAccent,
                      child: Center(
                        child: Text('he first compiler to generate JavaScript from Dart code was dartc, but it was deprecated. The second Dart-to-JavaScript compiler was Frog. It was written in Dart, but never implemented the full semantics of the language. The third Dart-to-JavaScript compiler was dart2js. An evolution of earlier compilers, dart2js is written in Dart and intended to implement the full Dart language specification and semantics.'),
                      ),
                    ),
                  ],
                ),
              ),*/

class SSlide {
  int id;
  int type;
  String title;
  String subtitle;
  List<SSlideBody> body;
  List<SSlideChild> child;

  SSlide({this.id, this.type, this.title, this.subtitle, this.body, this.child});

  factory SSlide.fromJson(Map<String, dynamic> json) {
    List<SSlideBody> _body = [];
    List<SSlideChild> _child = [];
    if (json['body'] != null) {
      var bodyObjsJson = json['body'] as List;
      _body = bodyObjsJson.map((bodyJson) => SSlideBody.fromJson(bodyJson)).toList();
    }
    if (json['child'] != null) {
      var childObjsJson = json['child'] as List;
      _child = childObjsJson.map((childJson) => SSlideChild.fromJson(childJson)).toList();
    }
    return SSlide(
        id : json['id'],
        type : json['type'],
        title : json['title'],
        subtitle : json['subtitle'],
        body : _body,
        child: _child
    );
  }
  /*SSlideChild child;
  SSlide({this.id, this.type, this.title, this.subtitle});

  SSlide.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    subtitle = json['subtitle'];
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
class SSlideBody {
  String item;
  String descr;

  SSlideBody({this.item, this.descr});

  SSlideBody.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    descr = json['descr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['descr'] = this.descr;
    return data;
  }
}
class SSlideChild {
  int id;
  int type;
  String title;
  String subtitle;
  List<SSlideBody> body;
  SSlideChild({this.id, this.type, this.title, this.subtitle,this.body});

  factory SSlideChild.fromJson(Map<String, dynamic> json) {
    if (json['body'] != null) {
      var bodyObjsJson = json['body'] as List;
      List<SSlideBody> _body = bodyObjsJson.map((tagJson) => SSlideBody.fromJson(tagJson)).toList();
      return SSlideChild(
          id : json['id'],
          type : json['type'],
          title : json['title'],
          subtitle : json['subtitle'],
          body : _body
      );
    } else {
      return SSlideChild(
          id : json['id'],
          type : json['type'],
          title : json['title'],
          subtitle : json['subtitle'],
          body : []
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    return data;
  }
}

/*

import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MyWidget(),
        ),
      ),
    );
  }
}


class MyWidget extends StatefulWidget {
  @override
  _StateMyWidget createState() => _StateMyWidget();
}

class _StateMyWidget extends State<MyWidget> {
  static const _QUOTES = [
    {"quote": "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm", "author": "test"},
    {"quote": "Talk is cheap. Show me the code.", "author": "Linus Torvalds"},
    {"quote": "First, solve the problem. Then, write the code.", "author": "John Johnson"},
    {"quote": "To iterate is human, to recurse divine.", "author": "L. Peter Deutsch"},
    {"quote": "The best thing about a boolean is even if you are wrong, you are only off by a bit.", "author": "Anonymous"},
    {"quote": "Software is like sex: It’s better when it’s free.", "author": "Linus Torvalds"},
    {"quote": "The first 90% of the code accounts for the first 90% of the development time.  The remaining 10% of the code accounts for the other 90% of the development time.", "author": "Tom Cargill"},
    {"quote": "I think that it’s extraordinarily important that we in computer science keep fun in computing. When it started out it was an awful lot of fun. Of course the paying customers got shafted every now and then and after a while we began to take their complaints seriously. We began to feel as if we really were responsible for the successful error-free perfect use of these machines. I don’t think we are. I think we’re responsible for stretching them setting them off in new directions and keeping fun in the house. I hope the ﬁeld of computer science never loses its sense of fun. Above all I hope we don’t become missionaries. Don’t feel as if you’re Bible sales-men. The world has too many of those already. What you know about computing other people will learn. Don’t feel as if the key to successful computing is only in your hands. What’s in your hands I think and hope is intelligence: the ability to see the machine as more than when you were ﬁrst led up to it that you can make it more.", "author": "Alan J. Perlis"},
    {"quote":"Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live","author": "John Woods"},
    {"quote":"You've baked a really lovely cake, but then you've used dog shit for frosting.","author": "Steve Jobs"},
    {"quote": "Most software today is very much like an Egyptian pyramid with millions of bricks piled on top of each other, with no structural integrity, but just done by brute force and thousands of slaves.","author": "Alan Kay" },
    {"quote": "Software suppliers are trying to make their software packages more ‘user-friendly’…  Their best approach so far has been to take all the old brochures and stamp the words ‘user-friendly’ on the cover.","author": "Bill Gates"},
  ];

  static const AREA_LOST_PERCENT = 5;

  final rand = math.Random();

  @override
  initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timeVal) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> mapQuote = _QUOTES[rand.nextInt(_QUOTES.length)];

    final authorW =
        Text(mapQuote["author"], style: TextStyle(fontStyle: FontStyle.italic));

    final quoteW = Text(
      mapQuote["quote"],
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: autoSize(
          quoteLength: mapQuote["quote"].length,
          parentArea: (350 - 10 * 2 - 16 * 2) * (450 - 10 * 2),
        ),
      ),
    );

    final containerW0 = Container(
        height: 450.0,
        padding: EdgeInsets.all(10.0),
        color: Colors.grey,
        child: Center(child: quoteW));

    final containerW1 = Container(
        height: 500.0,
        width: 350,
        padding: EdgeInsets.all(16.0),
        color: Colors.purple,
        child: Column(children: [authorW, containerW0]));

    return containerW1;
  }

  double autoSize({@required int quoteLength, @required int parentArea}) {
    assert(quoteLength != null, "`quoteLength` may not be null");
    assert(parentArea != null, "`parentArea` may not be null");
    final areaOfLetter = parentArea / quoteLength;
    final pixelOfLetter = math.sqrt(areaOfLetter);
    final pixelOfLetterP = pixelOfLetter - (pixelOfLetter * AREA_LOST_PERCENT) / 100;
    return pixelOfLetterP;
  }
}




*/

