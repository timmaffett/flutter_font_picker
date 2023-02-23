To generate new `lib\src\constants.dart` file containing information for the latest generation of google fonts go to [https://developers.google.com/fonts/docs/developer_api](https://developers.google.com/fonts/docs/developer_api) and click the blue 'EXECUTE' button on the right and then copy the JSON output that appears and create a file in this directory and paste this JSON here and save the file.

The execute the generator dart file giving it the filename of the json file that was just saved.

The google_fonts version specified in the root pubspec.yaml file will be used to determine the list of fonts that will be output to the new `lib\src\constants.dart` file.

