import 'package:flutter/material.dart';

class ShowcaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const ShowcaseScaffold({super.key, required this.title, required this.body,});

  @override
  Widget build(BuildContext context) {
    // Hereda el tema actual del MaterialApp (oscuro o claro)
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: body,
      ),
    );
  }
}
