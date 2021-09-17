import 'package:flutter/material.dart';
import 'package:lms_app/globalValues.dart';
import 'package:lms_app/models/quesion_ctrl.dart';

import 'package:lms_app/ui/views/quiz/components/widgetss.dart' as globalSelect;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../../constants.dart';

class OptionChild extends StatefulWidget {
  IO.Socket socket;
  QuestionCtrl quizs;
  List<Body_json> bodyjs;
  OptionChild(
      {Key key,
      this.socket,
      this.bodyjs,
      this.quizs,
      this.child,
      this.index,
      this.press})
      : super(key: key);
  final List<ChildJson> child;
  final int index;
  final VoidCallback press;
  @override
  State<OptionChild> createState() => _OptionChildState();
}

class _OptionChildState extends State<OptionChild> {
  List answer = [];

  // var items =  ['Apple','Banana','Grapes','Orange','watermelon','Pineapple'];
  ChildJson selectedChild;

  // List<ChildJson> child=List();
  List childs = [];
  List socketans = [];
  var list;
  var lists;
  @override
  void initState() {

    selectedChild = widget.child[0];
    // if (globalSelect.SaveAnswers.length > 0) {
    //   print("indecscscx ${widget.quizs.id}");
    //   for (var i = 0; i < globalSelect.SaveAnswers.length; i++) {
    //     if (globalSelect.SaveAnswers[i]['questionId'] == widget.quizs.id) {
    //       // print("index ${list}");
    //       lists = globalSelect.SaveAnswers.firstWhere((element) {
    //         return element['questionId'] ==
    //             widget.quizs.id;
    //       });
    //     }
    //   }
    //   if (lists != null) {
    //     for (var i = 0; i < globalSelect.SaveAnswers.length; i++) {
    //       if (lists['answers'][i]['match']!=null) {
    //         print("taaraw ${lists['answers'][i]['match']}");
    //         // globalSelect.SaveAnswers[i] = {
    //         //   'id': widget.bodyjs[widget.index].id,
    //         //   'match': selectedChild.id
    //         // };
    //       }
    //     }
    //     print("============= ");
    //   }
    //   // else {
    //   //   print(
    //   //       "adddddddddddddddddddd ${globalSelect.SaveAnswers.length}");
    //   //   // globalSelect.SaveAnswers.add({
    //   //   //   'id': widget.bodyjs[widget.index].id,
    //   //   //   'match': selectedChild.id
    //   //   // });
    //   // }
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: kDefaultPadding),
      // padding: EdgeInsets.all(kDefaultPadding),
      // decoration: BoxDecoration(
      //     border: Border.all(color: kGrayColor),
      //     borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<ChildJson>(
              value: selectedChild, // icon: Icon(Icons.keyboard_arrow_down),
              items: widget.child.map((item) {
                return DropdownMenuItem<ChildJson>(
                    value: item, child: Text(item.item));
              }).toList(),
              onChanged: (ChildJson newValue) {
                // print("fesf ${newValue.item}");
                setState(() {
                  selectedChild = newValue;
                  // print("fesf ${selectedChild.id} ${widget.bodyjs[widget.index].id} ${widget.index}");
                  // answer.add(selectedChild);
                  // print("${answer.length}");
                  // socketans.add({
                  //   'id': widget.socket.id,
                  //   'msg':{
                  //     'userId': 1,
                  //     'questionId':widget.quizs.id,
                  //     'answer':[{'id':widget.bodyjs[widget.index].id,'match':selectedChild.id }]} });
                  if (globalSelect.selChild.length > 0) {
                    for (var i = 0; i < globalSelect.selChild.length; i++) {
                      // print("${widget.bodyjs[widget.index].id}============= ${globalSelect.selChild[i]['id']}");
                      if (globalSelect.selChild[i]['id'] ==
                          widget.bodyjs[widget.index].id) {
                        // print("index ${list}");
                        list = globalSelect.selChild.firstWhere((element) {
                          return element['id'] ==
                              widget.bodyjs[widget.index].id;
                        });
                      }
                    }
                    if (list != null) {
                      for (var i = 0; i < globalSelect.selChild.length; i++) {
                        if (globalSelect.selChild[i]['id'] ==
                            widget.bodyjs[widget.index].id) {
                          globalSelect.selChild[i] = {
                            'id': widget.bodyjs[widget.index].id,
                            'match': selectedChild.id
                          };
                        }
                      }
                      print("============= ");
                    } else {
                      print(
                          "adddddddddddddddddddd ${globalSelect.selChild.length}");
                      globalSelect.selChild.add({
                        'id': widget.bodyjs[widget.index].id,
                        'match': selectedChild.id
                      });
                    }
                  } else {
                    globalSelect.selChild.add({
                      'id': widget.bodyjs[widget.index].id,
                      'match': selectedChild.id
                    });
                    print("child addddd ${globalSelect.selChild.length}");
                  }
                  print("child length ${globalSelect.selChild}");
                  globalSelect.selectedAnswers(
                      widget.quizs.id, globalSelect.selChild);
                  socketans.add({
                    'id': widget.socket.id,
                    'msg':{
                      'userId': myUserId,
                      'questionId':widget.quizs.id,
                      'answer':globalSelect.selChild} });
                  widget.socket.emit('sendAnswer',socketans);
                  socketans=[];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
