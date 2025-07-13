import 'package:flutter/material.dart';

class Risk extends StatefulWidget {
  const Risk({super.key});

  @override
  State<Risk> createState() => _RiskState();
}

class _RiskState extends State<Risk>
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