import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  final bool showAppBar;
  const ProgressScreen({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
