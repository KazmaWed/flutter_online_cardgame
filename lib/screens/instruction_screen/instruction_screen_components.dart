import 'package:flutter/material.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';

import 'package:flutter_online_cardgame/model/instruction_data.dart';

class InstructionImageArea extends StatelessWidget {
  final List<InstructionPage> pages;
  final PageController pageController;
  final int currentPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int>? onPageChanged;

  const InstructionImageArea({
    super.key,
    required this.pages,
    required this.pageController,
    required this.currentPage,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimentions.imageSize,
      width: AppDimentions.imageSize + AppDimentions.iconButtonSize * 2,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimentions.iconButtonSize),
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final page = pages[index];
                return Center(
                  child: SizedBox(
                    width: AppDimentions.imageSize,
                    height: AppDimentions.imageSize,
                    child: Image.asset(page.image, fit: BoxFit.contain),
                  ),
                );
              },
            ),
          ),
          if (currentPage > 0)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: onPreviousPage,
                  icon: Icon(
                    Icons.chevron_left,
                    size: AppDimentions.iconButtonSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          if (currentPage < pages.length - 1)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  onPressed: onNextPage,
                  icon: Icon(
                    Icons.chevron_right,
                    size: AppDimentions.iconButtonSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InstructionTextArea extends StatelessWidget {
  final List<InstructionPage> pages;
  final int currentPage;

  const InstructionTextArea({super.key, required this.pages, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimentions.screenWidthThin,
      padding: const EdgeInsets.all(AppDimentions.paddingLarge),
      child: IndexedStack(
        index: currentPage,
        children: pages.map((page) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                page.title,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: AppDimentions.paddingLarge),
              Text(
                page.description,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
