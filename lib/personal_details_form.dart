import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './constants.dart';
import './main.dart';

// Define a custom Form widget.
class PersonalDetailsForm extends StatefulWidget {
  const PersonalDetailsForm({super.key});

  @override
  State<PersonalDetailsForm> createState() => _PersonalDetailsFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  TextEditingController? myController ;
  Box hivePersonalDetailsBox = Hive.box(HIVE_BOX_PERSONAL_DETAILS);
  _PersonalDetailsFormState() {
    myController = TextEditingController(text: hivePersonalDetailsBox.get("name"));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: myController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
          ),
        ),
        const SizedBox(height: 30),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  hivePersonalDetailsBox.put('name', myController!.text);
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                      const MyHomePage(title: 'SSA'),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
