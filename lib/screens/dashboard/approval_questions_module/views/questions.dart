import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torah_share/screens/routes/routes_exporter.dart';
import 'package:torah_share/translations/locale_keys.g.dart';

import '../../../../utils/util_exporter.dart';
import '../../../../utils/widgets/widgets_exporter.dart';

class Questions extends StatefulWidget {
  @override
  _QuestionsState createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  bool isLoading = false;

  String _questionOne = tr(LocaleKeys.question_one),
      _questionSecond = tr(LocaleKeys.question_two),
      _questionThird = tr(LocaleKeys.question_three);
  TextEditingController questionOneController = new TextEditingController();

  TextEditingController questionSecondController = new TextEditingController();

  TextEditingController questionThreeController = new TextEditingController();

  @override
  void initState() {
    _processAlreadyPresentQuestions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ApplicationIcon(),
                      const SizedBox(height: 50.0),
                      PrimaryCard(
                        child: Column(
                          children: [
                            const SizedBox(height: 20.0),
                            PrimaryLabelAndField(
                              label: _questionOne,
                              hint: tr(LocaleKeys.write_answer_here),
                              controller: questionOneController,
                            ),
                            const SizedBox(height: 20.0),
                            PrimaryLabelAndField(
                              label: _questionSecond,
                              hint: tr(LocaleKeys.write_answer_here),
                              controller: questionSecondController,
                            ),
                            const SizedBox(height: 20.0),
                            PrimaryLabelAndField(
                              label: _questionThird,
                              hint: tr(LocaleKeys.write_answer_here),
                              controller: questionThreeController,
                            ),
                            const SizedBox(height: 80.0),
                            PrimaryButton(
                              value: tr(LocaleKeys.next),
                              onPressed: () => _processQuestions(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading
                ? Positioned.fill(
                    child: Container(
                      color: AppColors.blackColor.withOpacity(0.25),
                    ),
                  )
                : const SizedBox.shrink(),
            isLoading
                ? Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            AppColors.primary),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  void _processQuestions(BuildContext context) async {
    if (questionOneController.text == null ||
        questionOneController.text.isEmpty) {
      Common.showSnackBar(tr(LocaleKeys.questions_required),
          tr(LocaleKeys.answer_to_question_one));
      return;
    } else if (questionSecondController.text == null ||
        questionSecondController.text.isEmpty) {
      Common.showSnackBar(tr(LocaleKeys.questions_required),
          tr(LocaleKeys.answer_to_question_two));
      return;
    } else if (questionThreeController.text == null ||
        questionThreeController.text.isEmpty) {
      Common.showSnackBar(tr(LocaleKeys.questions_required),
          tr(LocaleKeys.answer_to_question_three));
      return;
    }

    setState(() {
      FocusScope.of(context).unfocus();
      isLoading = true;
    });

    //store the questions and move user to next screen, after taking video samples from next screen upload those with these questions
    _storeQuestionsToPreferences().then((value) {
      //take user to next screen and get video samples for admin approval
      setState(() {
        isLoading = false;
      });

      Get.toNamed(AppRoutes.videoSamplesForApprovalRoute);
    });
  }

  Future<void> _storeQuestionsToPreferences() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    List<String> questions = [], answers = [];

    // questions
    questions.add(_questionOne);
    questions.add(_questionSecond);
    questions.add(_questionThird);

    _sharedPreferences.setStringList(Common.sharedQuestionsList, questions);

    // answers
    answers.add(questionOneController.text.trim().toString());
    answers.add(questionSecondController.text.trim().toString());
    answers.add(questionThreeController.text.trim().toString());

    _sharedPreferences.setStringList(Common.sharedAnswersList, answers);
  }

  Future<void> _processAlreadyPresentQuestions() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();

    //check if questions are already stored by the user in app
    if (_sharedPreferences.getStringList(Common.sharedAnswersList) != null &&
        _sharedPreferences.getStringList(Common.sharedQuestionsList) != null) {
      //take user to video samples for approval from admin
      navigator.pushReplacementNamed(AppRoutes.videoSamplesForApprovalRoute);
    }
  }
}
