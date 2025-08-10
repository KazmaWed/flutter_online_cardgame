import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom input formatter that counts non-ASCII characters as 2 characters
/// and ASCII characters as 1 character for length limiting.
class MultiByteLengthFormatter extends TextInputFormatter {
  final int maxLength;

  MultiByteLengthFormatter(this.maxLength);

  /// Calculates the weighted length where non-ASCII characters count as 2
  static int getWeightedLength(String text) {
    int length = 0;
    for (int i = 0; i < text.length; i++) {
      int codeUnit = text.codeUnitAt(i);
      // ASCII characters (0-127) count as 1, others count as 2
      length += (codeUnit <= 127) ? 1 : 2;
    }
    return length;
  }

  /// Custom counter builder that shows weighted character count
  static Widget? counterBuilder(BuildContext context, {required int currentLength, required int? maxLength, required bool isFocused}) {
    if (maxLength == null) return null;
    
    return Text(
      '$currentLength/$maxLength',
      style: Theme.of(context).textTheme.bodySmall,
      semanticsLabel: 'character count',
    );
  }

  /// Creates a custom counter builder function for a specific text controller
  static InputCounterWidgetBuilder createCounterBuilder(TextEditingController controller, int maxLength) {
    return (BuildContext context, {required int currentLength, required int? maxLength, required bool isFocused}) {
      final weightedLength = getWeightedLength(controller.text);
      return Text(
        '$weightedLength/$maxLength',
        style: Theme.of(context).textTheme.bodySmall,
        semanticsLabel: 'character count',
      );
    };
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new text is within the weighted length limit, allow it
    if (getWeightedLength(newValue.text) <= maxLength) {
      return newValue;
    }

    // If it exceeds, find the maximum valid substring
    String validText = '';
    int currentLength = 0;
    
    for (int i = 0; i < newValue.text.length; i++) {
      int codeUnit = newValue.text.codeUnitAt(i);
      int charWeight = (codeUnit <= 127) ? 1 : 2;
      
      if (currentLength + charWeight <= maxLength) {
        validText += newValue.text[i];
        currentLength += charWeight;
      } else {
        break;
      }
    }

    // Return the truncated text with adjusted cursor position
    int newSelectionIndex = validText.length;
    if (newValue.selection.baseOffset < validText.length) {
      newSelectionIndex = newValue.selection.baseOffset;
    }

    return TextEditingValue(
      text: validText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}