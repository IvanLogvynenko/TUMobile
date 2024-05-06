import 'package:flutter/material.dart';
import 'package:tumobile/schedule/model/appointment_data.dart';

class Appointment extends StatelessWidget {
  final AppointmentData data;

  const Appointment(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    double height = data.end.difference(data.begin).inMinutes * 1.15;
    // DateTime now = DateTime.parse("20240502 16:30");
    bool currentEvent =
        DateTime.now().isAfter(data.begin) && DateTime.now().isBefore(data.end);
    // bool currentEvent = true;
    return Card(
      color: currentEvent
          ? const Color.fromARGB(255, 225, 225, 255)
          : Theme.of(context).cardColor,
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
                  Text(data.begin.toIso8601String().substring(11, 16)),
                  Text(data.end.toIso8601String().substring(11, 16)),
                ],
              ),
            ),
            SizedBox(
              width: 0.75,
              height: height - 40,
              child: const ColoredBox(
                color: Color.fromARGB(255, 35, 35, 35),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      data.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        data.place.name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
