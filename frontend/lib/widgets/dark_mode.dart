import 'package:flutter/material.dart';

class ThemeController extends StatefulWidget {
  final Widget child;

  const ThemeController({super.key, required this.child});

  static _ThemeControllerInherited of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_ThemeControllerInherited>();
    if (inherited == null) {
      throw FlutterError('ThemeController not found in context');
    }
    return inherited;
  }

  @override
  State<ThemeController> createState() => _ThemeControllerState();
}

class _ThemeControllerState extends State<ThemeController> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ThemeControllerInherited(
      themeMode: _themeMode,
      toggleTheme: toggleTheme,
      child: widget.child,
    );
  }
}

class _ThemeControllerInherited extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;

  const _ThemeControllerInherited({
    required this.themeMode,
    required this.toggleTheme,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_ThemeControllerInherited oldWidget) {
    return oldWidget.themeMode != themeMode;
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
}
