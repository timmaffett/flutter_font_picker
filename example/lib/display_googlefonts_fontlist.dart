import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:google_fonts/google_fonts.dart';

import 'package:device_preview/device_preview.dart'; // required when useDevicePreview==true

/// Set [useDevicePreview] to allow testing layouts on virtual device screens
const useDevicePreview = false;

void main() {
  if(useDevicePreview) {
    //TEST various on various device screens//
    runApp(DevicePreview(
            builder: (context) => const MyApp(), // Wrap your app
            enabled: true,
          ));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Display List Of Fonts in PubSpec version of GoogleFonts package',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Display List Of Fonts in PubSpec version of GoogleFonts package'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum FontListType { subset, complete }
class _MyHomePageState extends State<MyHomePage> {
  final List<String> _completeGoogleFonts = GoogleFonts.asMap().keys.toList();

  late final String _textOfGoogleFontsList;

  @override
  initState() {
    super.initState();
    _textOfGoogleFontsList = _completeGoogleFonts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Current GoogleFonts Package Font List')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView( child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SelectableText
            SelectableText(
              _textOfGoogleFontsList,
              style: TextStyle(fontSize: 10),
            ),
            const SizedBox(
              height: 30,
            ),
            const TextField(
              minLines: 3,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '''Above is a list of all fonts included in pubspec.yaml version of the GoogleFonts package.
Select All on the list of fonts above and copy to new file in /generator directory
and execute the update_constants.dart program.  See /generator/readme.md for more info.
''',
              ),
            ),
          ],),
        ),
      ),
    );
  }
}