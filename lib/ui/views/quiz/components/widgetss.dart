
library globals;

 List<Map<String,dynamic>> SaveAnswers = [];
 List selChild =[];
 void selectedAnswers(String quesId, List answers){
   print("${quesId} ${answers}");
   var list;
   if(SaveAnswers.length>0){
     for(var i=0;i<SaveAnswers.length;i++){
       if(SaveAnswers[i]['questionId']==quesId){
         list = SaveAnswers.firstWhere((element) {
           return element['questionId']==quesId;
         });

       }
     }
     // print("${list}");
     if(list!=null){
       print("q id ${list['questionId']}");
       // print("update");
       // print("${answers.length}");
       list['answers'] = answers.length>1?answers:[{'id':answers[0]}];
       print("${list['answers']}");
     }
     else{
       // print("new");
       // print("${answers.length}");
       SaveAnswers.add({'questionId':quesId,'answers':answers.length>1?answers:[{'id':answers[0]}]});
     }
   }
   else{
     // print("new");
     SaveAnswers.add({'questionId':quesId,'answers':answers.length>1?answers:[{'id':answers[0]}]});
   }

  // if(SaveAnswers.length>0){
  //   // print("iffffffffff");
  //   for(var i=0;i<SaveAnswers.length;i++){
  //     if(SaveAnswers[i]['questionId']==quesId){
  //
  //       // print("if");
  //       // print(SaveAnswers.length);
  //       // SaveAnswers.removeAt(i);
  //       // print(SaveAnswers.length);
  //       // SaveAnswers.add({'questionId':quesId,'answers':answers});
  //       // SaveAnswers[i] = {'questionId':quesId,'answers':answers};
  //       SaveAnswers[i]['questionId'] = quesId;
  //       SaveAnswers[i]['answers'] = answers;
  //       // datosusuario[i].questionId = widget.questionCtrl.id;
  //       print("tentsvv $i ${SaveAnswers[i]}");
  //       // SelectedAnswer(widget.questionCtrl.id, widget.questionCtrl.body_json[selectedEegii].id);
  //       // selectedAnswer[i] = ({'questionId':widget.questionCtrl.id,
  //       //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
  //     }else{
  //       // for(var j=0;j<SaveAnswers.length;j++){
  //       //   if(SaveAnswers[i]['questionId']==SaveAnswers[j]['questionId']){
  //           print("else");
  //           print("${SaveAnswers[i]['questionId']}");
  //           SaveAnswers.add({'questionId':quesId,'answers':answers});
  //
  //       //   }
  //       // }
  //       // SaveAnswers.add({'questionId':quesId,'answers':answers});
  //       // selectedAnswer.add({'questionId':widget.questionCtrl.id,
  //       //   'answer':[{'id':widget.questionCtrl.body_json[selectedEegii].id}]});
  //     }
  //   }
  // }else{
  //   // print("elsessss");
  //   SaveAnswers.add({'questionId':quesId,'answers':answers});
  // }
 }


