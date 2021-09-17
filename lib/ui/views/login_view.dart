import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lms_app/controller/login_controller.dart';
import 'package:lms_app/ui/views/canvas.dart';
import 'package:lms_app/utils/bubble_indication_painter.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode name = FocusNode();
  final FocusNode mail = FocusNode();
  final FocusNode position = FocusNode();
  final FocusNode password = FocusNode();
  final FocusNode passwordDone = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    // TODO: implement build
    return ViewModelBuilder<LoginController>.reactive(
      viewModelBuilder: ()=>LoginController(),
      disposeViewModel: false,
      onModelReady: (model) => model.initialise(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height >= ScreenUtil().setHeight(750)
                ? MediaQuery.of(context).size.height
                : ScreenUtil().setHeight(750),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color(0xff480048),
                      Color(0xffc04848)
                    ])
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Align(
                    alignment : Alignment.topCenter,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/images/background.jpg",
                            fit: BoxFit.cover,
                            height: ScreenUtil().setHeight(480),
                          ),

                        ),
                        Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setHeight(105),left:ScreenUtil().setWidth(130)),
                          child:Column(
                            children: <Widget>[
                              Text('Багшийн Мэргэжил \nДээшлүүлэх Институт',
                                style: TextStyle(
                                    fontSize: 12,

                                    color: Colors.blue[500]
                                ),),

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setHeight(70),left:ScreenUtil().setWidth(40)),
                          child: Image.asset(
                            "assets/images/efe-kurnaz.png",
                            // "assets/images/images.png",
                            fit: BoxFit.fill,
                            height: ScreenUtil().setHeight(90),
                          ),
                        ),
                      ],
                    )
                ),

                Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
                  child: buildMenuBar(context, model),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (i) {
                      model.onChangePage(i);
                    },
                    children: <Widget>[
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: buildSignIn(context,model),
                      ),
                      new ConstrainedBox(
                        constraints: const BoxConstraints.expand(),
                        child: buildSignUp(context,model),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void showInSnackBar(String value, BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.blue,
            fontSize: ScreenUtil().setSp(30, allowFontScalingSelf: false),
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.white,
      duration: Duration(seconds: 3),
    ));
  }

  Widget buildMenuBar(BuildContext context,LoginController model) {
    return Container(
      width: ScreenUtil().setWidth(550),
      height: ScreenUtil().setHeight(70),
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: (){
                  model.onSignInButtonPress(pageController);
                } ,
                child: Text(
                  "Нэвтрэх",
                  style: TextStyle(
                      color: model.left,
                      fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                onPressed: (){
                  model.onSignUpButtonPress(pageController);
                },
                child: Text(
                  "Бүртгүүлэх",
                  style: TextStyle(
                      color: model.right,
                      fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                      fontFamily: "WorkSansSemiBold"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignIn(BuildContext context,LoginController model) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      // padding: EdgeInsets.only(top: ScreenUtil().setHeight(40)),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: ScreenUtil().setWidth(550),
                  height: ScreenUtil().setHeight(300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      // Padding(
                      //     padding: EdgeInsets.only(top: 0.0, bottom: 0.0,
                      //         left: ScreenUtil().setWidth(28),right: ScreenUtil().setWidth(35)),
                      //     child: Row(
                      //       children: <Widget>[
                      //         Icon(
                      //           Icons.account_balance,
                      //           color: Colors.black87,
                      //           size: ScreenUtil().setSp(38),
                      //         ),
                      //         SizedBox(width:ScreenUtil().setWidth(20)),
                      //         Expanded(
                      //           child:DropdownButtonHideUnderline(
                      //             child: DropdownButton(
                      //               value: model.selectedOrg,
                      //               icon: Icon(Icons.arrow_drop_down,size: ScreenUtil().setSp(42),
                      //                   color: Colors.black54),
                      //               iconSize: ScreenUtil().setSp(45),
                      //               style: TextStyle(
                      //                 color: Colors.black87,
                      //                 fontSize:ScreenUtil().setSp(32)/ scaleFactor,
                      //               ),
                      //               onChanged: (Org newValue) {
                      //                 model.selectOrg(newValue);
                      //               },
                      //               items: model.orgs.map((Org org) {
                      //                 return new DropdownMenuItem<Org>(
                      //                   value: org,
                      //                   child: new Text(
                      //                     org.name,
                      //                     style: new TextStyle(color: Colors.black54),
                      //                   ),
                      //                 );
                      //               }).toList(),
                      //             ),
                      //           ),
                      //         )
                      //       ],
                      //     )
                      // ),
                      // Container(
                      //   margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                      //   width: MediaQuery.of(context).size.width,
                      //   height: ScreenUtil().setHeight(2),
                      //   color: Colors.grey[400],
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(4), bottom: ScreenUtil().setHeight(4),
                            left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                        child: TextField(
                          textInputAction: TextInputAction.next,
                          onSubmitted: (username) {
                            FocusScope.of(context).requestFocus(myFocusNodePasswordLogin);
                          },
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false),
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                              size: ScreenUtil().setWidth(35),
                            ),
                            hintText: "Мэйл хаяг",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false)),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(2),
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(4), bottom: ScreenUtil().setHeight(4),
                            left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: model.obscureTextLogin,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false),
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              size: ScreenUtil().setWidth(40),
                              color: Colors.black87,
                            ),
                            hintText: "Нууц үг",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(32, allowFontScalingSelf: false)),
                            suffixIcon: GestureDetector(
                              onTap: model.toggleLogin,
                              child: Icon(
                                model.obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: ScreenUtil().setWidth(30),
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                        width: MediaQuery.of(context).size.width,
                        height: ScreenUtil().setHeight(2),
                        color: Colors.grey[400],
                      ),
                      // Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 5.0),
                      //       child: FlatButton(
                      //           onPressed: () {},
                      //           child: Text(
                      //             "Хичээл үүсгэх",
                      //             style: TextStyle(
                      //                 decoration: TextDecoration.underline,
                      //                 color: Colors.blue,
                      //                 fontSize: ScreenUtil().setSp(25, allowFontScalingSelf: false),
                      //                 fontFamily: "WorkSansMedium"),
                      //           )),
                      //     ),
                      //   ],
                      // )
                      // Row(
                      //   children: <Widget>[
                      //     Padding(
                      //       padding: EdgeInsets.only(top:  ScreenUtil().setHeight(10)),
                      //       child: Row(
                      //         children: <Widget>[
                      //           new Checkbox(value: model.isLoginCheck, onChanged:(value ){
                      //             model.checkBox(value);
                      //           }),
                      //           new Text('Намайг санах',
                      //               style: TextStyle(fontFamily: "WorkSansMedium",
                      //                   fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true),
                      //                   color: model.isLoginCheck ? Colors.blue : Colors.black54)),
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(width:ScreenUtil().setWidth(35)),
                      //     Padding(
                      //       padding: EdgeInsets.only(top: 10.0),
                      //       child: FlatButton(
                      //           onPressed: () {},
                      //           child: Text(
                      //             "Нууц үгээ марсан уу?",
                      //             style: TextStyle(
                      //                 decoration: TextDecoration.underline,
                      //                 color: Colors.blue,
                      //                 fontSize: ScreenUtil().setSp(20, allowFontScalingSelf: false),
                      //                 fontFamily: "WorkSansMedium"),
                      //           )),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(350)),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Нэвтрэх",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: ScreenUtil().setSp(35, allowFontScalingSelf: false),
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                      //   return MyCanvas();
                      // }));
                      model.jumpToHome();
                      //showInSnackBar("Login button pressed");
                    },

                  )
              ),
            ],
          ),
          // Padding(
          //   padding: EdgeInsets.only(top:ScreenUtil().setHeight(40)),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white10,
          //                 Colors.white,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: ScreenUtil().setWidth(150) ,
          //         height:ScreenUtil().setHeight(2),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
          //         child: Text(
          //           "Сошиалоор нэвтрэх",
          //           style: TextStyle(
          //               color: Colors.white,
          //               fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: false),
          //               fontFamily: "WorkSansMedium"),
          //         ),
          //       ),
          //       Container(
          //         decoration: BoxDecoration(
          //           gradient: new LinearGradient(
          //               colors: [
          //                 Colors.white,
          //                 Colors.white10,
          //               ],
          //               begin: const FractionalOffset(0.0, 0.0),
          //               end: const FractionalOffset(1.0, 1.0),
          //               stops: [0.0, 1.0],
          //               tileMode: TileMode.clamp),
          //         ),
          //         width: ScreenUtil().setWidth(150) ,
          //         height:ScreenUtil().setHeight(2),
          //       ),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Padding(
          //       padding: EdgeInsets.only(top:ScreenUtil().setHeight(30), right: ScreenUtil().setWidth(20)),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Facebook button pressed",context),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.facebookF,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(top:ScreenUtil().setHeight(30), right: ScreenUtil().setWidth(20)),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Google button pressed",context),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.google,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(top:ScreenUtil().setHeight(30)),
          //       child: GestureDetector(
          //         onTap: () => showInSnackBar("Google button pressed",context),
          //         child: Container(
          //           padding: const EdgeInsets.all(15.0),
          //           decoration: new BoxDecoration(
          //             shape: BoxShape.circle,
          //             color: Colors.white,
          //           ),
          //           child: new Icon(
          //             FontAwesomeIcons.twitter,
          //             color: Color(0xFF0084ff),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildSignUp(BuildContext context,LoginController model) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      padding: EdgeInsets.only(top:  ScreenUtil().setHeight(40)),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: ScreenUtil().setWidth(550),
                  height: ScreenUtil().setHeight(500),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 0.0, bottom: 0.0,
                                left: ScreenUtil().setWidth(28),right: ScreenUtil().setWidth(35)),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.account_balance,
                                  color: Colors.black87,
                                  size: ScreenUtil().setSp(38),
                                ),
                                SizedBox(width:ScreenUtil().setWidth(20)),
                                Expanded(
                                  child:DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: model.selectedOrg,
                                      icon: Icon(Icons.arrow_drop_down,size: ScreenUtil().setSp(42),
                                          color: Colors.black54),
                                      iconSize: ScreenUtil().setSp(45),
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize:ScreenUtil().setSp(28)/ scaleFactor,
                                      ),
                                      onChanged: (Org newValue) {
                                        model.selectOrg(newValue);
                                      },
                                      items: model.orgs.map((Org org) {
                                        return new DropdownMenuItem<Org>(
                                          value: org,
                                          child: new Text(
                                            org.name,
                                            style: new TextStyle(color: Colors.black54),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            focusNode: name,
                            onSubmitted: (username) {
                              FocusScope.of(context).requestFocus(mail);
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(35),
                              ),
                              hintText: "Таны нэр",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            onSubmitted: (username) {
                              FocusScope.of(context).requestFocus(name);
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize:  ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.userCircle,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(40),
                              ),
                              hintText: "Таны овог",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize:ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            textInputAction: TextInputAction.next,
                            focusNode: mail,
                            onSubmitted: (username) {
                              FocusScope.of(context).requestFocus(position);
                            },
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(35),
                              ),
                              hintText: "Таны мэйл хаяг(GOV.mn)",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            focusNode: position,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (username) {
                              FocusScope.of(context).requestFocus(password);
                            },
                            keyboardType: TextInputType.text,
                            inputFormatters: [LengthLimitingTextInputFormatter(8)],
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.perm_contact_calendar,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(40),
                              ),
                              hintText: "Албан тушаал",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            focusNode: password,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (username) {
                              FocusScope.of(context).requestFocus(passwordDone);
                            },
                            keyboardType: TextInputType.text,
                            inputFormatters: [LengthLimitingTextInputFormatter(8)],
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(40),
                              ),
                              hintText: "Нууц үгээ оруулна уу",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30), right:ScreenUtil().setWidth(30)),
                          width: MediaQuery.of(context).size.width,
                          height: ScreenUtil().setHeight(2),
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(8),
                              left: ScreenUtil().setWidth(35), right: ScreenUtil().setWidth(35)),
                          child: TextField(
                            focusNode: passwordDone,
                            keyboardType: TextInputType.text,
                            inputFormatters: [LengthLimitingTextInputFormatter(8)],
                            style: TextStyle(
                                fontFamily: "WorkSansSemiBold",
                                fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false),
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                color: Colors.black,
                                size: ScreenUtil().setWidth(35),
                              ),
                              hintText: "Нууц үгээ давтан оруулна уу",
                              hintStyle: TextStyle(
                                  fontFamily: "WorkSansSemiBold", fontSize: ScreenUtil().setSp(28, allowFontScalingSelf: false)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(550)),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Бүртгүүлэх",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize:  ScreenUtil().setSp(35, allowFontScalingSelf: false),
                            fontFamily: "WorkSansBold"),
                      ),
                    ),
                    onPressed: () =>
                        showInSnackBar("SignUp button pressed",context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


