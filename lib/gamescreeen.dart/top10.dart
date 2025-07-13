import 'package:flutter/material.dart';

class top10 extends StatefulWidget {
  const top10({super.key});

  @override
  State<top10> createState() => _top10State();
}

class _top10State extends State<top10>
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