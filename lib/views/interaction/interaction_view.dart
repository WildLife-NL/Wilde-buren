import 'package:flutter/material.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';

class InteractionView extends StatefulWidget {
  const InteractionView({super.key});

  @override
  State<InteractionView> createState() => _InteractionViewState();
}

class _InteractionViewState extends State<InteractionView> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(body: Center(child: Text('Meldingen')));
  }
}
