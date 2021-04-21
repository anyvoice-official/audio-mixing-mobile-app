import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<T> showPlatformDialog<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  bool androidBarrierDismissible = false,
}) {
  if (Platform.isAndroid) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: androidBarrierDismissible,
    );
  } else {
    return showCupertinoDialog<T>(
      context: context,
      builder: builder,
    );
  }
}

void loadingModal(BuildContext context, {bool isShow}) {
  if (isShow) {
    showPlatformDialog<dynamic>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: WillPopScope(
          onWillPop: () async => false, //disable back button
          child: Container(
            height: 60,
            child: CircularProgressIndicator(strokeWidth: 128.0),
          ),
        ),
      ),
    );
  } else {
    Navigator.of(context).pop();
  }
}

