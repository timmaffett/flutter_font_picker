import 'package:flutter/material.dart';



class SplitOn<T> {
  Type get genericType => T;
}

enum SplitWidgetBehavior {
  exclude,
  includeInThisRow,
  includeInNextRow,
}

class Splittable {
  static int splitWidth = 400;

  static bool willSplitRows(BuildContext context) {
    Size size = MediaQuery.of(context).size;                            
    return size.width<=splitWidth;
  }

  /// [splitAtIndices] supply an array of the index numbers of split widgets
  /// [splitEveryN] supply if you want to split on every Nth widget.
  /// [splitWidgetBehavior] what to do with the split widget SplitWidgetBehavior.(exclude, includeInThisRow or includeInNextRow)
  /// [splitOn] SplitOn instance which holds type of widget to split on, ie. SplitOn<SizedBox>
  static List<Widget> splittableRow( { 
                          required BuildContext context,
                          required List<Widget>children,
                          SplitOn? splitOn,
                          int? splitEveryN,
                          List<int>? splitAtIndices,
                          SplitWidgetBehavior splitWidgetBehavior = SplitWidgetBehavior.exclude,
                          Key? key,
                          MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
                          MainAxisSize mainAxisSize = MainAxisSize.max,
                          CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
                          TextDirection? textDirection,
                          VerticalDirection verticalDirection = VerticalDirection.down,
                          TextBaseline? textBaseline,
                        } ) {
    assert( splitOn!=null || splitEveryN!=null || splitAtIndices!=null, 'Must supply either splitOn<T>, splitEveryN or splitAtIndices');
    bool splitting = willSplitRows(context);

    // if now splitting the row then just return a Row() widget with all these children
    if(!splitting) {
      return [ Row( mainAxisAlignment:mainAxisAlignment,
                                    mainAxisSize:mainAxisSize,crossAxisAlignment:crossAxisAlignment,
                                    textDirection:textDirection,verticalDirection:verticalDirection,
                                    textBaseline:textBaseline,
                                    children: children,
                    ),
              ];
    }
    List<Widget> curRowWidgets = [];
    List<Widget> splitRows = [];
    for(int i=0;i<children.length;i++) {
      final item = children[i];
      if( (splitOn!=null && item.runtimeType==splitOn.genericType) ||
            (splitEveryN!=null && (i+1)%splitEveryN==0) ||
            (splitAtIndices!=null && splitAtIndices.contains(i)) ) {
        // splitting here
        if(splitWidgetBehavior==SplitWidgetBehavior.includeInThisRow) curRowWidgets.add(item);
        splitRows.add( Row( mainAxisAlignment:mainAxisAlignment,
                                    mainAxisSize:mainAxisSize,crossAxisAlignment:crossAxisAlignment,
                                    textDirection:textDirection,verticalDirection:verticalDirection,
                                    textBaseline:textBaseline,
                                    children: [ ...curRowWidgets ],
                    ) );
        curRowWidgets.clear();
        if(splitWidgetBehavior==SplitWidgetBehavior.includeInNextRow) curRowWidgets.add(item);
      } else {
        curRowWidgets.add(item);
      }
    }
    if(curRowWidgets.isNotEmpty) {
      splitRows.add( Row( mainAxisAlignment:mainAxisAlignment,
                                    mainAxisSize:mainAxisSize,crossAxisAlignment:crossAxisAlignment,
                                    textDirection:textDirection,verticalDirection:verticalDirection,
                                    textBaseline:textBaseline,
                                    children: [ ...curRowWidgets ],
                    ) );
    }
    return splitRows;
  }
}