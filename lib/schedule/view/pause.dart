import 'package:flutter/material.dart';
import 'package:tumobile/schedule/model/pause_data.dart';

class Pause extends StatelessWidget {
  final PauseData data;
  const Pause(this.data, {super.key});
  Pause.byBeginandEnd(DateTime begin, DateTime end, {super.key})
      : data = PauseData(begin, end);

  @override
  Widget build(BuildContext context) {
    // double height = data.end.difference(data.begin).inMinutes * 1.15;
    double height = 60 * 1.15;
    // DateTime now = DateTime.parse("20240502 16:30");
    bool currentEvent =
        DateTime.now().isAfter(data.begin) && DateTime.now().isBefore(data.end);
    // bool currentEvent = true;

    const Color almostBlack = Color.fromARGB(190, 0, 0, 0);
    return Card(
      elevation: 0,
      color: currentEvent
          ? const Color.fromARGB(255, 245, 245, 255)
          : const Color.fromARGB(255, 252, 252, 252),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          children: [
            SizedBox(
              height: height - 20,
              width: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    data.begin.toIso8601String().substring(11, 16),
                    style: const TextStyle(color: almostBlack),
                  ),
                  Text(
                    data.end.toIso8601String().substring(11, 16),
                    style: const TextStyle(color: almostBlack),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 0.75,
              height: height - 40,
              child: const ColoredBox(
                color: almostBlack,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "PAUSE!",
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 15, color: almostBlack),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
