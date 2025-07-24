import 'package:first_flutter_app/views/pages/expanded_flexible_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController = TextEditingController();
  bool? isChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? dropdownValue = 'dropdown1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton(
                value: dropdownValue,
                items: [
                  DropdownMenuItem(
                    value: 'dropdown1',
                    child: Text("Dropdoown1"),
                  ),
                  DropdownMenuItem(
                    value: 'dropdown2',
                    child: Text("Dropdoown2"),
                  ),
                  DropdownMenuItem(
                    value: 'dropdown3',
                    child: Text("Dropdoown3"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  setState(() {}); // Update the UI when the name changes
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                nameController.text.isEmpty
                    ? 'No name entered'
                    : 'Hello, ${nameController.text}!',
                style: TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 16.0),
              Checkbox.adaptive(
                tristate: true,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value;
                  });
                },
              ),
              CheckboxListTile.adaptive(
                tristate: true,
                title: const Text('Accept Terms and Conditions'),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Switch.adaptive(
                value: isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: const Text('Enable Notifications'),
                value: isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Slider.adaptive(
                value: sliderValue,
                min: 0.0,
                max: 100.0,
                divisions: 100,
                label: sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  // Action when the image is tapped
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Image tapped!')));
                },
                child: Image.asset('assets/images/logo.png', height: 200.0),
              ),
              const SizedBox(height: 16.0),
              InkWell(
                splashColor: Colors.teal,
                onTap: () {
                  // Action when the text is tapped
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Text tapped!')));
                },
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  color: Colors.white12,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Action for the button
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Button pressed!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Press Me'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExpandedFlexiblePage();
                      },
                    ),
                  );
                },
                child: const Text('Press Me'),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  // Action for the outlined button
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Outlined Button pressed!')),
                  );
                },
                child: const Text('Outlined Button'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Action for the text button
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Text Button pressed!'),
                    ),
                  );
                },
                child: const Text('Text Button'),
              ),
              Divider(
                color: Colors.teal,
                thickness: 2.0,
                endIndent: 100.0,
              ),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Filled Button'),
                        content: Text('This is a filled button dialog.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Filled Button'),
              ),
              const SizedBox(height: 16.0),
              CloseButton(),
              const SizedBox(height: 16.0),
              BackButton(),
            ],
          ),
        ),
      ),
    );
  }
}
