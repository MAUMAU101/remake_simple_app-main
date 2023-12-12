import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _recoveryEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  int _selectedMonth = 1; // January (index 1)
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _recoveryEmailController,
                decoration: const InputDecoration(labelText: 'Recovery Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Birthdate:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _selectedDate.day,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedDate =
                              DateTime(_selectedYear, _selectedMonth, value);
                        });
                      }
                    },
                    items: List.generate(31, (index) => index + 1)
                        .map((day) => DropdownMenuItem<int>(
                              value: day,
                              child: Text(day.toString()),
                            ))
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _selectedMonth,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedMonth = value;
                          _selectedDate = DateTime(
                              _selectedYear, _selectedMonth, _selectedDate.day);
                        });
                      }
                    },
                    items: List.generate(12, (index) => index + 1)
                        .map((month) => DropdownMenuItem<int>(
                              value: month,
                              child: Text(month.toString()),
                            ))
                        .toList(),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _selectedYear,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedYear = value;
                          _selectedDate = DateTime(
                              _selectedYear, _selectedMonth, _selectedDate.day);
                        });
                      }
                    },
                    items: List.generate(
                            100, (index) => DateTime.now().year - index)
                        .map((year) => DropdownMenuItem<int>(
                              value: year,
                              child: Text(year.toString()),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveRegistration,
                child: const Text('Save Registration'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Back',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  void _saveRegistration() {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      _showErrorSnackBar('Name and email are required.');
      return;
    }

    final Map<String, dynamic> registrationData = {
      'name': name,
      'email': email,
      'dob': _selectedDate.toIso8601String(),
    };

    final Directory documentsDirectory = Directory.current;
    final String filePath = '${documentsDirectory.path}/lib/registration.json';

    try {
      if (!documentsDirectory.existsSync()) {
        documentsDirectory.createSync(recursive: true);
      }

      final File registrationFile = File(filePath);
      registrationFile.writeAsStringSync(jsonEncode(registrationData));

      _showSuccessSnackBar('Registration data saved successfully!');
    } catch (error) {
      _showErrorSnackBar('Failed to save registration data. Error: $error');
    }

    Navigator.pop(context);
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(255, 137, 68, 162),
      ),
    );
  }
}
