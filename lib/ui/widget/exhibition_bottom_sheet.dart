import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:lms_app/models/categories_model.dart';
import 'package:lms_app/ui/views/canvas.dart';
import 'package:lms_app/ui/views/live/EnterPage.dart';
import 'package:lms_app/ui/views/live/Presentation/Room.dart';
import 'package:lms_app/ui/views/quiz.dart';
import 'package:lms_app/ui/views/tsas.dart';
import 'package:lms_app/ui/views/sslide.dart';

import '../../globalValues.dart';

const double minHeight = 120;
const double iconStartSize = 44;
const double iconEndSize = 120;
const double iconStartMarginTop = 36;
const double iconEndMarginTop = 80;
const double iconsVerticalSpacing = 24;
const double iconsHorizontalSpacing = 16;

class ExhibitionBottomSheet extends StatefulWidget {

  // List<Lessons> lessons;
  // ExhibitionBottomSheet({this.lessons});
  List<ListItem> lessons;
  IO.Socket socket;
  ExhibitionBottomSheet({this.socket,this.lessons});
  @override
  _ExhibitionBottomSheetState createState() => _ExhibitionBottomSheetState(socket);
}

class _ExhibitionBottomSheetState extends State<ExhibitionBottomSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  _ExhibitionBottomSheetState(IO.Socket socket);

  double get maxHeight => MediaQuery.of(context).size.height;

  double get headerTopMargin =>
      lerp(20, 20 + MediaQuery.of(context).padding.top);

  double get headerFontSize => lerp(16, 24);

  double get itemBorderRadius => lerp(8, 24);

  double get iconLeftBorderRadius => itemBorderRadius;

  double get iconRightBorderRadius => lerp(8, 0);

  double get iconSize => lerp(iconStartSize, iconEndSize);

  double iconTopMargin(int index) =>
      lerp(iconStartMarginTop,
          iconEndMarginTop + index * (iconsVerticalSpacing + iconEndSize)) +
          headerTopMargin;

  double iconLeftMargin(int index) =>
      lerp(index * (iconsHorizontalSpacing + iconStartSize), 0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          height: lerp(minHeight, maxHeight-50),
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: _toggle,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              decoration: const BoxDecoration(
                /*color: Color(0xFF162A49)*/
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color(0xff480048),
                      Color(0xffc04848)
                    ]),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Stack(
                children: <Widget>[
                  MenuButton(),
                  SheetHeader(
                    fontSize: headerFontSize,
                    topMargin: headerTopMargin,
                  ),
                  /*for (Event event in events) _buildFullItem(event),
                  for (Event event in events) _buildIcon(event),*/
                  for (ListItem lesson in widget.lessons) _buildFullItem(lesson),
                  for (ListItem lesson in widget.lessons) _buildIcon(lesson),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(ListItem lesson) {
    int index = widget.lessons.indexOf(lesson);
    return Positioned(
      height: iconSize,
      width: iconSize,
      top: iconTopMargin(index),
      left: iconLeftMargin(index),
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(iconLeftBorderRadius),
          right: Radius.circular(iconRightBorderRadius),
        ),
        child: InkWell(
          onTap: (){
            if(index==0){
              isTest=false;

              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return Slide(socket:widget.socket);
              }));
            }else if(index == 1){
              isTest=false;
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return CanvasPainting(socket:widget.socket);
              }));
            }else if(index == 2){
              isTest=false;
              // Navigator.push(context, MaterialPageRoute(builder: (_) {
              //   return Room(url: 'https://meet.oyuntan.mn/roomId=test0523a&peerId=eegii'.toLowerCase(),);
              //   // return EnterPage();
              // }));
              // MaterialPageRoute(builder: (context) => Room(url: 'https://meet.oyuntan.mn/roomId=test0523a&peerId=eegii'.toLowerCase(),),);
              Navigator.push( context,MaterialPageRoute(builder: (context) {

               return Room( url: '${globuri}/?roomId=live-test&peerId=eegii'.toLowerCase(),);
              }),

              );
            }else{
              isTest=true;
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return QuistionScreen(socket:widget.socket);
              }));

            }
            print("${index}infefefefefe");
            print("socket ${widget.socket.id}");

          },
          child: Image.asset("assets/images/" + lesson.img,
            // image:
            // NetworkImage("http://surgalt.gov.mn/" + lesson.img),
            alignment: Alignment(lerp(1, 0), 0),
            fit: BoxFit.cover,

          ),
        ),
      ),
    );
  }

  Widget _buildFullItem(ListItem lesson) {
    int index = widget.lessons.indexOf(lesson);
    return ExpandedEventItem(
      topMargin: iconTopMargin(index),
      leftMargin: iconLeftMargin(index),
      height: iconSize,
      isVisible: _controller.status == AnimationStatus.completed,
      borderRadius: itemBorderRadius,
      title: lesson.name,
      date: lesson.time,
      lesName: lesson.image,
    );
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;
    _controller.fling(velocity: isOpen ? -2 : 2);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }
}

class ExpandedEventItem extends StatelessWidget {
  final double topMargin;
  final double leftMargin;
  final double height;
  final bool isVisible;
  final double borderRadius;
  final String title;
  final String date;
  final String lesName;

  const ExpandedEventItem(
      {Key key,
        this.topMargin,
        this.height,
        this.isVisible,
        this.borderRadius,
        this.title,
        this.date,
        this.lesName,
        this.leftMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      left: leftMargin,
      right: 0,
      height: height,
      child: AnimatedOpacity(
        opacity: isVisible ? 1 : 0,
        duration: Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: height).add(EdgeInsets.all(8)),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              'Багшийн нэр',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(width: 8),
            Text(
              date,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: <Widget>[
            // Icon(Icons.place, color: Colors.grey.shade400, size: 16),
            Text(
              'Хичээлийн нэр',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            SizedBox(width: 8),

          ],
        ),
        Row(
          children: <Widget>[
            Text(
              lesName,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: Colors.black87,
              ),
            ),
          ],
        )
      ],
    );
  }
}

final List<Event> events = [
  Event('steve-johnson.jpeg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('efe-kurnaz.jpg', 'Shenzhen GLOBAL DESIGN AWARD 2018', '4.20-30'),
  Event('rodion-kutsaev.jpeg', 'Dawan District Guangdong Hong Kong', '4.28-31'),

];

class Event {
  final String assetName;
  final String title;
  final String date;

  Event(this.assetName, this.title, this.date);
}

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {Key key, @required this.fontSize, @required this.topMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topMargin,
      child: Text(
        'Шууд хичээлүүд',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      bottom: 24,
      child: InkWell(
        onTap: (){

        },
        child: Icon(
          Icons.menu,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
