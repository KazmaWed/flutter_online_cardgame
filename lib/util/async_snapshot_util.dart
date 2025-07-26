import 'package:flutter/material.dart';

extension AsyncSnapshotExtension<T> on AsyncSnapshot<T> {
  bool get isWaiting => connectionState == ConnectionState.waiting;
  bool get isDone => connectionState == ConnectionState.done;
  bool get isActive => connectionState == ConnectionState.active;
  bool get isNone => connectionState == ConnectionState.none;
}
