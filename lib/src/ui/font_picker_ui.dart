library flutter_font_picker;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../constants/fontweights_map.dart';
import '../constants/translations.dart';
import '../models/picker_font.dart';
import 'font_categories.dart';
import 'font_language.dart';
import 'font_preview.dart';
import 'font_sample.dart';
import 'font_search.dart';

class FontPickerUI extends StatefulWidget {
  final List<String> googleFonts;
  final ValueChanged<PickerFont> onFontChanged;
  String initialFontFamily;
  final bool showFontInfo;
  final bool showInDialog;
  final int recentsCount;
  final String lang;
  final bool showFontVariants;
  final bool showListPreviewSampleTextInput;
  final String? listPreviewSampleText;
  final double fontSizeForListPreview;
  final double previewSampleTextFontSize;

  FontPickerUI({
    super.key,
    this.googleFonts = googleFontsList,
    this.showFontInfo = true,
    this.showInDialog = false,
    this.recentsCount = 3,
    required this.onFontChanged,
    required this.initialFontFamily,
    required this.lang,
    this.showFontVariants = true,
    this.showListPreviewSampleTextInput = false,
    this.listPreviewSampleText,
    this.fontSizeForListPreview = 16.0,
    this.previewSampleTextFontSize = 14.0,
  });

  @override
  _FontPickerUIState createState() => _FontPickerUIState();
}

class _FontPickerUIState extends State<FontPickerUI> {

  _FontPickerUIState();

  var _shownFonts = <PickerFont>[];
  var _allFonts = <PickerFont>[];
  var _recentFonts = <PickerFont>[];
  String? _selectedFontFamily;
  FontWeight _selectedFontWeight = FontWeight.w400;
  FontStyle _selectedFontStyle = FontStyle.normal;
  String _selectedFontLanguage = 'all';
  String? listPreviewSampleText;

  @override
  void initState() {
    _prepareShownFonts();
    super.initState();
    if(widget.listPreviewSampleText!=null) listPreviewSampleText = widget.listPreviewSampleText;
  }

