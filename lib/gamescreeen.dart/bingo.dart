import 'package:flutter/material.dart';

class bingo extends StatefulWidget {
  const bingo({super.key});

  @override
  State<bingo> createState() => _bingoState();
}

class _bingoState extends State<bingo>
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