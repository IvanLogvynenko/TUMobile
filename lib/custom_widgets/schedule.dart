import 'package:flutter/material.dart';
import 'package:tumobile/api/schedule/ischedule.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key, this.data});

  final ISchedule? data;

  @override
  Widget build(BuildContext context) {
    List<Widget> events = [];
    for (var event in data!.appointments) {
      events.add(
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          event.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: events,
    );
  }
}
