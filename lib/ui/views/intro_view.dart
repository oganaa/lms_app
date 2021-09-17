import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_app/constants/route_names.dart';
import 'package:lms_app/services/navigation_service.dart';
import 'package:lms_app/ui/widget/story_view.dart';
import '../../locator.dart';

class IntroView extends StatelessWidget{
  final stController = StoryController();
  final NavigationService _navigationService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_white.png',
                fit: BoxFit.contain,
                height: ScreenUtil().setHeight(52),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('УДАМ сүлжээ',style: TextStyle(fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false) ),))
            ],
          )
      ),
      body: StoryView(
        [
          StoryItem.pageImage(
              AssetImage('assets/logo_white2.png'),
              Color.fromRGBO(0, 102, 174, 1),//Colors.blue,
              imageFit : BoxFit.scaleDown,
              imageWidth : ScreenUtil().setWidth(280),
              caption: ''
          ),
          StoryItem.pageImage(
            AssetImage('assets/b.rinchen.png'), //logo_2a.png
            Colors.white,
            fontSizee : ScreenUtil().setSp(42, allowFontScalingSelf: false),
            imageFit : BoxFit.contain,
            imageWidth : ScreenUtil().setWidth(280),
            captionM: "ᠴᠢᠬᠢᠨ ᠦ ᠴᠢᠮᠡᠭ ᠪᠣᠯᠤᠭᠰᠠᠨ ᠠᠶᠠᠯᠭᠤ ᠰᠠᠶᠢᠬᠠᠨ ᠮᠣᠩᠭᠣᠯ ᠬᠡᠯᠡ  \n"+
                "ᠴᠢᠨ ᠵᠣᠷᠢᠭᠲᠤ ᠡᠪᠦᠭᠡ ᠳᠡᠭᠡᠳᠦᠰ ᠦᠨ ᠮᠢᠨᠢ ᠥᠪ ᠶᠡᠬᠡ ᠡᠷᠳᠡᠨᠢ\n"  +
                "ᠰᠤᠨᠤᠰᠬᠤ ᠪᠦᠷ ᠢᠷᠠᠭᠤ ᠪᠠᠶᠠᠯᠢᠭ ᠢ ᠭᠠᠶᠢᠬᠠᠨ ᠪᠠᠶᠠᠰᠴᠢ \n"+
                "ᠰᠣᠳᠣ ᠶᠡᠬᠡ ᠪᠢᠯᠢᠭᠲᠦ ᠲᠦᠮᠡᠨ ᠶᠦᠭᠡᠨ ᠪᠢᠰᠢᠷᠡᠨ ᠮᠠᠭᠲᠠᠮᠤ ᠪᠢ",
            fontNameM: 'Classical Mongolian Dashtseden',
          ),
          StoryItem.pageImage(
            AssetImage('assets/d.natsagdorj.png'), //logo_2
            Color.fromRGBO(0, 102, 174, 1), //Colors.blue, // indigo, //Colors.white,
            fontSizee : ScreenUtil().setSp(70, allowFontScalingSelf: false),
            imageFit : BoxFit.contain,
            imageWidth : ScreenUtil().setWidth(280),
            captionM: "ᠥᠰᠬᠦ ᠡᠴᠡ ᠰᠤᠷᠠᠭᠰᠠᠨ ᠦᠨᠳᠦᠰᠦᠨ ᠦ ᠬᠡᠯᠡ \n"+
                "ᠮᠠᠷᠲᠠᠵᠤ ᠪᠣᠯᠣᠰᠢ ᠦᠭᠡᠢ ᠰᠤᠶᠤᠯ\n" +
                "ᠦᠬᠦᠲᠡᠯ᠎ᠡ ᠤᠷᠤᠰᠢᠬᠤ ᠲᠥᠷᠥᠯᠬᠢ ᠨᠤᠲᠤᠭ\n"+
                "ᠰᠠᠯᠵᠤ ᠪᠣᠯᠣᠰᠢ ᠦᠭᠡᠢ ᠣᠷᠣᠨ",
            //fontNameM: 'MenksoftQagan', //'Classical Mongolian Dashtseden',
          ),
          StoryItem.pageImage(
            AssetImage('assets/logo_1a.png'),
            Colors.white,
            imageFit : BoxFit.scaleDown,
            imageWidth : ScreenUtil().setWidth(700),
            caption: "Монгол хүн бүрт зориулав...",
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
          _navigationService.navigateTo(LoginViewRoute);
        },
        progressPosition: ProgressPosition.bottom,
        repeat: false,
        controller: stController,
      ),
    );
  }

}