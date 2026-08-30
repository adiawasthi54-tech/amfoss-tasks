import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Astro Pandit';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _outputController = TextEditingController(
    text: "N/A",
  );
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://i.pinimg.com/originals/82/6e/37/826e370bffeda0218193d06ab651ab61.gif',
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: _usernameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Name';
                }

                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your Name',
              ),
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: _dateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Date of birth';
                }

                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Date of Birth',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    List<String> result = _dateController.text.split('/');
                    String sunshine = "I don't know your horoscope";
                    int date = int.parse(result[0]);
                    int month = int.parse(result[1]);
                    if (date >= 22 && date <= 31 && month == 12) {
                      sunshine = "Capricon";
                    }
                    if (date >= 1 && date <= 19 && month == 1) {
                      sunshine = "Capricon";
                    }
                    if (date >= 20 && date <= 31 && month == 1) {
                      sunshine = "Aquarius";
                    }
                    if (date >= 1 && date <= 18 && month == 2) {
                      sunshine = "Aquarius";
                    }
                    if (date >= 19 && date <= 29 && month == 2) {
                      sunshine = "Pisces";
                    }
                    if (date >= 1 && date <= 20 && month == 3) {
                      sunshine = "Pisces";
                    }
                    if (date >= 21 && date <= 31 && month == 3) {
                      sunshine = "Aries";
                    }
                    if (date >= 1 && date <= 19 && month == 4) {
                      sunshine = "Aries";
                    }
                    if (date >= 20 && date <= 30 && month == 4) {
                      sunshine = "Taurus";
                    }
                    if (date >= 1 && date <= 20 && month == 5) {
                      sunshine = "Taurus";
                    }
                    if (date >= 21 && date <= 31 && month == 5) {
                      sunshine = "Gemini";
                    }
                    if (date >= 1 && date <= 20 && month == 6) {
                      sunshine = "Gemini";
                    }
                    if (date >= 21 && date <= 30 && month == 6) {
                      sunshine = "Cancer";
                    }
                    if (date >= 1 && date <= 22 && month == 7) {
                      sunshine = "Cancer";
                    }
                    if (date >= 23 && date <= 31 && month == 7) {
                      sunshine = "Leo";
                    }
                    if (date >= 1 && date <= 22 && month == 8) {
                      sunshine = "Leo";
                    }
                    if (date >= 23 && date <= 31 && month == 8) {
                      sunshine = "Virgo";
                    }
                    if (date >= 1 && date <= 22 && month == 9) {
                      sunshine = "Virgo";
                    }
                    if (date >= 23 && date <= 30 && month == 9) {
                      sunshine = "Libra";
                    }
                    if (date >= 1 && date <= 22 && month == 10) {
                      sunshine = "Libra";
                    }
                    if (date >= 23 && date <= 31 && month == 10) {
                      sunshine = "Scorpio";
                    }
                    if (date >= 1 && date <= 21 && month == 11) {
                      sunshine = "Scorpio";
                    }
                    if (date >= 22 && date <= 30 && month == 11) {
                      sunshine = "Sagittarius";
                    }
                    if (date >= 1 && date <= 21 && month == 12) {
                      sunshine = "Sagittarius";
                    }

                    setState(() {
                      _outputController.text = sunshine;
                    });
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            TextField(
              readOnly: true, // Prevents editing
              controller: _outputController,
              keyboardType: TextInputType.multiline,
              minLines: 4,
              maxLines: null,
              decoration: InputDecoration(
                labelText: "Your Star",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
