import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultLayout extends StatefulWidget {
  final Widget child;
  final AppBar? appBar;
  final Color? backgroundColor;

  const DefaultLayout({
    required this.child,
    this.appBar,
    this.backgroundColor,
    super.key
  });

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? const Color.fromARGB(255, 245, 245, 245),
      appBar: widget.appBar,
      body: widget.child,
    );
  }
}