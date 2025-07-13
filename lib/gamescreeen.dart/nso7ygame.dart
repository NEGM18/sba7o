import 'package:flutter/material.dart';

class nso7ygame extends StatefulWidget {
  const nso7ygame({super.key});

  @override
  State<nso7ygame> createState() => _nso7ygameState();
}

class _nso7ygameState extends State<nso7ygame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}