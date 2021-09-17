import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:lms_app/controller/home_ctrl.dart';
import 'package:lms_app/models/Content.dart';
import 'package:lms_app/models/categories_model.dart';
import 'package:lms_app/ui/widget/exhibition_bottom_sheet.dart';

import 'chat/chatHome.dart';
class HomeView extends StatelessWidget
{

  List<ListItem> tless=[
    ListItem(
        "kiber-security",
        "Слайд хичээл",
        "15",
        'slide.jpg',
        'Болд'
    ),
    ListItem(
        "ios",
        "Самбарын хийчээл",
        "20",
        'board.jpg',
        'Уянга'
    ),
    ListItem(
        "hello",
        "Live хийчээл",
        "20",
        'live.jpg',
        'Бат'
    ),
    ListItem(
        "vfdfbfdb",
        "Шалгалт",
        "20",
        'online.jpg',
        'Очир'
    ),
  ];
  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return ViewModelBuilder<HomeCtrl>.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => HomeCtrl(),
        onModelReady: (model) {

          model.initialise();
        },
        builder: (context, model, _) => MaterialApp(
          home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setHeight(5),left:ScreenUtil().setWidth(20)),
                          child: Image.asset(
                            "assets/images/efe-kurnaz.png",
                            // "assets/images/images.png",
                            fit: BoxFit.fill,
                            height: ScreenUtil().setHeight(90),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setHeight(35),left:ScreenUtil().setWidth(110)),
                          child: Column(
                            children: <Widget>[
                              Text('Багшийн Мэргэжил \nДээшлүүлэх Институт',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue
                                ),),

                            ],
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: (){},
                        child: IconButton(
                          onPressed: (){

                            Navigator.push(context, MaterialPageRoute(builder: (_) {
                              return  ChatHome(socket:model.socket);
                            }));
                          },
                          icon: Icon(
                            Icons.messenger,
                            size: 25,
                            color: Colors.white,
                          ),
                        )
                    )
                  ],
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            Color(0xff480048),
                            Color(0xffc04848)
                          ])
                  ),
                ),
                elevation: 0,
                //backgroundColor: Colors.transparent,
              ),
              body:Stack(
                children: <Widget>[
                  SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Center(
                        //   child: Stack(
                        //     children: <Widget>[
                        //       Container(
                        //         width: MediaQuery.of(context).size.width,
                        //         child: Image.asset('assets/images/stateHouse.jpg',
                        //             height: 150,
                        //             fit: BoxFit.fill),
                        //       ),
                        //       Positioned(
                        //         top: 100,
                        //         left:10,
                        //         child: Column(
                        //           children: <Widget>[
                        //             Text('ДИЖИТАЛ ШИЛЖИЛТ',style: TextStyle(
                        //                 fontSize: 15,
                        //                 color: Colors.white
                        //             ),),
                        //             SizedBox(height: 10),
                        //             Text('Дижитал шилжилтийн үед хэрэг болох ур чадваруудыг та эзэмшсэн үү?',style: TextStyle(
                        //                 fontSize: 10,
                        //                 color: Colors.white
                        //             ),),
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        model.content != null && model.content.categories != null && model.content.categories.length > 0 ? Container(
                          height: ScreenUtil().setHeight(1100),
                          child:ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: model.content.categories.length,
                              controller: model.controller,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    title(model.content.categories[index].name.toUpperCase()),
                                    SizedBox(height: 8),
                                    categories(context,model.content.categories[index],model),
                                    SizedBox(height: 10),
                                  ],
                                );
                              }),
                        ): Container(),
                        SizedBox(height: 200)
                      ],
                    ),
                  ),

                  model.content != null && model.content.categories != null && model.content.categories.length > 0 ?
                  ExhibitionBottomSheet(lessons: tless,socket:model.socket):Container(), //use this or
                  // ScrollableExhibitionSheet
                ],

              ),
            ),
          ),
        )
    );
  }
  Widget title(String txt){
    return Container(
      margin: EdgeInsets.only(left: 20, top: 10),
      child: Text(txt,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            fontFamily: 'NunitoSemiBold'
        ),),
    );
  }
  Widget categories (BuildContext context,Categories cat,HomeCtrl model){
    double _userRating = 3.0;
    IconData _selectedIcon;
    return Container(
      height:  MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: cat.items.length,
          controller: model.controller,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width: 170,
              child: InkWell(
                onTap: (){
                  model.jumpDetail();
                },
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  margin: EdgeInsets.only(left: 20.0, right: 0.0, bottom: 3.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image(
                          image:
                          NetworkImage("http://surgalt.gov.mn/" + cat.items[index].imgUrl),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Padding(
                          padding:EdgeInsets.only(top: 5, left: 2, right: 2, bottom: 0),
                          child: Expanded(
                            child: Text(
                              cat.items[index].name,
                              style: TextStyle(color: Colors.black87, fontSize: 10.0, fontFamily: 'NunitoBold'),
                            ),
                          )
                      ),
                      // SizedBox(height: 5,),
                      // RatingBarIndicator(
                      //   rating: _userRating,
                      //   itemBuilder: (context, index) => Icon(
                      //     _selectedIcon ?? Icons.star,
                      //     color: Colors.amber,
                      //   ),
                      //   itemCount: 5,
                      //   itemSize: 10.0,
                      //   unratedColor: Colors.amber.withAlpha(50),
                      //   direction: Axis.horizontal,
                      // ),
                      Padding(
                          padding:EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 0),
                          child: Expanded(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 13,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  cat.items[index].duration,
                                  style: TextStyle(color: Colors.black87, fontSize: 10.0, fontFamily: 'NunitoRegular'),
                                )
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            );

          }),
    );
  }
}


