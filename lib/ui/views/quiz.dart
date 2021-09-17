import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:random_words/random_words.dart';
import 'package:lms_app/models/quesion_ctrl.dart';
import 'package:lms_app/ui/views/quiz/components/question_card.dart';
import 'package:lms_app/ui/views/quiz/quiz_screen.dart';

import 'package:lms_app/ui/views/quiz/components/widgetss.dart' as globalSelect;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lms_app/ui/views/quiz/score_screen.dart';
import '../../constants.dart';
import '../../globalValues.dart';
import 'home_view.dart';
import 'live/room_client.dart';

class QuistionScreen extends StatefulWidget {
  QuistionScreen({Key key,this.socket, this.selectedIndex, this.queCtrl}) : super(key: key);

  IO.Socket socket;
  QuestionCtrl queCtrl;
  var selectedIndex;
  @override
  _QuistionScreenState createState() => _QuistionScreenState();
}

// String formatTime(int milliseconds) {
//   var secs = milliseconds ~/ 1000;
//   var hours = (secs ~/ 3600).toString().padLeft(2, '0');
//   var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
//   var seconds = (secs % 60).toString().padLeft(2, '0');
//   return "$hours:$minutes:$seconds";
//
// }
class _QuistionScreenState extends State<QuistionScreen>
    with TickerProviderStateMixin {
  List<QuestionCtrl> questionCtrl = [];
  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;


  List<RTCVideoRenderer> remoteRenderers = [];
  RTCVideoRenderer localRenderer;
  List<Consumer> consumers = [];
  List<Producer> producers = [];
  RoomClient roomClient;

  AnimationController _animationController;
  Animation _animation;

  // so that we can access our animation outside
  Animation get animation => this._animation;

  int _correctAns;
  int get correctAns => this._correctAns;

  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  // Stopwatch _stopwatch;
  Timer _timer;
  int _start = 300;
  int currentSeconds = 0;

  List bogolsonId = [];
  int _bogolson;
  int _selectedAns;
  int get selectedAns => this._selectedAns;
  PageController _pageController = PageController();

  // PageController _pageController;
  // PageController get pageController => this._pageController;
  List data = List();
  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  String url;
  var list;
  List<int> changepage;
  String get timerText =>
      '${((_start - currentSeconds) ~/ 3600).toString().padLeft(2, '0')} : ${(((_start - currentSeconds) % 3600)~/60).toString().padLeft(2, '0')}: ${((_start - currentSeconds) % 60).toString().padLeft(2, '0')}';

  Future<List<QuestionCtrl>> getSWData() async {
    // String url = '';
    var res =
    await http.get("${globuri}/api/pg/lessonQuestions/find");

    if (res.statusCode == 200) {
      final resBody = json.decode(res.body);
      // print("body ${resBody['message']} ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      // setState(() {
      data = resBody['message'];
      // });
      List<QuestionCtrl> slides = data
          .map<QuestionCtrl>((json) => QuestionCtrl.fromJson(json))
          .toList();
      // print("boddvsvdsy datatatat}");
      // print("slides datatatat${slides}");
      return slides;
    }

    // print("body datatatat}");
    // print("body datatatat${data}");
    return data
        .map<QuestionCtrl>((json) => QuestionCtrl.fromJson(json))
        .toList();
  }
  @override
  void setState(fn) {
    // TODO: implement setState

    if(globalSelect.SaveAnswers.length>0) {
      for(var i=0;i<globalSelect.SaveAnswers.length;i++){
        for(var j=0;j<questionCtrl.length;j++){
          if(globalSelect.SaveAnswers[i]['questionId']==questionCtrl[j].id) {
            list = globalSelect.SaveAnswers.firstWhere((element) {
              return element['questionId'] == questionCtrl[j].id;
            });
          }
        }
      }
      if(list!=null){
        for(var j=0;j<questionCtrl.length;j++){
          // for(var i=0;i<questionCtrl[j].body_json.length;i++){
          if(questionCtrl[j].id==list['questionId']){
            // bogolson = true;
            bogolsonId.add(questionCtrl[j].id);
            // print(" bo iddd ${bogolsonId}");
          }

          // }
        }

        _bogolson= bogolsonId.indexOf(bogolsonId);
        print("list ${list} boglogdson bnaa");
      }else{
        // print("hooson");
      }
      print("global length ${globalSelect.SaveAnswers}");

    }
    super.setState(fn);
  }
  @override
  void initState() {

    isTest=true;
    super.initState();
    // this.getSWData();
    getSWData().then((slidesss) {
      setState(() {
        // print("init ${slidesss[0].title}");
        this.questionCtrl = slidesss;
        // print("mail= "+widget.mail +"pass= "+ widget.pass);
      });
    });
    connect();
    changepage = new List<int>(questionCtrl.length);
    startTimeout();
    wrtcconnect();
    // _stopwatch = Stopwatch();
    // _stopwatch.start();
    // _timer = new Timer.periodic(new Duration(milliseconds: 60), (timer) {
    //   setState(() {});
    // });
  }
  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // print(timer.tick);
        // print("end time ${timerText}");
        currentSeconds = timer.tick;

        if (timer.tick >= _start) {
          timer.cancel();
          finishQuiz();
        };
      });
    });
  }
  List<QuestionCtrl> get questions => this.questionCtrl;

  Future<String> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath).then((jsonStr) => jsonStr);
  }

  // http://localhost:8000/api/pg/lessonQuestions/find
  Future<List<QuestionCtrl>> getNewsFeed() async {
    String jsonString = await parseJsonFromAssets('assets/quiz.json');
    var jsonResponse = json.decode(jsonString);
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    List<QuestionCtrl> slides = parsed
        .map<QuestionCtrl>((json) => QuestionCtrl.fromJson(json))
        .toList(); //jsonResponse.map((i)=>Post.fromJson(i)).toList();
    // print(' slide--- ${slides.runtimeType} '); //returns List<Img>
    // print( slides[0].runtimeType); //returns Img
    return slides;
  }

  void wrtcconnect(){

    url='https://meetsocket.oyuntan.mn/?roomId=test-exam2&peerId=egiiii'.toLowerCase();
    Uri uri = Uri.parse(url);
    print("uriiii ---------------------${uri}");
    roomClient = RoomClient(
      displayName: nouns[Random.secure().nextInt(2500)],
      roomId: uri.queryParameters['roomid'] ?? randomAlpha(8).toLowerCase(),
      peerId: uri.queryParameters['peerid'] ?? randomAlpha(8),
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
    // remoteRenderers.forEach((element) {
    //   element?.dispose();
    // });
    roomClient.close();
    super.dispose();
  }
  void connect() async {
    // print("${GlobalData.datosusuario}");
    // GlobalData.datosusuario;
    // socket = await IO.io('https://meet.oyuntan.mn/', <String, dynamic>{
    // socket = await IO.io('http://localhost:8000/', <String, dynamic>{
    // socket = await IO.io('http://192.168.17.29:8000/', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    Map<String,dynamic> roomData = {
      "name":"erdene",
      // "name":"${widget.mail}",
      "email":"erdene@gmail.com",
      "userId":myUserId,
      "id":widget.socket.id,
      "isMobile":1,
      "room":"test-exam2",
      // "room": "${widget.pass}",
      "typingStatus":false
    };
    // String room = "test0429a";
    // socket.connect();
    // socket.onConnect((data) => print("Connected ${socket.id}"));
    widget.socket.emit('createUser',roomData);
    widget.socket.emit('joinRoom',roomData);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () =>
                Navigator.pop(context)),
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // ignore: deprecated_member_use
          // FlatButton(onPressed: previousPage, child: Text("back")),
          // _questionNumber.value==questionCtrl.length?
          FlatButton(onPressed: () =>
          {
            // globalSelect.SaveAnswers=[],
            // widget.socket.emit('sendAnswer',{
            //   'id': widget.socket.id,
            //   'msg':{
            //     'isFinish': true,
            //     'userId':1,} },),
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (_) => ScoreScreen(socket: widget.socket,)))
            finishQuiz()
          }, child: Text("Дуусгах"))
          //     :
          // FlatButton(onPressed: nextPage, child: Text("Next")),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Text.rich(
                        TextSpan(
                          text: "Асуулт ${_questionNumber.value}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: kSecondaryColor),
                          children: [
                            TextSpan(
                              text: "/${questionCtrl.length} ",

                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: kSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // _stopwatch.isRunning?Text(formatTime(_stopwatch.elapsedMilliseconds),  style: TextStyle(fontSize: 28.0),textAlign: TextAlign.end,):Container(),
                    Padding(
                      padding: const EdgeInsets.only(right: kDefaultPadding),
                      child: Text(timerText,  style: TextStyle(fontSize: 24.0,color: (_start-currentSeconds)<10?Colors.red:Colors.black),textAlign: TextAlign.end, ),
                    ),
                    // ElevatedButton(onPressed: handleStartStop, child: Text(_stopwatch.isRunning ? 'Stop' : 'Start'))

                  ],
                ),
                Divider(thickness: 1.5),
                SizedBox(height: kDefaultPadding),
                Expanded(
                    child: PageView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: updateTheQnNum,
                      itemCount: questionCtrl.length,
                      itemBuilder: (context, index) =>  QuestionCard(socket:widget.socket,
                        questionCtrl: questionCtrl[index],
                      ),
                      // onPageChanged: (int page){
                      // print("Current Horizintal" + page.toString());
                      // },
                    )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.bottomCenter,
                  height: 50.0,
                  width: double.infinity,
                  child: ListView.builder(
                    // controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: questionCtrl.length,

                    itemBuilder: (_, int index) {
                      bogolsonId.map((e) => Container());
                      for(var k=0;k<bogolsonId.length;k++){
                        if(questionCtrl[index].id==bogolsonId[k]){
                          return Container(

                              width: 50.0,
                              padding: EdgeInsets.all(5),
                              child: RawMaterialButton(
                                onPressed: (){
                                  setState(() {
                                    currentPage(index+1);
                                  });},
                                elevation: 2.0,
                                fillColor: index+1==_questionNumber.value?Colors.lightBlueAccent:Colors.green,
                                // globalSelect.SaveAnswers[0]['questionId']==questionCtrl[index].id?Colors.green:
                                child: Text(
                                  '${index+1}',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                padding: EdgeInsets.all(5.0),
                                splashColor: Colors.cyan,
                                // shape: CircleBorder(),
                              )
                            //     RaisedButton(
                            //
                            //       onPressed: () {
                            //         setState(() {
                            //           currentPage();
                            //           print("true");
                            //         });
                            //       },
                            //       color: index+1==_questionNumber.value?Colors.blue:Colors.deepOrange,
                            //       textColor: Colors.white,
                            //
                            //
                            //       shape: CircleBorder(side: BorderSide.none),
                            //       child: Text(
                            //       '${index+1}',
                            //       style: TextStyle(fontSize: 12.0),
                            //     ),
                            // )
                          );
                        }
                      }

                      return Container(

                          width: 50.0,
                          padding: EdgeInsets.all(5),
                          child: RawMaterialButton(
                            onPressed: (){
                              setState(() {
                                currentPage(index+1);
                              });},
                            elevation: 2.0,
                            fillColor: index+1==_questionNumber.value?Colors.lightBlueAccent:Colors.white,
                            // fillColor: index+1==_questionNumber.value?Colors.lightBlueAccent:(bogolson? Colors.green: Colors.white),
                            // globalSelect.SaveAnswers[0]['questionId']==questionCtrl[index].id?Colors.green:
                            child: Text(
                              '${index+1}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            padding: EdgeInsets.all(5.0),
                            splashColor: Colors.cyan,
                            // shape: CircleBorder(),
                          )
                        //     RaisedButton(
                        //
                        //       onPressed: () {
                        //         setState(() {
                        //           currentPage();
                        //           print("true");
                        //         });
                        //       },
                        //       color: index+1==_questionNumber.value?Colors.blue:Colors.deepOrange,
                        //       textColor: Colors.white,
                        //
                        //
                        //       shape: CircleBorder(side: BorderSide.none),
                        //       child: Text(
                        //       '${index+1}',
                        //       style: TextStyle(fontSize: 12.0),
                        //     ),
                        // )
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  void updateTheQnNum(int index) {

    setState(() {

      globalSelect.selChild=[];
      _questionNumber.value = index + 1;
      // print(_questionNumber);
    });
  }

  void finishQuiz(){

    // remoteRenderers.forEach((element) {
    //   element?.dispose();
    // });
    localRenderer?.dispose();
    isTest=false;
    roomClient.close();
    globalSelect.SaveAnswers=[];
    widget.socket.emit('sendAnswer',{
    'id': widget.socket.id,
    'msg':{
    'isFinish': true,
    'userId':myUserId,} },);
    widget.socket.emit('leftRoom');
    Navigator.push(context,
    MaterialPageRoute(builder: (_) => ScoreScreen(socket: widget.socket,)));
  }
  void currentPage(int index) {
    var i=0;
    print("index $index ${_pageController.page}");
    globalSelect.selChild=[];
    if(index>_pageController.page){
      i = index-1 - _pageController.page.toInt();
      _pageController.animateToPage(
        _pageController.page.toInt() + i,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }else{
      i = _pageController.page.toInt() - index+1;
      _pageController.animateToPage(
        _pageController.page.toInt() - i,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }

  }
  void nextPage() {
    _pageController.animateToPage(
      _pageController.page.toInt() + 1,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  void previousPage() {
    _pageController.animateToPage(_pageController.page.toInt() - 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void checkAns() {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = widget.queCtrl.answer as int;
    _selectedAns = widget.selectedIndex;
    print("hgfdh ${_selectedAns}");

    if (_correctAns == _selectedAns) _numOfCorrectAns++;

    // It will stop the counter
    // _animationController.stop();
    // update();

    // Once user select an ans after 3s it will go to the next qn
  }

// Widget get_ppt_1(String title, List<Body> body,BuildContext context){
//   return Container(
//     color: Colors.yellow,
//     child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             margin: EdgeInsets.only(right: 60, left: 60),
//             padding: EdgeInsets.only(right: 30, left: 30,top: 15, bottom: 15),
//             child: Text(title, style: TextStyle(fontSize: 50),textAlign: TextAlign.center,),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.black,
//                 width: 1,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             margin: EdgeInsets.only(right: 85, left: 85),
//             padding: EdgeInsets.only(right: 30, left: 30,top: 15, bottom: 15),
//             child: Text( body.toString(),style: TextStyle(fontSize: 30),textAlign: TextAlign.center),
//           )
//         ],
//       ),
//     ),
//   );
// }
// Widget get_child_main(QuestionCtrl top, List<Child> vChild) {
//   List<Widget> temp = [];
//   temp.add( get_ppt_2(top.title, top.subtitle, top.body, context ) );
//   for(var i= 0; i< vChild.length; i++ ) {
//     // if (vChild[i].type == 1) {
//     //   temp.add(get_ppt_1(vChild[i].title, vChild[i].subtitle, context));
//     // } else if ( vChild[i].type == 2) {
//       temp.add(get_ppt_2(vChild[i].id.toString(), vChild[i].item, vChild[i].descr), context));
//     // }
//   }
//   return Container(
//     color: Colors.orange,
//     child:PageView(
//       scrollDirection: Axis.vertical,
//       onPageChanged: (int pagee){
//         // print("vertical sddfdsf "+ pageControllerVertical.offset.toString().split('.')[0][3]);
//         print("vertical "+ pagee.toString());
//       },
//       // controller: pageControllerVertical,
//       children: temp,
//     ),
//   );
// }
// Widget get_ppt_2(String title, String subtitle, List<Body> body,BuildContext context){
//   var orientation = MediaQuery.of(context).orientation;
//   List<Widget> temp = [];
//   // Title
//   temp.add(
//     Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
//         ),
//         // borderRadius: BorderRadius.circular(12),
//       ),
//       margin: EdgeInsets.only(right: 40, left: 40),
//       padding: EdgeInsets.only(right: 20, left: 20,top: 5, bottom: 5),
//       child: Text(title, style: TextStyle(fontSize: orientation == Orientation.portrait ? 50: 40),textAlign: TextAlign.center,),
//     ),
//   );
//   if(subtitle != null && subtitle.length > 0 )
//     temp.add(Container(
//       width: MediaQuery.of(context).size.width,
//
//       margin: EdgeInsets.only(right: 20, left: 20),
//       padding: EdgeInsets.only(right: 20, left: 20,top: 15, bottom: 15),
//       child:  Text(subtitle,textAlign: TextAlign.justify, style: TextStyle(fontSize: orientation == Orientation.portrait ? 20: 10)),
//     )
//     );
//
//
//   for(var i= 0; i< body.length; i++){
//     temp.add(
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               width: 30,
//             ),
//             Container(
//               child: Icon(
//                 Icons.star,
//                 size: 20,
//               ),
//             ),
//             SizedBox(
//               width: 10,
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(body[i].item, style: TextStyle(fontSize: orientation == Orientation.portrait ? 20 : 10)),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   orientation == Orientation.portrait ? Text(body[i].descr, style: TextStyle(fontSize: 12)): Container(),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: 20,
//             ),
//           ],
//         )
//     );
//   }
//   return
//     Container(
//       // color: Colors.lightGreen,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: temp
//         ),
//       ),
//     );
// }
// void nextQuestion() {
//   print("length ${questionCtrl.length}");
//   for (var i = 0; i < questionCtrl.length; i++) {
//     print("next ${questionCtrl[i].title}");
//   }
// }
}
