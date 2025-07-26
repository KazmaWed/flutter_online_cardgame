import 'package:flutter/services.dart';

class FullWidthDigitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final convertedText = _convertFullWidthToHalfWidth(newValue.text);
    
    if (convertedText == newValue.text) {
      return newValue;
    }
    
    return TextEditingValue(
      text: convertedText,
      selection: TextSelection.collapsed(offset: convertedText.length),
    );
  }
  
  String _convertFullWidthToHalfWidth(String input) {
    const fullWidthDigits = '０１２３４５６７８９';
    const halfWidthDigits = '0123456789';
    
    String result = input;
    for (int i = 0; i < fullWidthDigits.length; i++) {
      result = result.replaceAll(fullWidthDigits[i], halfWidthDigits[i]);
    }
    
    return result;
  }
}