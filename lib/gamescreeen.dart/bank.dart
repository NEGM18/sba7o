import 'package:flutter/material.dart';

class bank extends StatefulWidget {
  const bank({super.key});

  @override
  State<bank> createState() => _bankState();
}

class _bankState extends State<bank>
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
    return const Scaffold();
  }
}