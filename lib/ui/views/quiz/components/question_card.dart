import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:quiver/iterables.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/action_data.dart';
import 'package:lms_app/models/message.dart';
import 'package:lms_app/models/quesion_ctrl.dart';
import 'package:lms_app/models/user.dart';
import 'package:lms_app/ui/views/quiz/components/widgetss.dart' as globalSelect;

import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../constants.dart';
import 'option5.dart';
// import 'package:my_app_name/path/to/provider.dart' as Globals;

class QuestionCard extends StatefulWidget {
  IO.Socket socket;
  final QuestionCtrl questionCtrl;
   QuestionCard({

    this.questionCtrl,this.socket
  });



  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  // List<SelectedAnswer> selectedAnswer =[];
  // List SelectedAnswer =[
  //   {
  //     'questionId': '',
  //     'answer': ''
  //   }
  // ];

  bool isColor = false;
  int selectedEegii = -1;
  bool tuVal = true;
  List<String> nohohtest;
  List<Widget> controllor= [];
  List<Widget> textField= new List();
  List<Widget> multiselect;
  List splitText = [];
  List splitjoinText = [];
  List splitlast = [];
  List selectedAnimals = [];
  List selectedCheck = [];
  List ans = [];
  User  me;
  QuestionCtrl questionCtrl;
  List selec = [];
  List<Message> messages = [];
  bool act = false;
  List<User> users = [];
  // IO.Socket socket;
  List socketnohoh = [];
  List socketAnswer = [];
  List<Map<String, dynamic>> user;
  String socketwrite = '';
  // ActionData actionData;
  List<Body_json> bod = [];
  var list;
  List<ChildJson> childs=List();
  List<Body_json> isChecked = [];
  @override
  void initState() {
    // TODO: implement initState
    splitText = widget.questionCtrl.title.split("###");
    var fillCount = splitText.length-1;
    nohohtest = new List<String>(fillCount);

    if(globalSelect.SaveAnswers.length>0) {
      for(var i=0;i<globalSelect.SaveAnswers.length;i++){
        if(globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id){
          list = globalSelect.SaveAnswers.firstWhere((element) {
            return element['questionId']==widget.questionCtrl.id;
          });

        }
      }
      if(list!=null){
        var selectIndex;
        List<Body_json> Checked = [];
        for(var i=0;i<widget.questionCtrl.body_json.length;i++){
          // radiobutton type 1,2
          if(widget.questionCtrl.body_json[i].id==list['answers'][0]['id']&&list['answers'].length==1){
            selectIndex = i;
            print("first iff if fi fi fi fi fi ");
          }

          // print("list  answers length ${list['answers'].length}");
          // print("list   ${list}");
          // checkbox type 3
          for(var j=0;j<list['answers'].length;j++){
            print("list  answers ${list['answers']}");
            if(widget.questionCtrl.body_json[i].id==list['answers'][j]['id']){
              Checked.add(widget.questionCtrl.body_json[i]);
            }
            // if(list['answers'][j]['value']!=null){
            //   print("nohohtest all  ${splitText.length-1}");
            //   for(var l=0;l<splitText.length-1;l++){
            //     // if(nohohtest[l]==list['answers'][j]['value']){
            //       nohohtest[l] = list['answers'][j]['value'];
            //       print("nohohtest check  ${nohohtest[l]}");
            //
            //     // }
            //
            // }
            // }
            // else if(widget.questionCtrl.body_json[i].id==list['answers'][j]['id']){
            //   print("else if");
            //
            // }
          }
        }
          // for (var k = 0; k < globalSelect.SaveAnswers.length; k++) {
          //   if (list['answers'][k]['match']!=null) {
          //     print("taaraw ${list['answers'][k]['id']}");
          //     // globalSelect.SaveAnswers[i] = {
          //     //   'id': widget.bodyjs[widget.index].id,
          //     //   'match': selectedChild.id
          //     // };
          //     print("============= ");
          //   }
          // }

        // nohoh type 4
        for(var l=0;l<splitText.length-1;l++){
          if(list['answers'][l]['value']!=null){
            print("nohohtest all  ${nohohtest}");
              // if(nohohtest[l]==list['answers'][j]['value']){
                nohohtest[l] = list['answers'][l]['value'];
              }
        print("nohohtest check  ${nohohtest}");
        }
        isChecked = Checked;
        selectedEegii =selectIndex;
        print("list q card  ${list} boglogdson bnaa");
      }
    }
    // multiselect = new List<String>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: main_quiz(context),
        ),
      ),
    );
  }
  List<Widget> main_quiz(context) {
    List<Widget> temp = [];
    // if(globalSelect.SaveAnswers.length>0){
    //   print("global length ${globalSelect.SaveAnswers.length}");
    //   // for(var i=0;i<globalSelect.SaveAnswers.length;i++){
    //   //   if(globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id){
    //   //     list = globalSelect.SaveAnswers.firstWhere((element) {
    //   //       return element['questionId']==widget.questionCtrl.id;
    //   //     });
    //   //
    //   //   }
    //   // }
    //   // // var user = globalSelect.SaveAnswers.firstWhere((element) => element["questionId"]==widget.questionCtrl.id);
    //   // if(list!=null){
    //   //   print("list ${list}");
    //   // }else{
    //   //   print("hooson");
    //   // }
    //   // print('We sent the verification link to ${user[0]['answers']}.');
    //
    // for(var i=0;i<globalSelect.SaveAnswers.length;i++){
    //   if(globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id){
    //     list = globalSelect.SaveAnswers.firstWhere((element) {
    //       return element['questionId']==widget.questionCtrl.id;
    //     });
    //
    //     if (widget.questionCtrl.typeid == 1 || widget.questionCtrl.typeid == 2) {
    //
    //       temp.add(Column(
    //         children: [
    //           Text(
    //             widget.questionCtrl.title, // "vdvsdv",
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .headline6
    //                 .copyWith(color: kBlackColor),
    //           ),
    //           ...List.generate(
    //             widget.questionCtrl.body_json.length,
    //                 (index) => Container(
    //               child: InkWell(
    //                 onTap: () {
    //                   setState(() {
    //                     isColor = !isColor;
    //                   });
    //                 },
    //                 child: Container(
    //                   margin: EdgeInsets.only(top: kDefaultPadding),
    //                   padding: EdgeInsets.all(kDefaultPadding),
    //                   decoration: BoxDecoration(
    //                       border: Border.all(color: kGrayColor),
    //                       borderRadius: BorderRadius.circular(15)),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       Text(
    //                         "${index + 1} ${widget.questionCtrl.body_json[index].item} ",
    //                         style: TextStyle(color: kBlackColor, fontSize: 16),
    //                       ),
    //                       Container(
    //                         height: 26,
    //                         width: 26,
    //                         child: Radio(
    //                           value: index,
    //                           groupValue: globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id?globalSelect.SaveAnswers[i]['answers'][0]['id']:selectedEegii,
    //                           onChanged: (val) {
    //                             setState(() {
    //                               print(val);
    //                               globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id?globalSelect.SaveAnswers[i]['answers'][0]['id']:selectedEegii = val;
    //                               // print("valll ${widget.questionCtrl.body_json[selectedEegii].id}");
    //                               socketAnswer.add({
    //                                 'id': widget.socket.id,
    //                                 'msg':{
    //                                   'userId': 1,
    //                                   'questionId':widget.questionCtrl.id,
    //                                   'answer':[{'id':widget.questionCtrl.body_json[globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id?globalSelect.SaveAnswers[i]['answer'][0]['id']:selectedEegii].id}]} });
    //                               globalSelect.selectedAnswers(widget.questionCtrl.id,
    //                                   [widget.questionCtrl.body_json[globalSelect.SaveAnswers[i]['questionId']==widget.questionCtrl.id?globalSelect.SaveAnswers[i]['answer'][0]['id']:selectedEegii].id]
    //                               );
    //                               // datosusuario.add({
    //                               //   'questionId':widget.questionCtrl.id,
    //                               //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]
    //                               // });
    //                               // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
    //                               // );
    //                               // print(selectedAnswer[0].questionId);
    //                               // for(var i=0;i<datosusuario.length;i++){
    //                               //   print(datosusuario[i]['questionId']);
    //                               //   if(datosusuario[i]['questionId']==widget.questionCtrl.id){
    //                               //
    //                               //     print("if");
    //                               //     // selectedAnswer[i]=[];
    //                               //     // datosusuario[i].questionId = widget.questionCtrl.id;
    //                               //     // print("${datosusuario}");
    //                               //     // SelectedAnswer(widget.questionCtrl.id, widget.questionCtrl.body_json[selectedEegii].id);
    //                               //     // selectedAnswer[i] = ({'questionId':widget.questionCtrl.id,
    //                               //     //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
    //                               //   }else{
    //                               //     print("else");
    //                               //     // selectedAnswer.add({'questionId':widget.questionCtrl.id,
    //                               //     //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
    //                               //   }
    //                               // }
    //
    //                               // SelectedAnswer.add({'questionId':widget.questionCtrl.id,
    //                               //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
    //                               // print(SelectedAnswer);
    //                               widget.socket.emit('sendAnswer',socketAnswer);
    //                               socketAnswer=[];
    //                             });
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           )
    //         ],
    //       ));
    //       // for(var i=0;i<user.length;i++){
    //       //   if(user[i]['questionId']==widget.questionCtrl.id){
    //       //
    //       //   };
    //       // };
    //       // temp.add(quiz_type1(widget.questionCtrl.title, widget.questionCtrl.body_json, context));
    //     }
    //     else if (widget.questionCtrl.typeid == 3) {
    //       // for(var i=0;i<selectedCheck.length;i++){
    //       // }
    //       // for(var i=0; i<widget.questionCtrl.body_json.length;i++){
    //       //   print(widget.questionCtrl.body_json[i].item);
    //       //   bod.add(widget.questionCtrl.body_json[i]);
    //       //   print("bod ${bod.length}");
    //       // }
    //       // setState(() {
    //       //   tuVal=!tuVal;
    //       // });
    //       temp.add(Column(children: [
    //         Text(
    //           widget.questionCtrl.title, //
    //           style: Theme.of(context)
    //               .textTheme
    //               .headline6
    //               .copyWith(color: kBlackColor),
    //         ), // main_quiz(context),
    //         ...List.generate(
    //           widget.questionCtrl.body_json.length,
    //               (index) =>
    //               Container(
    //
    //                 height: 40,
    //                 child: CheckboxListTile(
    //                   title: Text(widget.questionCtrl.body_json[index].item),
    //                   value: isChecked.contains(widget.questionCtrl.body_json[index]),
    //                   onChanged: (bool value) {
    //                     if (value) {
    //                       setState(() {
    //                         // print("leng ${bod.length}");
    //                         isChecked.add(widget.questionCtrl.body_json[index]);
    //                         selectedCheck.add(widget.questionCtrl.body_json[index].id);
    //                         // print("leng indesdsds ${widget.questionCtrl.body_json[index].id}");
    //                         // print("lengid  ${selectedCheck}");
    //                       });
    //                     } else {
    //                       setState(() {
    //                         isChecked.remove(widget.questionCtrl.body_json[index]);
    //                         selectedCheck.remove(widget.questionCtrl.body_json[index].id);
    //                         // print("leng ${widget.questionCtrl.body_json[index].id}");
    //                       });
    //                     }
    //                     setState(() {
    //                       // print("id=${widget.questionCtrl.id} , answer:${selectedCheck}");
    //                       for(var i=0;i<selectedCheck.length;i++){
    //                         selec.add({'id': selectedCheck[i]});
    //                       }
    //
    //                       socketAnswer.add({
    //                         'id': widget.socket.id,
    //                         'msg':{
    //                           'userId': 1,
    //                           'questionId':widget.questionCtrl.id,
    //                           'answer':selec} });
    //                       // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
    //                       // );
    //                       // print(socketAnswer);
    //                       globalSelect.selectedAnswers(widget.questionCtrl.id, selec);
    //                       widget.socket.emit('sendAnswer',socketAnswer);
    //                       selec=[];
    //                       socketAnswer=[];
    //                     });
    //                   },
    //                 ),
    //               ),
    //         ),
    //         // Text(isChecked.toString() + bod.length.toString())
    //       ]));
    //     }
    //     else if (widget.questionCtrl.typeid == 4) {
    //       temp.add(Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children:
    //           [
    //             RichText(text: TextSpan(children:
    //             [
    //               for(var i=0;i<splitText.length-1;i++)
    //                 TextSpan(text: " ${splitText[i]}",
    //                   children: [
    //                     TextSpan(text: "${nohohtest[i]!=null&& nohohtest[i]!=''?nohohtest[i] :  ' ${i+1} ___________' } ",style: TextStyle(color: nohohtest[i]!=null&& nohohtest[i]!=''?Colors.black:Colors.red) )
    //                   ],
    //                   style: TextStyle(color: Colors.black),),
    //               TextSpan(text: splitText[splitText.length-1]),
    //
    //             ])),
    //             Container(width: double.infinity,height: 400,
    //                 // color: Colors.deepOrange,
    //                 child: ListView.builder(
    //                     itemCount:nohohtest.length ,
    //                     itemBuilder: (_,int index){
    //                       return Container(
    //                         width: 200,
    //                         child: TextField(
    //                           decoration: InputDecoration(
    //                               border: OutlineInputBorder(),
    //                               hintText: '${index+1} bicjh'
    //                           ),
    //                           onChanged: (text){
    //                             setState(() {
    //                               nohohtest[index]=text;
    //                               for(var i=0;i<splitText.length-1;i++){
    //                                 socketnohoh.add({'id': i+1, 'value':nohohtest[i]!=null&& nohohtest[i]!=''?nohohtest[i] :  '' });
    //                               }
    //                               print(socketnohoh);
    //
    //                               socketAnswer.add({
    //                                 'id': widget.socket.id,
    //                                 'msg':{
    //                                   'userId': 1,
    //                                   'questionId':widget.questionCtrl.id,
    //                                   'answer':socketnohoh} });
    //                               // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
    //                               // );
    //                               // print(socketAnswer);
    //                               globalSelect.selectedAnswers(widget.questionCtrl.id, socketnohoh);
    //                               widget.socket.emit('sendAnswer',socketAnswer);
    //                               socketnohoh=[];
    //                               socketAnswer=[];
    //                             });
    //                           },
    //                         ),
    //                       );
    //                     })
    //             )
    //           ]
    //         // Row(
    //         //   // for(var i in splitText){},
    //         // // for(var i=0;i<splitText.length;i++) {
    //         // // print("fdsf");
    //         // // // if(splitText[i+1]){},
    //         // // },
    //         //   children: <Widget>[
    //         //     // for(var i=0;i<splitjoinText.length;i++)
    //         //       // if(splitjoinText.length-1 == i)
    //         //         Text(" ${splitjoinText} ${splitedLast[splitedLast.length-1]}"),
    //         //      // if(splitText.length-1 == i) Text("${splitText.join(" ${ nohohtest=='' ?"______" : nohohtest}")}"),
    //         //
    //         //       // Text("${splitText[i]} ${nohohtest==''&& splitText.length==i ?"______" : nohohtest}"),
    //         //     // Text("${nohohtest==''?"______" : nohohtest}")  ,
    //         //       // if(i==splitText.length) Text("fdsf $i"),
    //         //
    //         //     // Text(splitText[1]) ,
    //         //     // Text("${nohohtest==''?"______" : nohohtest}"),
    //         //
    //         //     // Container(
    //         //     //   width: 100,
    //         //     //   child: TextField(
    //         //     //     decoration: InputDecoration(
    //         //     //       border: OutlineInputBorder(),
    //         //     //       hintText: 'bicjh'
    //         //     //     ),
    //         //     //   ),
    //         //     // ),
    //         //     // Text(
    //         //     //   splitText.toString(), // "vdvsdv",
    //         //     //   style: Theme.of(context)
    //         //     //       .textTheme
    //         //     //       .headline6
    //         //     //       .copyWith(color: kBlackColor),
    //         //     // ),
    //         //     // main_quiz(context),
    //         //     // ...List.generate(
    //         //     //   widget.questionCtrl.body_json.length,
    //         //     //   (index) =>
    //         //     //       Container(
    //         //     //         margin: EdgeInsets.only(top: kDefaultPadding),
    //         //     //         padding: EdgeInsets.all(kDefaultPadding),
    //         //     //         decoration: BoxDecoration(
    //         //     //             border: Border.all(color: kGrayColor),
    //         //     //             borderRadius: BorderRadius.circular(15)),
    //         //     //         child: Row(
    //         //     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         //     //           children: [
    //         //     //             Text(
    //         //     //               "${index+1} ${widget.questionCtrl.title}",
    //         //     //               style: TextStyle(color: kGrayColor, fontSize: 16),
    //         //     //             ),
    //         //     //             Container(
    //         //     //               height: 26,
    //         //     //               width: 26,
    //         //     //               decoration: BoxDecoration(
    //         //     //                   borderRadius: BorderRadius.circular(50),
    //         //     //                   border: Border.all(color: kGrayColor)),
    //         //     //             )
    //         //     //           ],
    //         //     //         ),
    //         //     //       )
    //         //     //   //     Option4(
    //         //     //   //   index: index,
    //         //     //   //   text: widget.questionCtrl.body_json[index].item,
    //         //     //   //   press: () => {},
    //         //     //   // ),
    //         //     // ),
    //         //   ],
    //         // ),
    //         // SizedBox(height: 30,),
    //         // Container(
    //         //   width: 200,
    //         //   child: TextField(
    //         //     controller: ,
    //         //     onChanged: (text){setState(() {
    //         //       nohohtest[i] = text;
    //         //     });},
    //         //     decoration: InputDecoration(
    //         //         border: OutlineInputBorder(),
    //         //         hintText: 'bicjh'
    //         //     ),
    //         //   ),
    //         // ),
    //
    //       ));
    //     }
    //     else if (widget.questionCtrl.typeid == 5) {
    //       if (widget.questionCtrl.childJson != null &&
    //           widget.questionCtrl.childJson.length > 0){
    //         // @override
    //         // void initState() {
    //         //   // TODO: implement initState
    //         //   setState(() {
    //         //     selectedChild = widget.questionCtrl.childJson[widget.questionCtrl.childJson.length-1];
    //         //
    //         //   });
    //         //
    //         //   super.initState();
    //         // }
    //         setState(() {
    //           selectedChild = widget.questionCtrl.childJson[widget.questionCtrl.childJson.length-1];
    //           for(int i=0;i<widget.questionCtrl.childJson.length;i++){
    //             child.add(widget.questionCtrl.childJson[i]);
    //           }
    //           //   // selectedChild = new ChildJson(item: 'select one');
    //           //   selectedChild = widget.questionCtrl.childJson[0];
    //           //   print(child);
    //
    //         });
    //         // print('Adding VERTICAL pages ... len = '+slides[i].child.length.toString());
    //         temp.add(
    //           Column(
    //             children: [
    //               Text(
    //                 widget.questionCtrl.title, // "vdvsdv",
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline6
    //                     .copyWith(color: kBlackColor),
    //               ), // main_quiz(context),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       ...List.generate(
    //                           widget.questionCtrl.body_json.length,
    //                               (index) => Container(
    //                             // margin: EdgeInsets.only(top: kDefaultPadding),
    //                             padding: EdgeInsets.all(kDefaultPadding),
    //                             // decoration: BoxDecoration(
    //                             //     border: Border.all(color: kGrayColor),
    //                             //     borderRadius: BorderRadius.circular(15)),
    //                             child: Row(
    //                               // mainAxisAlignment:
    //                               //     MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Text(
    //                                   "${index + 1} ${widget.questionCtrl.body_json[index].item}",
    //                                   style: TextStyle(
    //                                       color: kBlackColor, fontSize: 16),
    //                                 ),
    //
    //                                 // OptionChild()
    //                               ],
    //                             ),
    //                           )),
    //                       Divider(
    //                         // height: 20,
    //                         // thickness: 5,
    //                         // indent: 20,
    //                         // endIndent: 20,
    //                         color: Colors.black,
    //                       ),
    //                     ],
    //                   ),
    //                   Column(
    //                     // mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       ...List.generate(
    //                         widget.questionCtrl.childJson.length,
    //                             (index) =>
    //
    //                         // Container(
    //                         //
    //                         //   margin: EdgeInsets.only(top: kDefaultPadding),
    //                         //   // padding: EdgeInsets.all(kDefaultPadding),
    //                         //   // decoration: BoxDecoration(
    //                         //   //     border: Border.all(color: kGrayColor),
    //                         //   //     borderRadius: BorderRadius.circular(15)),
    //                         //   child: Center(
    //                         //     child: Column(
    //                         //       // mainAxisAlignment: MainAxisAlignment.center,
    //                         //       children: [
    //                         //
    //                         //         DropdownButton<ChildJson>(
    //                         //           value: selectedChild,
    //                         //           // icon: Icon(Icons.keyboard_arrow_down),
    //                         //           items:widget.questionCtrl.childJson.map((item) {
    //                         //             return DropdownMenuItem<ChildJson>(
    //                         //                 value: item,
    //                         //                 child: Text(item.item)
    //                         //             );
    //                         //           }
    //                         //           ).toList(),
    //                         //           onChanged: (ChildJson newValue){
    //                         //             // print("fesf ${newValue.item}");
    //                         //             setState(() {
    //                         //               selectedChild = newValue;
    //                         //               print("fesf ${newValue.item}");
    //                         //             });
    //                         //           },
    //                         //         ),
    //                         //       ],
    //                         //     ),
    //                         //   ),
    //                         // )
    //                         OptionChild(
    //                           index: index,
    //                           child: widget.questionCtrl.childJson,
    //                           press: () => {},
    //                         ),
    //                       ),
    //                     ],
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //         );
    //       }
    //     }
    //     else if (widget.questionCtrl.typeid == 6) {
    //       // temp.add(
    //       //     quiz_type6(questionCtrl.title, questionCtrl.body, context));
    //       if (widget.questionCtrl.childJson != null &&
    //           widget.questionCtrl.childJson.length > 0) {
    //         // print('Adding VERTICAL pages ... len = '+slides[i].child.length.toString());
    //         temp.add(
    //           Column(
    //             children: [
    //               Text(
    //                 widget.questionCtrl.title, // "vdvsdv",
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .headline6
    //                     .copyWith(color: kBlackColor),
    //               ), // main_quiz(context),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     children: [
    //                       ...List.generate(
    //                           widget.questionCtrl.body_json.length,
    //                               (index) => Container(
    //                             margin: EdgeInsets.only(top: kDefaultPadding),
    //                             padding: EdgeInsets.all(kDefaultPadding),
    //                             // decoration: BoxDecoration(
    //                             //     border: Border.all(color: kGrayColor),
    //                             //     borderRadius: BorderRadius.circular(15)),
    //                             child: Row(
    //                               mainAxisAlignment:
    //                               MainAxisAlignment.spaceBetween,
    //                               children: [
    //                                 Text(
    //                                   "${index + 1} ${widget.questionCtrl.body_json[index].item}",
    //                                   style: TextStyle(
    //                                       color: kBlackColor, fontSize: 16),
    //                                 ),
    //
    //                                 // OptionChild()
    //                               ],
    //                             ),
    //                           )),
    //                     ],
    //                   ),
    //                   Column(
    //                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     children: [
    //                       ...List.generate(
    //                         widget.questionCtrl.childJson.length,
    //                             (index) =>
    //
    //                         // MultiSelectChipField(
    //                         //   items: widget.questionCtrl.childJson.map((e) => MultiSelectItem(e, e.item)).toList(),
    //                         //   // icon: Icon(Icons.check),
    //                         //   onTap: (values) {
    //                         //         setState(() {
    //                         //           selectedAnimals = values[index];
    //                         //           print("vdsvasda ${values[0].item}");
    //                         //         });
    //                         //   },
    //                         // ),
    //                         MultiSelectDialogField(
    //                           items: widget.questionCtrl.childJson.map((e) => MultiSelectItem(e, e.item)).toList(),
    //                           listType: MultiSelectListType.LIST,
    //                           buttonText: Text("Олон сонгох"),
    //                           decoration: BoxDecoration(
    //                             // color: Colors.blue.withOpacity(0.1),
    //                             borderRadius: BorderRadius.all(Radius.circular(10)),
    //                             border: Border.all(
    //                               color: Colors.blue,
    //                               width: 2,
    //                             ),
    //                           ),
    //                           // chipDisplay: MultiSelectChipDisplay(
    //                           //   onTap: (value) {
    //                           //     setState(() {
    //                           //       print("value ${value}");
    //                           //       selectedAnimals.remove(value);
    //                           //     });
    //                           //   },
    //                           // ),
    //
    //                           onConfirm: (values) {
    //                             setState(() {
    //                               selectedAnimals=[];
    //                               for(var i=0; i < values.length;i++){
    //                                 selectedAnimals.add(values[i].id);
    //                               }
    //                               print("id=${widget.questionCtrl.id}, answer:${widget.questionCtrl.body_json[index].id} match ${selectedAnimals}");
    //
    //                             });
    //                           },
    //                         ),
    //                         //     OptionChild(
    //                         //   index: index,
    //                         //   child: widget.questionCtrl.childJson,
    //                         //   press: () => {},
    //                         // ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               // selectedAnimals.map((e) => new Text(e)).toList();
    //               // for(var i in selectedAnimals){
    //               //   chid: Text(selectedAnimals.length>0? selectedAnimals[i].item.toString() :'')
    //               // },
    //               Text( selectedAnimals.toString())
    //             ],
    //           ),
    //         );
    //       }
    //     }
    //     else if (widget.questionCtrl.typeid == 7) {
    //
    //       temp.add(Column(
    //         children: [
    //           Text(
    //             widget.questionCtrl.title, // "vdvsdv",
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .headline6
    //                 .copyWith(color: kBlackColor),
    //           ),
    //           Container(
    //             decoration: BoxDecoration(
    //                 border: Border.all(color: kGrayColor),
    //                 borderRadius: BorderRadius.circular(15)),
    //             child: TextField(
    //               onChanged: (text){
    //                 setState(() {
    //                   // print("id=${widget.questionCtrl.id},answer: ${text}");
    //
    //                   socketAnswer.add({
    //                     'id': widget.socket.id,
    //                     'msg':{
    //                       'userId': 1,
    //                       'questionId':widget.questionCtrl.id,
    //                       'answer':[{'id':text}]} });
    //                   // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
    //                   // );
    //                   // print(socketAnswer);
    //                   globalSelect.selectedAnswers(widget.questionCtrl.id, [text]);
    //                   widget.socket.emit('sendAnswer',socketAnswer);
    //                   socketAnswer=[];
    //                 });
    //               },
    //               // minLines: 6, // any number you need (It works as the rows for the textarea)
    //               keyboardType: TextInputType.number,
    //               inputFormatters: <TextInputFormatter>[
    //                 FilteringTextInputFormatter.digitsOnly
    //               ], //
    //             ),
    //           ),
    //
    //         ],
    //       ));
    //     }
    //     else if (widget.questionCtrl.typeid == 8) {
    //
    //       temp.add(Column(
    //         children: [
    //           Text(
    //             widget.questionCtrl.title, // "vdvsdv",
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .headline6
    //                 .copyWith(color: kBlackColor),
    //           ),
    //
    //           Container(
    //             decoration: BoxDecoration(
    //                 border: Border.all(color: kGrayColor),
    //                 borderRadius: BorderRadius.circular(15)),
    //             child: TextField(
    //               onChanged: (text){
    //                 setState(() {
    //                   socketwrite = text;
    //                   print("id=${widget.questionCtrl.id},answer: ${text}");
    //
    //                 });
    //               },
    //               minLines: 6,
    //               // any number you need (It works as the rows for the textarea)
    //               keyboardType: TextInputType.multiline,
    //               maxLines: null,
    //             ),
    //           ),
    //           IconButton(
    //               icon: const Icon(Icons.save),
    //               onPressed:(){
    //                 setState(() {
    //                   socketAnswer.add({
    //                     'id': widget.socket.id,
    //                     'msg':{
    //                       'userId': 1,
    //                       'questionId':widget.questionCtrl.id,
    //                       'answer':[{'id':1, 'textvalue':socketwrite}]} });
    //                   // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
    //                   // );
    //                   // print(socketAnswer);
    //                   globalSelect.selectedAnswers(widget.questionCtrl.id, [{'id':1, 'textvalue':socketwrite}]);
    //                   widget.socket.emit('sendAnswer',socketAnswer);
    //                   socketAnswer=[];
    //                 });
    //               })
    //         ],
    //       ));
    //     }
    //
    //   }
    // }
    //
    //   print("global ${globalSelect.SaveAnswers}");
    // }
    // else{
      if (widget.questionCtrl.typeid == 1 || widget.questionCtrl.typeid == 2) {
        temp.add(Column(
          children: [
            Text(
              widget.questionCtrl.title, // "vdvsdv",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: kBlackColor),
            ),
            ...List.generate(
              widget.questionCtrl.body_json.length,
                  (index) => Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isColor = !isColor;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: kDefaultPadding),
                    padding: EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                        border: Border.all(color: kGrayColor),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${index + 1} ${widget.questionCtrl.body_json[index].item} ",
                          style: TextStyle(color: kBlackColor, fontSize: 16),
                        ),
                        Container(
                          height: 26,
                          width: 26,
                          child: Radio(
                            value: index,
                            groupValue: selectedEegii,
                            onChanged: (val) {
                              setState(() {
                                // print();
                               selectedEegii = val;

                                // print("valll ${widget.questionCtrl.body_json[selectedEegii].id}");
                                socketAnswer.add({
                                  'id': widget.socket.id,
                                  'msg':{
                                    'userId': myUserId,
                                    'questionId':widget.questionCtrl.id,
                                    'isMobile':true,
                                    'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]} });
                                globalSelect.selectedAnswers(widget.questionCtrl.id,
                                    [widget.questionCtrl.body_json[selectedEegii].id]
                                );
                                // datosusuario.add({
                                //   'questionId':widget.questionCtrl.id,
                                //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]
                                // });
                                // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
                                // );
                                // print(selectedAnswer[0].questionId);
                                // for(var i=0;i<datosusuario.length;i++){
                                //   print(datosusuario[i]['questionId']);
                                //   if(datosusuario[i]['questionId']==widget.questionCtrl.id){
                                //
                                //     print("if");
                                //     // selectedAnswer[i]=[];
                                //     // datosusuario[i].questionId = widget.questionCtrl.id;
                                //     // print("${datosusuario}");
                                //     // SelectedAnswer(widget.questionCtrl.id, widget.questionCtrl.body_json[selectedEegii].id);
                                //     // selectedAnswer[i] = ({'questionId':widget.questionCtrl.id,
                                //     //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
                                //   }else{
                                //     print("else");
                                //     // selectedAnswer.add({'questionId':widget.questionCtrl.id,
                                //     //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
                                //   }
                                // }

                                // SelectedAnswer.add({'questionId':widget.questionCtrl.id,
                                //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
                                // print(SelectedAnswer);
                                widget.socket.emit('sendAnswer',socketAnswer);
                                socketAnswer=[];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
        // for(var i=0;i<user.length;i++){
        //   if(user[i]['questionId']==widget.questionCtrl.id){
        //
        //   };
        // };
        // temp.add(quiz_type1(widget.questionCtrl.title, widget.questionCtrl.body_json, context));
      }
      else if (widget.questionCtrl.typeid == 3) {
        // for(var i=0;i<selectedCheck.length;i++){
        // }
        // for(var i=0; i<widget.questionCtrl.body_json.length;i++){
        //   print(widget.questionCtrl.body_json[i].item);
        //   bod.add(widget.questionCtrl.body_json[i]);
        //   print("bod ${bod.length}");
        // }
        // setState(() {
        //   tuVal=!tuVal;
        // });
        temp.add(Column(children: [
          Text(
            widget.questionCtrl.title, //
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: kBlackColor),
          ), // main_quiz(context),
          ...List.generate(
            widget.questionCtrl.body_json.length,
                (index) =>
                Container(

                  height: 40,
                  child: CheckboxListTile(
                    title: Text(widget.questionCtrl.body_json[index].item),
                    value: isChecked.contains(widget.questionCtrl.body_json[index]),
                    onChanged: (bool value) {
                      if (value) {
                        setState(() {
                          // print("leng ${bod.length}");
                          isChecked.add(widget.questionCtrl.body_json[index]);
                          selectedCheck.add(widget.questionCtrl.body_json[index].id);
                          // print("leng indesdsds ${widget.questionCtrl.body_json[index].id}");
                          // print("lengid  ${isChecked}");
                        });
                      } else {
                        setState(() {
                          isChecked.remove(widget.questionCtrl.body_json[index]);
                          selectedCheck.remove(widget.questionCtrl.body_json[index].id);
                          // print("leng ${widget.questionCtrl.body_json[index].id}");
                        });
                      }
                      setState(() {
                        print("id=${widget.questionCtrl.id} , answer:${selectedCheck}");
                        for(var i=0;i<selectedCheck.length;i++){
                          selec.add({'id': selectedCheck[i]});
                        }

                        socketAnswer.add({
                          'id': widget.socket.id,
                          'msg':{
                            'userId': myUserId,
                            'questionId':widget.questionCtrl.id,
                            'answer':selec} });
                        // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
                        // );
                        // print(socketAnswer);
                        globalSelect.selectedAnswers(widget.questionCtrl.id, selec);
                        widget.socket.emit('sendAnswer',socketAnswer);
                        selec=[];
                        socketAnswer=[];
                      });
                    },
                  ),
                ),
          ),
          // Text(isChecked.toString() + bod.length.toString())
        ]));
      }
      else if (widget.questionCtrl.typeid == 4) {
        temp.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              RichText(text: TextSpan(children:
              [
                for(var i=0;i<splitText.length-1;i++)
                  TextSpan(text: " ${splitText[i]}",
                    children: [
                      TextSpan(text: "${nohohtest[i]!=null&& nohohtest[i]!=''?nohohtest[i] :  ' ${i+1} ___________' } ",style: TextStyle(color: nohohtest[i]!=null&& nohohtest[i]!=''?Colors.green:Colors.red) )
                    ],
                    style: TextStyle(color: Colors.black),),
                TextSpan(text: splitText[splitText.length-1]),

              ])),
              Container(width: double.infinity,height: 400,
                  // color: Colors.deepOrange,
                  child: ListView.builder(
                      itemCount:nohohtest.length ,
                      itemBuilder: (_,int index){
                        return Container(
                          width: 200,
                          child: TextField(

                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '${index+1} bicjh'
                            ),
                            onChanged: (text){
                              setState(() {
                                nohohtest[index]=text;
                                for(var i=0;i<splitText.length-1;i++){
                                  socketnohoh.add({'id': i+1, 'value':nohohtest[i]!=null&& nohohtest[i]!=''?nohohtest[i] :  '' });
                                }
                                print(socketnohoh);

                                socketAnswer.add({
                                  'id': widget.socket.id,
                                  'msg':{
                                    'userId': myUserId,
                                    'questionId':widget.questionCtrl.id,
                                    'answer':socketnohoh} });
                                globalSelect.selectedAnswers(widget.questionCtrl.id, socketnohoh);
                                widget.socket.emit('sendAnswer',socketAnswer);
                                socketnohoh=[];
                                socketAnswer=[];
                              });
                            },
                          ),
                        );
                      })
              )
            ]
          // Row(
          //   // for(var i in splitText){},
          // // for(var i=0;i<splitText.length;i++) {
          // // print("fdsf");
          // // // if(splitText[i+1]){},
          // // },
          //   children: <Widget>[
          //     // for(var i=0;i<splitjoinText.length;i++)
          //       // if(splitjoinText.length-1 == i)
          //         Text(" ${splitjoinText} ${splitedLast[splitedLast.length-1]}"),
          //      // if(splitText.length-1 == i) Text("${splitText.join(" ${ nohohtest=='' ?"______" : nohohtest}")}"),
          //
          //       // Text("${splitText[i]} ${nohohtest==''&& splitText.length==i ?"______" : nohohtest}"),
          //     // Text("${nohohtest==''?"______" : nohohtest}")  ,
          //       // if(i==splitText.length) Text("fdsf $i"),
          //
          //     // Text(splitText[1]) ,
          //     // Text("${nohohtest==''?"______" : nohohtest}"),
          //
          //     // Container(
          //     //   width: 100,
          //     //   child: TextField(
          //     //     decoration: InputDecoration(
          //     //       border: OutlineInputBorder(),
          //     //       hintText: 'bicjh'
          //     //     ),
          //     //   ),
          //     // ),
          //     // Text(
          //     //   splitText.toString(), // "vdvsdv",
          //     //   style: Theme.of(context)
          //     //       .textTheme
          //     //       .headline6
          //     //       .copyWith(color: kBlackColor),
          //     // ),
          //     // main_quiz(context),
          //     // ...List.generate(
          //     //   widget.questionCtrl.body_json.length,
          //     //   (index) =>
          //     //       Container(
          //     //         margin: EdgeInsets.only(top: kDefaultPadding),
          //     //         padding: EdgeInsets.all(kDefaultPadding),
          //     //         decoration: BoxDecoration(
          //     //             border: Border.all(color: kGrayColor),
          //     //             borderRadius: BorderRadius.circular(15)),
          //     //         child: Row(
          //     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     //           children: [
          //     //             Text(
          //     //               "${index+1} ${widget.questionCtrl.title}",
          //     //               style: TextStyle(color: kGrayColor, fontSize: 16),
          //     //             ),
          //     //             Container(
          //     //               height: 26,
          //     //               width: 26,
          //     //               decoration: BoxDecoration(
          //     //                   borderRadius: BorderRadius.circular(50),
          //     //                   border: Border.all(color: kGrayColor)),
          //     //             )
          //     //           ],
          //     //         ),
          //     //       )
          //     //   //     Option4(
          //     //   //   index: index,
          //     //   //   text: widget.questionCtrl.body_json[index].item,
          //     //   //   press: () => {},
          //     //   // ),
          //     // ),
          //   ],
          // ),
          // SizedBox(height: 30,),
          // Container(
          //   width: 200,
          //   child: TextField(
          //     controller: ,
          //     onChanged: (text){setState(() {
          //       nohohtest[i] = text;
          //     });},
          //     decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         hintText: 'bicjh'
          //     ),
          //   ),
          // ),

        ));
      }
      else if (widget.questionCtrl.typeid == 5) {
        if (widget.questionCtrl.childJson != null &&
            widget.questionCtrl.childJson.length > 0){
          // setState(() {
          //   // selectedChild = widget.questionCtrl.childJson[widget.questionCtrl.childJson.length-1];
          //   // for(int i=0;i<widget.questionCtrl.childJson.length;i++){
          //   //   childs.add(widget.questionCtrl.childJson[i]);
          //   // }
          //   //   // selectedChild = new ChildJson(item: 'select one');
          //     print("childs leng${widget.questionCtrl.childJson.length}");
          //
          // });
          // print('Adding VERTICAL pages ... len = '+slides[i].child.length.toString());
          temp.add(
            Column(
              children: [
                Text(
                  widget.questionCtrl.title, // "vdvsdv",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kBlackColor),
                ), // main_quiz(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            widget.questionCtrl.body_json.length,
                                (index) =>
                                    Container(
                              // margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: kGrayColor),
                              //     borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${index + 1} ${widget.questionCtrl.body_json[index].item}",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 16),
                                  ),

                                  // OptionChild()
                                ],
                              ),
                            )),

                      ],
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(
                            widget.questionCtrl.childJson.length,
                                (index) =>

                                // Container(
                                //
                                //   margin: EdgeInsets.only(top: kDefaultPadding),
                                //   // padding: EdgeInsets.all(kDefaultPadding),
                                //   // decoration: BoxDecoration(
                                //   //     border: Border.all(color: kGrayColor),
                                //   //     borderRadius: BorderRadius.circular(15)),
                                //   child: Center(
                                //     child: Column(
                                //       // mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //
                                //         DropdownButton<ChildJson>(
                                //           value: dropdo[index],
                                //
                                //           // icon: Icon(Icons.keyboard_arrow_down),
                                //           items: widget.questionCtrl.childJson.map((item) {
                                //             // print(" item ${item}");
                                //             return DropdownMenuItem<ChildJson>(
                                //                 value: item,
                                //                 child: Text(item.item)
                                //             );
                                //           }
                                //           ).toList(),
                                //           onChanged: (ChildJson newValue){
                                //             print("fesfcscscs }");
                                //             print("fesf ${newValue.item}");
                                //             setState(() {
                                //               dropdo[index] = newValue;
                                //               print("fessccsf ${newValue.item}");
                                //               print("selectedChild ${dropdo[index].item}");
                                //             });
                                //           },
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // )
                          OptionChild(
                            socket:widget.socket,
                            bodyjs: widget.questionCtrl.body_json,
                            quizs: widget.questionCtrl,
                            index: index,
                            child: widget.questionCtrl.childJson,
                            press: () => {},
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        }
      }
      else if (widget.questionCtrl.typeid == 6) {
        // temp.add(
        //     quiz_type6(questionCtrl.title, questionCtrl.body, context));
        if (widget.questionCtrl.childJson != null &&
            widget.questionCtrl.childJson.length > 0) {
          // print('Adding VERTICAL pages ... len = '+slides[i].child.length.toString());
          temp.add(
            Column(
              children: [
                Text(
                  widget.questionCtrl.title, // "vdvsdv",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: kBlackColor),
                ), // main_quiz(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ...List.generate(
                            widget.questionCtrl.body_json.length,
                                (index) => Container(
                              margin: EdgeInsets.only(top: kDefaultPadding),
                              padding: EdgeInsets.all(kDefaultPadding),
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: kGrayColor),
                              //     borderRadius: BorderRadius.circular(15)),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${index + 1} ${widget.questionCtrl.body_json[index].item}",
                                    style: TextStyle(
                                        color: kBlackColor, fontSize: 16),
                                  ),

                                  // OptionChild()
                                ],
                              ),
                            )),
                      ],
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List.generate(
                          widget.questionCtrl.childJson.length,
                              (index) =>

                          // MultiSelectChipField(
                          //   items: widget.questionCtrl.childJson.map((e) => MultiSelectItem(e, e.item)).toList(),
                          //   // icon: Icon(Icons.check),
                          //   onTap: (values) {
                          //         setState(() {
                          //           selectedAnimals = values[index];
                          //           print("vdsvasda ${values[0].item}");
                          //         });
                          //   },
                          // ),
                              // TODO
                          // MultiSelectDialogField(
                          //   items: widget.questionCtrl.childJson.map((e) => MultiSelectItem(e, e.item)).toList(),
                          //   listType: MultiSelectListType.LIST,
                          //   buttonText: Text("Олон сонгох"),
                          //   decoration: BoxDecoration(
                          //     // color: Colors.blue.withOpacity(0.1),
                          //     borderRadius: BorderRadius.all(Radius.circular(10)),
                          //     border: Border.all(
                          //       color: Colors.blue,
                          //       width: 2,
                          //     ),
                          //   ),
                          //   // chipDisplay: MultiSelectChipDisplay(
                          //   //   onTap: (value) {
                          //   //     setState(() {
                          //   //       print("value ${value}");
                          //   //       selectedAnimals.remove(value);
                          //   //     });
                          //   //   },
                          //   // ),
                          //
                          //   onConfirm: (values) {
                          //     setState(() {
                          //       selectedAnimals=[];
                          //       for(var i=0; i < values.length;i++){
                          //         selectedAnimals.add(values[i].id);
                          //       }
                          //       print("id=${widget.questionCtrl.id}, answer:${widget.questionCtrl.body_json[index].id} match ${selectedAnimals}");
                          //
                          //
                          //       if (globalSelect.selChild.length > 0) {
                          //         for (var i = 0; i < globalSelect.selChild.length; i++) {
                          //           // print("${widget.bodyjs[widget.index].id}============= ${globalSelect.selChild[i]['id']}");
                          //           if (globalSelect.selChild[i]['id'] ==
                          //               widget.questionCtrl.body_json[index].id) {
                          //             // print("index ${list}");
                          //             list = globalSelect.selChild.firstWhere((element) {
                          //               return element['id'] ==
                          //                   widget.questionCtrl.body_json[index].id;
                          //             });
                          //           }
                          //         }
                          //         if (list != null) {
                          //           for (var i = 0; i < globalSelect.selChild.length; i++) {
                          //             if (globalSelect.selChild[i]['id'] ==
                          //                 widget.questionCtrl.body_json[index].id) {
                          //               globalSelect.selChild[i] = {
                          //                 'id': widget.questionCtrl.body_json[index].id,
                          //                 'match': selectedAnimals
                          //               };
                          //             }
                          //           }
                          //           print("============= ");
                          //         } else {
                          //           print(
                          //               "adddddddddddddddddddd ${globalSelect.selChild.length}");
                          //           globalSelect.selChild.add({
                          //             'id': widget.questionCtrl.body_json[index].id,
                          //             'match': selectedAnimals
                          //           });
                          //         }
                          //       } else {
                          //         globalSelect.selChild.add({
                          //           'id': widget.questionCtrl.body_json[index].id,
                          //           'match': selectedAnimals
                          //         });
                          //         print("child addddd ${globalSelect.selChild.length}");
                          //       }
                          //       print("child length ${globalSelect.selChild}");
                          //       socketAnswer.add({
                          //         'id': widget.socket.id,
                          //         'msg':{
                          //           'userId': 1,
                          //           'questionId':widget.questionCtrl.id,
                          //           'answer':globalSelect.selChild} });
                          //       globalSelect.selectedAnswers(widget.questionCtrl.id, globalSelect.selChild);
                          //       widget.socket.emit('sendAnswer',socketAnswer);
                          //       socketAnswer=[];
                          //     });
                          //   },
                          // ),
                              OptionChild(
                                socket:widget.socket,
                                bodyjs: widget.questionCtrl.body_json,
                                quizs: widget.questionCtrl,
                                index: index,
                                child: widget.questionCtrl.childJson,
                                press: () => {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // selectedAnimals.map((e) => new Text(e)).toList();
                // for(var i in selectedAnimals){
                //   chid: Text(selectedAnimals.length>0? selectedAnimals[i].item.toString() :'')
                // },
                Text( selectedAnimals.toString())
              ],
            ),
          );
        }
      }
      else if (widget.questionCtrl.typeid == 7) {

        temp.add(Column(
          children: [
            Text(
              widget.questionCtrl.title, // "vdvsdv",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: kBlackColor),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kGrayColor),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                onChanged: (text){
                  setState(() {
                    // print("id=${widget.questionCtrl.id},answer: ${text}");

                    socketAnswer.add({
                      'id': widget.socket.id,
                      'msg':{
                        'userId': myUserId,
                        'questionId':widget.questionCtrl.id,
                        'answer':[{'id':text}]} });
                    // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
                    // );
                    // print(socketAnswer);
                    globalSelect.selectedAnswers(widget.questionCtrl.id, [text]);
                    widget.socket.emit('sendAnswer',socketAnswer);
                    socketAnswer=[];
                  });
                },
                // minLines: 6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], //
              ),
            ),

          ],
        ));
      }
      else if (widget.questionCtrl.typeid == 8) {

        temp.add(Column(
          children: [
            Text(
              widget.questionCtrl.title, // "vdvsdv",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: kBlackColor),
            ),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kGrayColor),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                onChanged: (text){
                  setState(() {
                    socketwrite = text;
                    // print("id=${widget.questionCtrl.id},answer: ${text}");

                  });
                },
                minLines: 6,
                // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
            IconButton(
                icon: const Icon(Icons.save),
                onPressed:(){
                  setState(() {
                    socketAnswer.add({
                      'id': widget.socket.id,
                      'msg':{
                        'userId': myUserId,
                        'questionId':widget.questionCtrl.id,
                        'answer':[{'id':1, 'textvalue':socketwrite}]} });
                    // print("id:${socket.id},\n msg: {\nuser_id: 1,\n id:'${widget.questionCtrl.id}', \n answer:[{id:${widget.questionCtrl.body_json[selectedEegii].id}}]\n}"
                    // );
                    // print(socketAnswer);
                    globalSelect.selectedAnswers(widget.questionCtrl.id, [{'id':1, 'textvalue':socketwrite}]);
                    widget.socket.emit('sendAnswer',socketAnswer);
                    socketAnswer=[];
                  });
                })
          ],
        ));
      }
    // }
    return temp;
  }
}
