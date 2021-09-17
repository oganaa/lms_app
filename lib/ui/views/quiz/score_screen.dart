import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import '../home_view.dart';
import '../quiz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ScoreScreen extends StatefulWidget {
  IO.Socket socket;
  ScoreScreen({this.socket});

  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  double totalscore =0.0;
  @override
  void initState() {

   widget.socket.on('sendAnswer', (data) {
      setState(() {

        print("Connectedsssss ${data}");
        totalscore=data['totalScore'];
      });
    });
    // widget.socket.on('sendAnswer', (data) => totalscore=data['totalScore']);
    print(totalscore);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    QuistionScreen questionScreen;
    print("");
    // QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => HomeView()))),
        // Fluttter show the back button automatically
        // backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(),
              Text(
                "Таны оноо ${totalscore!=null?totalscore.toStringAsFixed(2):0}",
                // "${questionScreen.queCtrl.answer.toString() * 10}/${questionScreen.selectedIndex.length * 10}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}