import 'package:flutter/material.dart';

import 'cosmic_background.dart';

class CosmicScaffold extends StatelessWidget {
  const CosmicScaffold({
    super.key,
    required this.body,
    this.decorations = const <Widget>[],
  });

  final Widget body;
  final List<Widget> decorations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CosmicBackground(
        decorations: decorations,
        child: body,
      ),
    );
  }
}
