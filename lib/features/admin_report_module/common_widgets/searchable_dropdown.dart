import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CommonSearchableDropdown<T> extends StatelessWidget {
  final FutureOr<List<T>> Function(String, LoadProps?) items;
  final String hintText;
  final T? selectedItem;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final bool Function(T, String)? filterFn;
  final bool Function(T, T)? compareFn;
  final Future<bool?> Function(T?, T?)? onBeforeChange;
  final Future<bool?> Function(T?)? onBeforePopupOpening;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final DropDownDecoratorProps? decoratorProps;
  final PopupProps<T>? popupProps;
  final bool enabled;
  final AutovalidateMode? autoValidateMode;

  const CommonSearchableDropdown({
    super.key,
    required this.items,
    this.hintText = "Select an item",
    this.selectedItem,
    this.onChanged,
    this.itemAsString,
    this.filterFn,
    this.compareFn,
    this.onBeforeChange,
    this.onBeforePopupOpening,
    this.onSaved,
    this.validator,
    this.dropdownBuilder,
    this.decoratorProps,
    this.popupProps,
    this.enabled = true,
    this.autoValidateMode = AutovalidateMode.disabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownSearch<T>(
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
      itemAsString: itemAsString,
      filterFn: filterFn,
      compareFn: compareFn,
      onBeforeChange: onBeforeChange,
      onBeforePopupOpening: onBeforePopupOpening,
      onSaved: onSaved,
      validator: validator,
      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem != null ? (itemAsString?.call(selectedItem) ?? selectedItem.toString()) : '',
          style: const TextStyle(fontSize: 12), // ✅ Closed box text
        );
      },
      popupProps: popupProps ??
          PopupProps.menu(
            showSearchBox: true,
            showSelectedItems: false,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
            ),

            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search...",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
                hintStyle: const TextStyle(fontSize: 12), // ✅ Search hint text
              ),
              style: const TextStyle(fontSize: 12), // ✅ Search input text
            ),
          ),
      enabled: enabled,
      autoValidateMode: autoValidateMode,
      decoratorProps: decoratorProps ??
          DropDownDecoratorProps(
            decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600), // ✅ Hint text
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              ),
            ),
          ),
    );
  }
}
