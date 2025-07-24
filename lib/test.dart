import 'package:first_flutter_app/app/app.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

void updateState() {
  MyApp.instance.appState = 0;
    // This method is intended to update the state of the widget.
    // However, since this is a StatelessWidget, it cannot have mutable state.
    // Consider using a StatefulWidget if you need to manage state.
  }

  void getState() {
    print(MyApp.instance.appState);
    // This method is intended to retrieve the current state of the widget.
    // However, since this is a StatelessWidget, it does not have a state object.
    // Consider using a StatefulWidget if you need to manage state.
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}