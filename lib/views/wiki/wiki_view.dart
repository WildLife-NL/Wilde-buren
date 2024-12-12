import 'package:flutter/material.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';

class SpeciesView extends StatefulWidget {
  const SpeciesView({super.key});

  @override
  State<SpeciesView> createState() => _SpeciesViewState();
}

class _SpeciesViewState extends State<SpeciesView> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(body: Center(child: Text('Wiki')));
  }
}
