import 'package:flutter/material.dart';
import 'package:src_kstu_app/components/colors.dart';
import 'package:src_kstu_app/main.dart';

SnackBar customSnackBar({
  required String message,
  Color? backgroundColor,
  String actionLabel = 'Dismiss',
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 5),
  bool persist = false,
}) {
  return SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor ?? topColor,
    behavior: SnackBarBehavior.floating,
    duration: duration,
    persist: persist,
    action: SnackBarAction(
      label: actionLabel,
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: onAction ??
          () {
            scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
          },
    ),
  );
}

void showAppSnackBar({
  BuildContext? context,
  required String message,
  Color? backgroundColor,
  String actionLabel = 'Dismiss',
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 5),
  bool persist = false,
}) {
  final snackBar = customSnackBar(
    message: message,
    backgroundColor: backgroundColor,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
    persist: persist,
  );

  final messenger = scaffoldMessengerKey.currentState ??
      (context != null ? ScaffoldMessenger.maybeOf(context) : null);

  messenger
    ?..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
