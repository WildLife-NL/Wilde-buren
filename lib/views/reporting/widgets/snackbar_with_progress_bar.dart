import 'package:flutter/material.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/views/reporting/questionnaire/questionnaire.dart';
import 'dart:async';

import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/questionnaire.dart';

class SnackBarWithProgress extends StatefulWidget {
  const SnackBarWithProgress({
    super.key,
    required this.title,
    required this.description,
    this.duration,
  });

  final String title;
  final String description;
  final Duration? duration;

  static void show({
    required BuildContext context,
    required Interaction interaction,
    required Questionnaire questionnaire,
  }) {
    final snackBar = SnackBar(
      content: const SnackBarWithProgress(
        title: "Bedankt, je rapportage is gemaakt!",
        description: "Vragenlijst over je rapportage invullen?",
        duration: Duration(seconds: 5),
      ),
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        top: 10.0,
        bottom: 0.0,
      ),
      action: SnackBarAction(
        label: "Open",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionnaireView(
                interaction: interaction,
                questionnaire: questionnaire,
                initialPage: 0,
              ),
            ),
          );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  SnackBarWithProgressState createState() => SnackBarWithProgressState();
}

class SnackBarWithProgressState extends State<SnackBarWithProgress> {
  double progress = 0.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    final int tickCount =
        widget.duration != null ? widget.duration!.inSeconds * 100 : 5 * 100;
    final double increment = 1 / tickCount;

    timer = Timer.periodic(
      const Duration(milliseconds: 10),
      (Timer timer) {
        setState(() {
          progress += increment;
          if (progress >= 1) {
            progress = 1.0;
            timer.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            left: 12.0,
            right: 12.0,
          ),
          child: Column(
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
            valueColor:
                const AlwaysStoppedAnimation<Color>(CustomColors.primary),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
