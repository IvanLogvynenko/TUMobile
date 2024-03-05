import 'package:flutter/material.dart';

class MainBar extends StatelessWidget {
  const MainBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 75.0,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(26)),
            child: SizedBox(
              height: 50.0,
              child: ColoredBox(
                color: const Color.fromRGBO(206, 202, 255, 1.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.home,
                          size: 35.0,
                          color: Color.fromRGBO(39, 64, 96, 1),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 4,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.star,
                          size: 35.0,
                          color: Color.fromRGBO(39, 64, 96, 1),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
