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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'ECHO',
          style: TextStyle(
            color: secondaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: neutralColor,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: controller.isLoading.value
                ? CircularProgressIndicator(color: secondaryColor)
                : MicWidget(),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: TextField(
          controller: controller.textController,
          readOnly: true,
          maxLines: 5,
          style: const TextStyle(
            color: secondaryColor,
            overflow: TextOverflow.ellipsis,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {
                controller.textController.clear();
              },
              icon: Icon(Icons.clear),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(40),
            ),
            hintText: 'Record or Type your message...',
            hintStyle: TextStyle(color: neutralColor),
            filled: true,
            fillColor: neutralColor,
          ),
        ),
      ),
    );
  }
}
