import 'dart:html' as html; // Import dart:html for web-specific functionality
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class LegalSearchScreen extends StatefulWidget {
  const LegalSearchScreen({super.key});

  @override
  _LegalSearchScreenState createState() => _LegalSearchScreenState();
}

class _LegalSearchScreenState extends State<LegalSearchScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _query;
  String? _option;
  List<html.File>? _files; // Change to html.File for web compatibility
  bool _loading = false;
  String _response = '';

  Future<void> _submitQuery() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _response = '';
      });
      _formKey.currentState!.save();

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://navilaw-ai.onrender.com/legal-assistance/'),
        );
        request.fields['query'] = _query!;
        request.fields['option'] = _option!;

        if (_files != null) {
          for (var file in _files!) {
            // Read the file as bytes using FileReader
            final reader = html.FileReader();
            reader.readAsArrayBuffer(file); // Read file as ArrayBuffer
            await reader.onLoad.first; // Wait until the file is loaded

            final bytes = reader.result as Uint8List; // Get the byte data
            request.files.add(http.MultipartFile.fromBytes(
              'files',
              bytes,
              filename: file.name,
              contentType: MediaType('application', 'pdf'),
            ));
          }
        }

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          setState(() {
            _response = json.decode(responseBody)['result'] ??
                json.decode(responseBody)['report'] ??
                json.decode(responseBody)['prediction'] ??
                'Response received';
          });
        } else {
          setState(() {
            _response = json.decode(responseBody)['detail'] ?? 'An error occurred';
          });
        }
      } catch (e) {
        print('Error: $e'); // Print the error details to the console
        setState(() {
          _response = 'Failed to connect to the server. Error: $e'; // Update the error message
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _pickFiles() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        // Convert the picked files to html.File for web compatibility
        _files = result.files.map((file) {
          return html.File(
            file.bytes!.cast<int>(),
            file.name,
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            ResponsiveVisibility(
              visible: false,
              visibleConditions: const [
                Condition.largerThan(name: MOBILE),
              ],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LawNavigator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Get started'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Search engine fields
            Text(
              'ASK.',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'SEARCH.',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'GENERATE.',
              style: TextStyle(
                fontSize: ResponsiveBreakpoints.of(context).largerThan(MOBILE) ? 48 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter your legal query',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a query';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _query = value;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select legal option',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    items: [
                      'Legal Advisory',
                      'Legal Report Generation',
                      'Case Outcome Prediction'
                    ].map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _option = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a legal option';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFiles,
                    child: Text(
                      _files != null && _files!.isNotEmpty
                          ? 'Files Selected (${_files!.length})'
                          : 'Upload PDF files',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _loading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : ElevatedButton(
                          onPressed: _submitQuery,
                          child: const Text('Submit'),
                        ),
                  const SizedBox(height: 20),
                  if (_response.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _response,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
