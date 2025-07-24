import 'package:flutter/material.dart';

class ExpandedFlexiblePage extends StatelessWidget {
  const ExpandedFlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  height: 20,
                  child: Text('Expanded Widget'),
                ),
              ),
              Flexible(
                child: Container(
                  color: Colors.blue,
                  height: 20,
                  child: Text('Flexible Widget'),
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Flexible(
                flex: 4,
                child: Container(
                  color: Colors.orange,
                  height: 20,
                  child: Text('Flexible with Flex 1'),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.green,
                  height: 20,
                  child: Text('Expanded with Flex 2'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
