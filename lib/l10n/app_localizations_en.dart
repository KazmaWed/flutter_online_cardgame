// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Comparing Acorns To Acorns Game';

  @override
  String get createNewGame => 'Create New Game';

  @override
  String get joinGame => 'Join Game';

  @override
  String get howToPlay => 'How to Play';

  @override
  String get start => 'Start';

  @override
  String get joinGameTitle => 'Join Game';

  @override
  String get enterCodeInstruction => 'Enter 4-digit code';

  @override
  String get join => 'Join';

  @override
  String get matchingTitle => 'Matching';

  @override
  String get password => 'Password';

  @override
  String get sharePasswordInstruction =>
      'Share the password with other players\nor copy and share the invitation URL';

  @override
  String get urlCopiedMessage => 'Invitation URL copied';

  @override
  String get tapToCopyInviteUrl => 'Tap to copy invitation URL';

  @override
  String get you => 'You';

  @override
  String get avatar => 'Avatar';

  @override
  String get selectAvatar => 'Select Avatar';

  @override
  String get enterPlayerNameInstruction => 'Please set a nice player name';

  @override
  String get playerNameLabel => 'Player Name';

  @override
  String get participants => 'Participants';

  @override
  String get recommendedTopics => 'Recommended Topics';

  @override
  String get notSet => 'Not Set';

  @override
  String get setTopicInstruction => 'Set a topic to discuss';

  @override
  String get topicLabel => 'Topic';

  @override
  String get startGame => 'Start Game';

  @override
  String get kickPlayerTitle => 'Kick Player';

  @override
  String get noPlayersMessage => 'No participating players';

  @override
  String get kick => 'Kick';

  @override
  String get chooseFromRecommendations => 'Choose from\nRecommendations';

  @override
  String get cancel => 'Cancel';

  @override
  String get submit => 'Submit';

  @override
  String get topic => 'Topic';

  @override
  String get everyonesAnswers => 'Everyone\'s Answers';

  @override
  String get yourNumberIs => 'Your number is';

  @override
  String get desu => '.';

  @override
  String get viewResults => 'View Results';

  @override
  String submissionStatus(int sent, int total) {
    return '$sent of $total submitted';
  }

  @override
  String submitInstruction(int rank) {
    String _temp0 = intl.Intl.pluralLogic(
      rank,
      locale: localeName,
      other: 'Submit when you think it\'s the ${rank}th smallest',
      one: 'Submit when you think it\'s the smallest',
    );
    return '$_temp0';
  }

  @override
  String submitInstructionWithOrdinal(Object ordinal) {
    return 'Submit when you think it\'s the $ordinal smallest';
  }

  @override
  String submitted(int order) {
    return 'Submitted $order';
  }

  @override
  String get hint => 'Hint';

  @override
  String get results => 'Results';

  @override
  String get correctAnswers => 'Correct Answers';

  @override
  String get scoreSeparator => '/';

  @override
  String get perfectGameMessage => 'It was a very good acorn comparison!';

  @override
  String get goodGameMessage => 'It was a pretty good acorn comparison';

  @override
  String get correctAnswersAnnouncement => 'Correct Answer Announcement';

  @override
  String get startNewGame => 'Start New Game';

  @override
  String get playerHeader => 'Player';

  @override
  String get hintHeader => 'Hint Given';

  @override
  String get numberHeader => 'Number';

  @override
  String get guessHeader => 'Guess';

  @override
  String get correctHeader => 'Correct';

  @override
  String get numberSuffix => '';

  @override
  String get errorTitle => 'Error';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get gameNotFound => 'Game not found';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get defaultName => 'Anonymous';

  @override
  String get defaultHint => 'No hint';

  @override
  String get userNotAuthenticated => 'User is not authenticated.';

  @override
  String get playerNotFound => 'Player data not found for user:';

  @override
  String get noGameWithPassword => 'No game found with the given password.';

  @override
  String get gameWatchFailed => 'Failed to watch game by ID:';

  @override
  String get confirmExitGameTitle => 'Exit game?';

  @override
  String get confirmExitGameMessage =>
      'The game will continue even if you leave';

  @override
  String get exitGame => 'Exit';

  @override
  String get flutterDemoTitle => 'Flutter Demo';

  @override
  String get dataLoadFailed => 'Failed to load data';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get github => 'Github';

  @override
  String get license => 'License';

  @override
  String get howToPlayTitle => 'How to Play';

  @override
  String get instructionLoadFailed => 'Failed to load instructions';

  @override
  String get reload => 'Reload';

  @override
  String get notSubmitted => 'Not submitted';

  @override
  String playerId(String playerId) {
    return 'ID: $playerId';
  }

  @override
  String hintTemplate(int value, String topic) {
    return 'Enter something about $value out of 1-100 for \"$topic\"';
  }

  @override
  String submitOrderText(int order) {
    return 'Submitted ${order}th';
  }

  @override
  String playerNotFoundError(String playerId) {
    return 'Player data not found for user: $playerId';
  }

  @override
  String gameWatchError(String error) {
    return 'Failed to watch game by ID: $error';
  }
}
