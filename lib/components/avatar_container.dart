import 'package:flutter/material.dart';

class AvatarContainer extends StatelessWidget {
  final double size;
  final String fileName;
  const AvatarContainer({super.key, required this.size, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
        image: DecorationImage(image: AssetImage(fileName), fit: BoxFit.cover),
      ),
    );
  }
}

class AvatarButtonContainer extends StatelessWidget {
  final double size;
  final String fileName;
  final VoidCallback onTap;
  const AvatarButtonContainer({
    super.key,
    required this.size,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1),
        image: DecorationImage(image: AssetImage(fileName), fit: BoxFit.cover),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: const SizedBox.expand(),
      ),
    );
  }
}
