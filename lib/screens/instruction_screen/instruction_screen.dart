import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/model/instruction_data.dart';
import 'package:flutter_online_cardgame/screens/instruction_screen/instruction_screen_components.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  late PageController _pageController;
  InstructionData? _instructionData;
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadInstructions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadInstructions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/instructions.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final instructionData = InstructionData.fromJson(jsonData);

      setState(() {
        _instructionData = instructionData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < (_instructionData?.pages.length ?? 0) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.howToPlayTitle), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _instructionData == null
          ? Center(child: Text(AppLocalizations.of(context)!.instructionLoadFailed))
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InstructionImageArea(
                      pages: _instructionData!.pages,
                      pageController: _pageController,
                      currentPage: _currentPage,
                      onPreviousPage: _previousPage,
                      onNextPage: _nextPage,
                      onPageChanged: _onPageChanged,
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _instructionData!.pages.length,
                      effect: WormEffect(
                        dotColor: Theme.of(context).colorScheme.primary.withAlpha(100),
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotHeight: AppDimentions.paddingMedium,
                        dotWidth: AppDimentions.paddingMedium,
                      ),
                    ),
                    InstructionTextArea(pages: _instructionData!.pages, currentPage: _currentPage),
                  ],
                ),
              ),
            ),
    );
  }
}
