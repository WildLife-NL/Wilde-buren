import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/services/response.dart';
import 'package:wilde_buren/views/home/home_view.dart';
import 'package:wilde_buren/views/reporting/questionnaire/questionnaire_card.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/question.dart';
import 'package:wildlife_api_connection/models/questionnaire.dart';

class QuestionnaireView extends StatefulWidget {
  final Interaction interaction;
  final Questionnaire questionnaire;
  final int initialPage;

  const QuestionnaireView({
    super.key,
    required this.interaction,
    required this.questionnaire,
    required this.initialPage,
  });

  @override
  QuestionnaireViewState createState() => QuestionnaireViewState();
}

class QuestionnaireViewState extends State<QuestionnaireView> {
  final PageController _pageController = PageController();
  final Map<Question, List<String>> _answers = {};

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildQuestionnairePages() {
    List<Widget> pages = [];

    if (widget.questionnaire.questions != null) {
      for (var i = 0; i < widget.questionnaire.questions!.length; i++) {
        pages.add(
          QuestionnaireCardView(
            question: widget.questionnaire.questions![i],
            onPressed: () {
              if (i != widget.questionnaire.questions!.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                if (_answers.isNotEmpty) {
                  for (var entry in _answers.entries) {
                    final question = entry.key;
                    final answers = entry.value;

                    final questionId = question.id;

                    for (var answer in answers) {
                      ResponseService().createResponse(
                        widget.interaction.id ?? "",
                        questionId,
                        question.allowMultipleResponse ? "" : answer,
                        question.allowMultipleResponse ? answer : "",
                      );
                    }
                  }
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeView(),
                  ),
                  (route) => false,
                );
              }
            },
            goToPreviousPage: _pageController.previousPage,
            onAnswer: (Question question, List<String> answer) {
              setState(() {
                _answers[question] = answer;
              });
            },
            buttonText: i == widget.questionnaire.questions!.length - 1
                ? "Afronden"
                : "Volgende",
            isFirst: i == 0 ? true : false,
          ),
        );
      }
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _buildQuestionnairePages(),
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: _pageController,
            count: _buildQuestionnairePages().length,
            effect: const WormEffect(
              activeDotColor: CustomColors.primary,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
