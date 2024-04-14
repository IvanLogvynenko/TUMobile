import 'package:flutter/material.dart';

class ArrowsBar extends StatelessWidget {
  final Widget? child;
  const ArrowsBar({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 60.0,
            width: MediaQuery.of(context).size.width / 2,
            child: ColoredBox(
              color: const Color.fromRGBO(167, 161, 232, 1.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        size: 40.0,
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: child!,
                  ),
                  Expanded(
                    flex: 3,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        size: 40.0,
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
