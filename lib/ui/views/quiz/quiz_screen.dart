import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lms_app/models/quesion_ctrl.dart';
import '../../../constants.dart';
import '../../../controller/question_controller.dart';

import 'components/body.dart';
import 'components/progress_bar.dart';
import 'components/question_card.dart';

class QuizScreen extends StatelessWidget {
  QuestionCtrl questionCtrl;
  @override
  Widget build(BuildContext context) {
    // QuestionController _questionController = Get.put(QuestionController());
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // ignore: deprecated_member_use
          FlatButton(onPressed: _controller.nextQuestion, child: Text("Skip")),
        ],
      ),
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: ProgressBar(),
                ),
                SizedBox(height: kDefaultPadding),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Obx(
                        () => Text.rich(
                      TextSpan(
                        text:
                        "Question ${_controller.questionNumber.value}",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: kSecondaryColor),
                        children: [
                          TextSpan(
                            text: "/${_controller.questions.length}",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(color: kSecondaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(thickness: 1.5),
                SizedBox(height: kDefaultPadding),
                // Expanded(
                //   child: PageView.builder(
                //     // Block swipe to next qn
                //     physics: NeverScrollableScrollPhysics(),
                //     controller: _controller.pageController,
                //     onPageChanged: _controller.updateTheQnNum,
                //     itemCount: _controller.questions.length,
                //     itemBuilder: (context, index) => QuestionCard(
                //         question: _controller.questions[index]),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
