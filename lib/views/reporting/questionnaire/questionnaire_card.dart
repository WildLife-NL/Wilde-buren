import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wildlife_api_connection/models/question.dart';

class QuestionnaireCardView extends StatefulWidget {
  final Question question;
  final Function onPressed;
  final Function goToPreviousPage;
  final String buttonText;
  final Function(Question question, List<String> answer) onAnswer;
  final bool isFirst;

  const QuestionnaireCardView({
    super.key,
    required this.question,
    required this.onPressed,
    required this.goToPreviousPage,
    required this.buttonText,
    required this.onAnswer,
    required this.isFirst,
  });

  @override
  QuestionnaireCardViewState createState() => QuestionnaireCardViewState();
}

class QuestionnaireCardViewState extends State<QuestionnaireCardView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();

  Set<int> _selectedIndices = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int longestAnswerLength = widget.question.answers != null
        ? widget.question.answers!
            .map((answer) => answer.text.length)
            .reduce((a, b) => a > b ? a : b)
        : 0;

    int crossAxisCount = longestAnswerLength >= 30 ? 1 : 2;
    double childAspectRatio = longestAnswerLength >= 30 ? 5 : 2.5;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                  color: CustomColors.primary,
                ),
                onPressed: () {
                  if (!widget.isFirst) {
                    widget.goToPreviousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.question.text,
                  style: const TextStyle(
                    color: CustomColors.primary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  widget.question.description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.question.allowOpenResponse) ...[
                  TextFormField(
                    controller: _answerController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      labelText: 'Geef hier je antwoord',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: widget.question.openResponseFormat != null
                        ? widget.question.openResponseFormat!.toLowerCase() ==
                                "string"
                            ? TextInputType.multiline
                            : TextInputType.number
                        : TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veld mag niet leeg zijn.";
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  if (widget.question.answers != null) ...[
                    SizedBox(
                      height: crossAxisCount == 1
                          ? widget.question.answers!.length * 135
                          : (widget.question.answers!.length / 2) * 135,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: widget.question.answers!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final answer = widget.question.answers![index].text;
                          final isSelected = _selectedIndices.contains(index);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (widget.question.allowMultipleResponse) {
                                  if (isSelected) {
                                    _selectedIndices.remove(index);
                                  } else {
                                    _selectedIndices.add(index);
                                  }
                                } else {
                                  _selectedIndices = {index};
                                }
                              });

                              widget.onAnswer(
                                widget.question,
                                _selectedIndices
                                    .map((i) => widget.question.answers![i].id)
                                    .toList(),
                              );

                              if (!widget.question.allowMultipleResponse) {
                                widget.onPressed();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? CustomColors.primary.withOpacity(0.2)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    if (!widget
                                        .question.allowMultipleResponse) ...[
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: SvgPicture.asset(
                                              AssetIcons.getNumberIcon(
                                                  index + 1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      Checkbox(
                                        value: isSelected,
                                        activeColor: CustomColors.primary,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedIndices.add(index);
                                            } else {
                                              _selectedIndices.remove(index);
                                            }
                                          });

                                          widget.onAnswer(
                                            widget.question,
                                            _selectedIndices
                                                .map((i) => widget
                                                    .question.answers![i].id)
                                                .toList(),
                                          );
                                        },
                                      ),
                                    ],
                                    const SizedBox(width: 8.0),
                                    Flexible(
                                      child: Text(answer),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.question.allowOpenResponse) {
                        widget.onAnswer(
                          widget.question,
                          [_answerController.text.trim()],
                        );
                        widget.onPressed();
                      } else {
                        if (_selectedIndices.isNotEmpty) {
                          widget.onAnswer(
                            widget.question,
                            _selectedIndices
                                .map((i) => widget.question.answers![i].id)
                                .toList(),
                          );
                          widget.onPressed();
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: CustomColors.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
