import 'package:admin_simpass/globals/main_ui.dart';
import 'package:flutter/material.dart';

class CustomDropDownMenu extends StatelessWidget {
  final List<DropdownMenuEntry> items;
  final double width;
  final dynamic selectedItem;
  final Widget? label;
  final bool enabled;
  final Function(dynamic)? onSelected;
  final bool enableSearch;
  final bool enableFilter;
  final bool requestFocusOnTap;
  final TextEditingController? controller;
  final double menuHeight;
  final String? errorText;

  const CustomDropDownMenu({
    super.key,
    required this.items,
    this.width = 100,
    this.selectedItem,
    this.onSelected,
    this.label,
    this.enabled = true,
    this.controller,
    this.errorText,
    this.enableSearch = false,
    this.requestFocusOnTap = false,
    this.enableFilter = false,
    this.menuHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width + 7,
      menuHeight: menuHeight,
      enableSearch: enableSearch,
      enableFilter: enableFilter,
      errorText: errorText,
      controller: controller,
      requestFocusOnTap: requestFocusOnTap,
      expandedInsets: const EdgeInsets.all(0),
      label: label,
      initialSelection: selectedItem,
      onSelected: onSelected,
      enabled: enabled,
      textStyle: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
      ),
      menuStyle: MenuStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        // backgroundColor: MaterialStateProperty.all(Colors.white),
        // shadowColor: MaterialStateProperty.all(Colors.white),
        surfaceTintColor: MaterialStateProperty.all(Colors.white),
      ),
      dropdownMenuEntries: items,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        constraints: const BoxConstraints(
          minHeight: 40,
        ),
        isDense: true,
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black45,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black87,
          // fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: MainUi.mainColor,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black45,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.black45,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        errorMaxLines: 3,
        errorStyle: const TextStyle(
          color: Colors.red,
          // height: 0.5,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
