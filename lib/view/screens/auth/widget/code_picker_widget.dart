import 'package:collection/collection.dart' show IterableExtension;

import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:universal_platform/universal_platform.dart';

class CodePickerWidget extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;
  final ValueChanged<CountryCode> onInit;
  final String? initialSelection;
  final List<String?> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle dialogTextStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(CountryCode) builder;
  final bool enabled;
  final TextOverflow textOverflow;
  final Icon closeIcon;

  /// Barrier color of ModalBottomSheet
  final Color barrierColor;

  /// Background color of ModalBottomSheet
  final Color backgroundColor;

  /// BoxDecoration for dialog
  final BoxDecoration boxDecoration;

  /// the size of the selection dialog
  final Size dialogSize;

  /// Background color of selection dialog
  final Color dialogBackgroundColor;

  /// used to customize the country list
  final List<String?> countryFilter;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially useful in combination with [showOnlyCountryWhenClosed],
  /// because longer country names are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  final bool hideMainText;

  final bool showFlagMain;

  final bool showFlagDialog;

  /// Width of the flag images
  final double? flagWidth;

  /// Use this property to change the order of the options
  final Comparator<CountryCode> comparator;

  /// Set to true if you want to hide the search part
  final bool hideSearch;

  /// Set to true if you want to show drop down button
  final bool showDropDownButton;

  /// [BoxDecoration] for the flag image
  final Decoration flagDecoration;

  /// An optional argument for injecting a list of countries
  /// with customized codes.
  final List<Map<String, String>> countryList;

  CodePickerWidget({
    required this.onChanged,
    required this.onInit,
    this.initialSelection,
    this.favorite = const [],
    required this.textStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    required this.searchStyle,
    required this.dialogTextStyle,
    required this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    required this.showFlagDialog,
    this.hideMainText = false,
    required this.showFlagMain,
    required this.flagDecoration,
    required this.builder,
    this.flagWidth = 32.0,
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    required this.barrierColor,
    required this.backgroundColor,
    required this.boxDecoration,
    required this.comparator,
    required this.countryFilter,
    this.hideSearch = false,
    this.showDropDownButton = false,
    required this.dialogSize,
    required this.dialogBackgroundColor,
    this.closeIcon = const Icon(Icons.close),
    this.countryList = codes,
  });

  @override
  State<StatefulWidget> createState() {
    List<Map<String, String>> jsonList = countryList;

    List<CountryCode> elements =
        jsonList.map((json) => CountryCode.fromJson(json)).toList();

    elements.sort(comparator);

    if (countryFilter.isNotEmpty) {
      final uppercaseCustomList =
          countryFilter.map((c) => c!.toUpperCase()).toList();
      elements = elements
          .where((c) =>
              uppercaseCustomList.contains(c.code) ||
              uppercaseCustomList.contains(c.name) ||
              uppercaseCustomList.contains(c.dialCode))
          .toList();
    }

    return CodePickerWidgetState(elements);
  }
}

class CodePickerWidgetState extends State<CodePickerWidget> {
  late CountryCode selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];

  CodePickerWidgetState(this.elements);

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    _widget = InkWell(
      onTap: showCountryCodePickerDialog,
      child: widget.builder(selectedItem),
    );
    return _widget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    this.elements = elements.map((e) => e.localize(context)).toList();
    _onInit(selectedItem);
  }

  @override
  void didUpdateWidget(CodePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code!.toUpperCase() == widget.initialSelection!.toUpperCase()) ||
              (e.dialCode == widget.initialSelection) ||
              (e.name!.toUpperCase() == widget.initialSelection!.toUpperCase()),
          orElse: () => elements[0]);
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();

    selectedItem = elements.firstWhere(
        (e) =>
            (e.code!.toUpperCase() == widget.initialSelection!.toUpperCase()) ||
            (e.dialCode == widget.initialSelection) ||
            (e.name!.toUpperCase() == widget.initialSelection!.toUpperCase()),
        orElse: () => elements[0]);

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhereOrNull((f) =>
                e.code!.toUpperCase() == f!.toUpperCase() ||
                e.dialCode == f ||
                e.name!.toUpperCase() == f.toUpperCase()) !=
            null)
        .toList();
  }

  void showCountryCodePickerDialog() {
    if (!UniversalPlatform.isAndroid && !UniversalPlatform.isIOS) {
      showDialog(
        barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
        // backgroundColor: widget.backgroundColor ?? Colors.transparent,
        context: context,
        builder: (context) => Center(
          child: Container(
            constraints: BoxConstraints(maxHeight: 500, maxWidth: 400),
            child: Dialog(
              child: SelectionDialog(
                elements,
                favoriteElements,
                showCountryOnly: widget.showCountryOnly,
                emptySearchBuilder: widget.emptySearchBuilder,
                searchDecoration: widget.searchDecoration,
                searchStyle: widget.searchStyle,
                textStyle: widget.dialogTextStyle,
                boxDecoration: widget.boxDecoration,
                showFlag: widget.showFlagDialog != null
                    ? widget.showFlagDialog
                    : widget.showFlag,
                flagWidth: widget.flagWidth!,
                size: widget.dialogSize,
                backgroundColor: widget.dialogBackgroundColor,
                barrierColor: widget.barrierColor,
                hideSearch: widget.hideSearch,
                closeIcon: widget.closeIcon,
                flagDecoration: widget.flagDecoration,
              ),
            ),
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
    } else {
      showMaterialModalBottomSheet(
        barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        context: context,
        builder: (context) => Center(
          child: SelectionDialog(
            elements,
            favoriteElements,
            showCountryOnly: widget.showCountryOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            textStyle: widget.dialogTextStyle,
            boxDecoration: widget.boxDecoration,
            showFlag: widget.showFlagDialog != null
                ? widget.showFlagDialog
                : widget.showFlag,
            flagWidth: widget.flagWidth!,
            flagDecoration: widget.flagDecoration,
            size: widget.dialogSize,
            backgroundColor: widget.dialogBackgroundColor,
            barrierColor: widget.barrierColor,
            hideSearch: widget.hideSearch,
            closeIcon: widget.closeIcon,
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
    }
  }

  void _publishSelection(CountryCode e) {
    widget.onChanged(e);
  }

  void _onInit(CountryCode e) {
    widget.onInit(e);
  }
}
