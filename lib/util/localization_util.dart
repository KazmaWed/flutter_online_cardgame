import 'package:flutter_online_cardgame/l10n/app_localizations.dart';
import 'package:flutter_online_cardgame/util/string_util.dart';

extension AppLocalizationsExtension on AppLocalizations {
  /// Returns the submitted message with proper ordinal formatting
  /// Japanese: "3番目に送信済み"
  /// English: "Submitted 3rd"
  String submittedWithOrdinal(int order) {
    if (localeName == 'en') {
      return 'Submitted ${order.ordinal}';
    }
    return submitted(order);
  }
}
