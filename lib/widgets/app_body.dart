import 'package:flutter/material.dart';
import 'package:tumobile/custom_widgets/footer_parts/arrows_bar.dart';
import 'package:tumobile/custom_widgets/footer_parts/main_bar.dart';
import 'package:tumobile/custom_widgets/footer_parts/schedule_button.dart';
import 'package:tumobile/custom_widgets/schedule.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Schedule()
      ],
    );
  }
}
