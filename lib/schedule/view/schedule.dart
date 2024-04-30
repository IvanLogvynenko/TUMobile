import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tumobile/schedule/view_model/schedule_data.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key, this.data});

  final ScheduleData? data;

  @override
  Widget build(BuildContext context) {
    List<Widget> events = [];
    for (var event in data!.appointments) {
      events.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 125.0,
            color: const Color.fromRGBO(228, 228, 228, 1),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(event.timeOfBegin
                            .toIso8601String()
                            .substring(11, 16)),
                        Text(event.timeOfEnd
                            .toIso8601String()
                            .substring(11, 16)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 0.75,
                    height: 100,
                    child: ColoredBox(
                      color: Color.fromARGB(255, 35, 35, 35),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            event.name,
                            overflow: TextOverflow.fade,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(event.place.name),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
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
