import 'package:flutter/material.dart';

class whoistheplayer extends StatefulWidget {
  const whoistheplayer({super.key});

  @override
  State<whoistheplayer> createState() => _whoistheplayerState();
}

class _whoistheplayerState extends State<whoistheplayer>
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