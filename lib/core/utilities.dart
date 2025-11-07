import 'package:flutter/material.dart';
import 'dart:async';

// Hỗ trợ hiển thị Snackbar
void showSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
  bool isSuccess = false,
}) {
  Color backgroundColor = Colors.grey[700]!;
  if (isError) {
    backgroundColor = Colors.redAccent;
  } else if (isSuccess) {
    backgroundColor = Colors.green;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 2),
    ),
  );
}

// Rx: Hỗ trợ kết hợp streams (dùng trong Pomodoro)
class Rx {
  static Stream<T> combineLatest2<T1, T2, T>(
    Stream<T1> stream1,
    Stream<T2> stream2,
    T Function(T1, T2) combiner,
  ) {
    T1? last1;
    T2? last2;
    var controller = StreamController<T>();

    void update() {
      if (last1 != null && last2 != null) {
        controller.add(combiner(last1 as T1, last2 as T2));
      }
    }

    stream1
        .listen((data) {
          last1 = data;
          update();
        })
        .onDone(() {
          if (!controller.isClosed) controller.close();
        });

    stream2
        .listen((data) {
          last2 = data;
          update();
        })
        .onDone(() {
          if (!controller.isClosed) controller.close();
        });

    return controller.stream;
  }
}
