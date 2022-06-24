import 'package:flutter/material.dart';

class ToggleOption {
  final Widget view;
  final bool state;
  final VoidCallback onSelected;

  ToggleOption({required this.view, required this.state, required this.onSelected});

  ToggleOption copyWith({
    Widget? view,
    bool? state,
    VoidCallback? onSelected,
  }) {
    return ToggleOption(
      view: view ?? this.view,
      state: state ?? this.state,
      onSelected: onSelected ?? this.onSelected,
    );
  }
}
