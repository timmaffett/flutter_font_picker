import 'package:flutter/material.dart';
import 'package:flutter_font_picker/flutter_font_picker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Font Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Font Picker Demo'),
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
  String _selectedFont = 'Roboto';

  late TextStyle? _selectedFontTextStyle = GoogleFonts.getFont(_selectedFont);

  bool _showFontVariants = true;

  bool _showFontInfo = true;

  bool _showListPreviewSampleTextInput = false;

  String _listPreviewSampleText = '';

  double _sampleTextFontSize = 14.0;

  double _fontPickerListFontSize = 16.0;

  double _previewFontSize = 24.0;

  FontListType _fontListType = FontListType.subset;

  late List<String> _myGoogleFonts = _subsetListOfGoogleFonts;

  final List<String> _completeGoogleFonts = GoogleFonts.asMap().keys.toList();

  final List<String> _subsetListOfGoogleFonts = [
    "Abril Fatface",
    "Aclonica",
    "Alegreya Sans",
    "Architects Daughter",
    "Archivo",
    "Archivo Narrow",
    "Bebas Neue",
    "Bitter",
    "Bree Serif",
    "Bungee",
    "Cabin",
    "Cairo",
    "Coda",
    "Comfortaa",
    "Comic Neue",
    "Cousine",
    "Croissant One",
    "Faster One",
    "Forum",
    "Great Vibes",
    "Heebo",
    "Inconsolata",
    "Josefin Slab",
    "Lato",
    "Libre Baskerville",
    "Lobster",
    "Lora",
    "Merriweather",
    "Montserrat",
    "Mukta",
    "Nunito",
    "Offside",
    "Open Sans",
    "Oswald",
    "Overlock",
    "Pacifico",
    "Playfair Display",
    "Poppins",
    "Raleway",
    "Roboto",
    "Roboto Mono",
    "Source Sans Pro",
    "Space Mono",
    "Spicy Rice",
    "Squada One",
    "Sue Ellen Francisco",
    "Trade Winds",
    "Ubuntu",
    "Varela",
    "Vollkorn",
    "Work Sans",
    "Zilla Slab",
  ];

  void _onFontListTypeChange( FontListType? val ) {
    setState(() {
      _fontListType = val ?? FontListType.subset;
      if(_fontListType == FontListType.subset) {
        _myGoogleFonts = _subsetListOfGoogleFonts;
      } else {
        _myGoogleFonts = _completeGoogleFonts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'List of fonts is :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Radio<FontListType>(
                    value: FontListType.subset,
                    groupValue: _fontListType,
                    onChanged: _onFontListTypeChange,
                  ),
                  const Text(
                    'Subset of GoogleFonts',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Radio<FontListType>(
                    value: FontListType.complete,
                    groupValue: _fontListType,
                    onChanged: _onFontListTypeChange,
                  ),
                  const Text(
                    'All GoogleFonts',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Show font variants :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showFontVariants,
                    onChanged: (checked) {
                      setState(() {
                        _showFontVariants = checked ?? false;
                      });
                    },
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'Show font info :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showFontInfo,
                    onChanged: (checked) {
                      setState(() {
                        _showFontInfo = checked ?? false;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded( child: FontSample(
                              onSampleTextChanged: (newSample) {
                                setState(() {
                                  _listPreviewSampleText = newSample;
                                });
                              },
                            ),
                  ),
                  const SizedBox(width: 30),
                  const Text(
                    'Allow editing of list preview sample text :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Checkbox(
                    value: _showListPreviewSampleTextInput,
                    onChanged: (checked) {
                      setState(() {
                        _showListPreviewSampleTextInput = checked ?? false;
                      });
                    },
                  ),
                ],
              ),





              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Font size for sample text :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Slider(
                    min: 10.0,
                    max: 64.0,
                    value: _sampleTextFontSize,
                    onChanged: (value) {
                      setState(() {
                        _sampleTextFontSize = value.round().toDouble();
                      });
                    },
                  ),
                  Text(
                    '${_sampleTextFontSize}px',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Font size for fonts in picker list :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Slider(
                    min: 10.0,
                    max: 64.0,
                    value: _fontPickerListFontSize,
                    onChanged: (value) {
                      setState(() {
                        _fontPickerListFontSize = value.round().toDouble();
                      });
                    },
                  ),
                  Text(
                    '${_fontPickerListFontSize}px',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:Container( height: 2, color: Colors.black ),
              ),
              const Text(
                'Examples of FontPicker() (using above settings):',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                child: const Text('Pick a font (with a screen)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FontPicker(
                        recentsCount: 10,
                        onFontChanged: (font) {
                          setState(() {
                            _selectedFont = font.fontFamily;
                            _selectedFontTextStyle = font.toTextStyle();
                          });
                          debugPrint(
                            "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                          );
                        },
                        googleFonts: _myGoogleFonts,
                        showFontVariants: _showFontVariants,
                        showFontInfo: _showFontInfo,
                        showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                        listPreviewSampleText: _listPreviewSampleText,
                        previewSampleTextFontSize: _sampleTextFontSize,
                        fontSizeForListPreview: _fontPickerListFontSize,

                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height:16),
              ElevatedButton(
                child: const Text('Pick a font (with a dialog)'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: SizedBox(
                            width: double.maxFinite,
                            child: FontPicker(
                              showInDialog: true,
                              initialFontFamily: 'Anton',
                              onFontChanged: (font) {
                                setState(() {
                                  _selectedFont = font.fontFamily;
                                  _selectedFontTextStyle = font.toTextStyle();
                                });
                                debugPrint(
                                  "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                                );
                              },
                              googleFonts: _myGoogleFonts,
                              showFontVariants: _showFontVariants,
                              showFontInfo: _showFontInfo,
                              showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                              listPreviewSampleText: _listPreviewSampleText,
                              previewSampleTextFontSize: _sampleTextFontSize,
                              fontSizeForListPreview: _fontPickerListFontSize,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Pick a font: ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      textAlign: TextAlign.center,
                      style: _selectedFontTextStyle?.copyWith(fontSize:_fontPickerListFontSize),
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                        hintText: _selectedFont,
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FontPicker(
                              onFontChanged: (font) {
                                setState(() {
                                  _selectedFont = font.fontFamily;
                                  _selectedFontTextStyle = font.toTextStyle();
                                });
                                debugPrint(
                                  "${font.fontFamily} with font weight ${font.fontWeight} and font style ${font.fontStyle}. FontSpec: ${font.toFontSpec()}",
                                );
                              },
                              googleFonts: _myGoogleFonts,
                              showFontVariants: _showFontVariants,
                              showFontInfo: _showFontInfo,
                              showListPreviewSampleTextInput: _showListPreviewSampleTextInput,
                              listPreviewSampleText: _listPreviewSampleText,
                              previewSampleTextFontSize: _sampleTextFontSize,
                              fontSizeForListPreview: _fontPickerListFontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child:Container( height: 2, color: Colors.black ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Preview font size :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Slider(
                    min: 10.0,
                    max: 96.0,
                    value: _previewFontSize,
                    onChanged: (value) {
                      setState(() {
                        _previewFontSize = value.round().toDouble();
                      });
                    },
                  ),
                  Text(
                    '${_previewFontSize}px',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ClipRect(
                        clipBehavior: Clip.hardEdge,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          minWidth: 0.0,
                          minHeight: 0.0,
                          maxWidth: double.infinity,
                          maxHeight: double.infinity,   
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Font: $_selectedFont',
                                style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'The quick brown fox jumped',
                                style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'over the lazy dog',
                                style: _selectedFontTextStyle?.copyWith(fontSize:_previewFontSize),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class FontSample extends StatefulWidget {
  final String initialSampleText;
  final ValueChanged<String> onSampleTextChanged;
  const FontSample({super.key, this.initialSampleText = '', required this.onSampleTextChanged});

  @override
  _FontSampleState createState() => _FontSampleState();
}

class _FontSampleState extends State<FontSample> {
  bool _isSampleFocused = false;
  late final TextEditingController sampleController;

  @override
  void initState() {
    super.initState();
    sampleController = TextEditingController(text:widget.initialSampleText);
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          setState(() {
            _isSampleFocused = focus;
          });
        },
        child: TextFormField(
          controller: sampleController,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.list,
            ),
            label:  const Text(
                    'List preview sample text',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
            suffixIcon: _isSampleFocused
                ? IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      sampleController.clear();
                      widget.onSampleTextChanged('');
                    },
                  )
                : null,
            hintText: 'Optional sample text to add to each font preview in list',
            hintStyle: const TextStyle(fontSize: 14.0),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onChanged: widget.onSampleTextChanged,
        ),
      ),
    );
  }
}
