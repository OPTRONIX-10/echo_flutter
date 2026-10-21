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
      body: SafeArea(child: MicWidget()),
    );
  }
}
