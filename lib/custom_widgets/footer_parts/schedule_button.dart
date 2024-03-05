import 'package:flutter/material.dart';

class ScheduleButton extends StatelessWidget {
  const ScheduleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: ColoredBox(
                color: const Color.fromRGBO(98, 98, 186, 1.0),
                child: SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Expanded(
                      child: Icon(
                        size: 40.0,
                        Icons.calendar_month,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