  Future _prepareShownFonts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(prefsRecentsKey) ?? [];
    final supportedFonts = GoogleFonts.asMap()
        .keys
        .where((e) => widget.googleFonts.contains(e))
        .toList();
    setState(() {
      _recentFonts = recents.reversed
          .map((fontFamily) =>
              PickerFont(fontFamily: fontFamily, isRecent: true))
          .toList();
      _allFonts = _recentFonts +
          supportedFonts
              .where((fontFamily) => !recents.contains(fontFamily))
              .map((fontFamily) => PickerFont(fontFamily: fontFamily))
              .toList();
      _shownFonts = List.from(_allFonts);
      if (!supportedFonts.contains(widget.initialFontFamily)) {
        widget.initialFontFamily = 'Roboto';
      }
      _selectedFontFamily = widget.initialFontFamily;
    });
  }

  void changeFont(PickerFont selectedFont) {
    setState(() {
      widget.onFontChanged(selectedFont);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 5 / 6,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: widget.showInDialog
                ? ListView(
                    shrinkWrap: true,
                    children: [
                      FontSearch(
                        onSearchTextChanged: onSearchTextChanged,
                      ),
                      FontLanguage(
                        onFontLanguageSelected: onFontLanguageSelected,
                        selectedFontLanguage: _selectedFontLanguage,
                      ),
                      const SizedBox(height: 12.0),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: FontSearch(
                          onSearchTextChanged: onSearchTextChanged,
                        ),
                      ),
                      Expanded(
                        child: FontLanguage(
                          onFontLanguageSelected: onFontLanguageSelected,
                          selectedFontLanguage: _selectedFontLanguage,
                        ),
                      ),
                    ],
                  ),
          ),
          FontCategories(onFontCategoriesUpdated: onFontCategoriesUpdated),
          if(widget.showListPreviewSampleTextInput)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              child: FontSample(
                initialSampleText: listPreviewSampleText ?? widget.listPreviewSampleText ?? '',
                onSampleTextChanged: onSampleTextChanged,
              ),
          ),
          FontPreview(
            fontFamily: _selectedFontFamily ?? 'Roboto',
            fontWeight: _selectedFontWeight,
            fontStyle: _selectedFontStyle,
            fontSize: widget.previewSampleTextFontSize,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _shownFonts.length,
              itemBuilder: (context, index) {
                PickerFont f = _shownFonts[index];
                bool isBeingSelected = _selectedFontFamily == f.fontFamily;
                String category = translations.d[f.category]!;
                String stylesString = "";
                if (widget.showFontInfo) {
                  stylesString += "  $category";
                  if (widget.showFontVariants) {
                    stylesString +=
                        ", ${f.variants.length} ${translations.d['styles']}";
                  }
                }

                return ListTile(
                  selected: isBeingSelected,
                  selectedTileColor: Theme.of(context).focusColor,
                  onTap: () {
                    setState(() {
                      if (!isBeingSelected) {
                        _selectedFontFamily = f.fontFamily;
                        _selectedFontWeight = FontWeight.w400;
                        _selectedFontStyle = FontStyle.normal;
                      } else {
                        _selectedFontFamily = null;
                      }
                    });
                  },
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RichText(
                      text: TextSpan(
                        text: f.fontFamily,
                        style: TextStyle(
                          fontFamily:
                              GoogleFonts.getFont(f.fontFamily).fontFamily,
                          fontSize: widget.fontSizeForListPreview,
                        ).copyWith(
                          color: DefaultTextStyle.of(context).style.color,
                        ),
                        children: [
                          TextSpan(
                            text: stylesString,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 11.0,
                              color: Colors.grey,
                              fontFamily:
                                  DefaultTextStyle.of(context).style.fontFamily,
                            ),
                          ),
                          // add a space between texts
                       /*   WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                            ),
                          ),
                          TextSpan(
                            text: 'ABC 1234567890:/',
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.getFont(f.fontFamily).fontFamily,
                                fontSize: widget.fontSizeForListPreview,
                            ).copyWith(
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                          )
                        */
                        ],
                      ),
                    ),
                  ),
                  subtitle: isBeingSelected && widget.showFontVariants
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Wrap(
                            children: f.variants.map((variant) {
                              bool isSelectedVariant;
                              isSelectedVariant = variant == "italic" &&
                                      _selectedFontStyle == FontStyle.italic
                                  ? true
                                  : _selectedFontWeight
                                      .toString()
                                      .contains(variant);

                              return SizedBox(
                                height: 30.0,
                                width: 60.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: isSelectedVariant
                                          ? Theme.of(context).primaryColor
                                          : null,
                                      textStyle: const TextStyle(
                                        fontSize: 10.0,
                                      ),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      variant,
                                      style: TextStyle(
                                        fontStyle: variant == "italic"
                                            ? FontStyle.italic
                                            : FontStyle.normal,
                                        color: isSelectedVariant
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                            : Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary ==
                                                    Colors.white
                                                ? null
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (variant == "italic") {
                                          _selectedFontStyle == FontStyle.italic
                                              ? _selectedFontStyle =
                                                  FontStyle.normal
                                              : _selectedFontStyle =
                                                  FontStyle.italic;
                                        } else {
                                          _selectedFontWeight =
                                              fontWeightValues[variant]!;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : null,
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      listPreviewSampleText!=null && !isBeingSelected 
                      ? ConstrainedBox( 
                          constraints: BoxConstraints(maxWidth: size.width/3),
                          child:Text(
                            listPreviewSampleText!,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontFamily:
                                    GoogleFonts.getFont(f.fontFamily).fontFamily,
                                fontSize: widget.fontSizeForListPreview,
                            ).copyWith(
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                          ), 
                        )
                        : Container(),
                      isBeingSelected
                      ? TextButton(
                          child: Text(
                            translations.d["select"]!,
                          ),
                          onPressed: () {
                            addToRecents(_selectedFontFamily!);
                            changeFont(
                              PickerFont(
                                fontFamily: _selectedFontFamily!,
                                fontWeight: _selectedFontWeight,
                                fontStyle: _selectedFontStyle,
                              ),
                            );
                            Navigator.of(context).pop();
                          },
                        )
                      : _recentFonts.contains(f)
                          ? const SizedBox(width: 40, child: Icon(
                                Icons.history,
                                size: 18.0,
                              ),
                            )
                          : const SizedBox(width: 40),
                      ],
                    ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addToRecents(String fontFamily) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var recents = prefs.getStringList(prefsRecentsKey);
    if (recents != null && !recents.contains(fontFamily)) {
      if (recents.length == widget.recentsCount) {
        recents = recents.sublist(1)..add(fontFamily);
      } else {
        recents.add(fontFamily);
      }
      prefs.setStringList(prefsRecentsKey, recents);
    } else {
      prefs.setStringList(prefsRecentsKey, [fontFamily]);
    }
  }

  void onFontLanguageSelected(String? newValue) {
    setState(() {
      _selectedFontLanguage = newValue!;
      _shownFonts = newValue == 'all'
          ? _allFonts
          : _allFonts.where((f) => f.subsets.contains(newValue)).toList();
    });
  }

  void onFontCategoriesUpdated(List<String> selectedFontCategories) {
    setState(() {
      _shownFonts = _allFonts
          .where((f) => selectedFontCategories.contains(f.category))
          .toList();
    });
  }

  void onSearchTextChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _shownFonts = _allFonts;
      });

      return;
    } else {
      setState(() {
        _shownFonts = _allFonts
            .where(
              (f) => f.fontFamily.toLowerCase().contains(
                    text.toLowerCase(),
                  ),
            )
            .toList();
      });
    }
  }

  void onSampleTextChanged(String sampleText) {
      setState(() {
        listPreviewSampleText = sampleText;
      });
  }
}
