import 'package:flutter/material.dart';

class whoisinimage extends StatefulWidget {
  const whoisinimage({super.key});

  @override
  State<whoisinimage> createState() => _whoisinimageState();
}

class _whoisinimageState extends State<whoisinimage>
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