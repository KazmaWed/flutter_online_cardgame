import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/constants/app_dimentions.dart';
import 'package:flutter_online_cardgame/util/navigator_util.dart';
import 'package:flutter_online_cardgame/l10n/app_localizations.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScaffold(
      appBar: AppBar(
        title: Text(l10n.errorTitle),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).popToTop();
            // FirebaseRepository().writer.resetPlayer();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  if (kIsWeb) web.window.location.reload();
                },
                icon: Icon(Icons.refresh, size: Theme.of(context).textTheme.bodyLarge!.fontSize!),
                label: Text(AppLocalizations.of(context)!.reload, style: Theme.of(context).textTheme.bodyLarge),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(AppDimentions.paddingLarge),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              message ?? l10n.unexpectedError,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
