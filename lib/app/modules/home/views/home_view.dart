import 'package:echo_flutter/app/constants/colour_constant.dart';
import 'package:echo_flutter/app/modules/home/views/widgets/mic_widget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'ECHO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(child: Center(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MicWidget(),
      ))),
    );
  }
}
