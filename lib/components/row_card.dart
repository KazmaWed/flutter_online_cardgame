import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

/// A reusable Card widget with a centered Row containing a Column.
/// The Column accepts a list of children and optional spacing.
class RowCard extends StatelessWidget {
  final List<Widget> children;
  final double padding;
  final double spacing;
  final double cornerRadius = 4.0;

  const RowCard({
    super.key,
    required this.children,
    this.padding = AppDimentions.paddingMedium,
    this.spacing = AppDimentions.paddingMedium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        child: Column(
          spacing: spacing,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
