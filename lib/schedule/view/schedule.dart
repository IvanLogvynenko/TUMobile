import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/providers/client_provider.dart';
import 'package:tumobile/schedule/model/appointment_data.dart';
import 'package:tumobile/schedule/view/appointment.dart';
import 'package:tumobile/schedule/view/pause.dart';
import 'package:tumobile/schedule/view_model/schedule_data.dart';

class Schedule extends StatefulWidget {
  const Schedule(this.startDate, {super.key});

  final DateTime startDate;

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime currentDate = DateTime.now();

  List<Widget> _aggregateBreaksInSchedule(List<AppointmentData> appointments) {
    List<Widget> result = [];
    if (appointments.isEmpty) {
      return [const Text("Seems you're having a weekday!)")];
    }
    result.add(Appointment(appointments[0]));
    for (int i = 1; i < appointments.length; i++) {
      AppointmentData previous = appointments[i - 1], current = appointments[i];
      Duration breakDuration = current.begin.difference(previous.end);
      if (breakDuration.inMinutes >= 30) {
        result.add(Pause.byBeginandEnd(previous.end, current.begin));
      }
      result.add(Appointment(current));
    }
    return result;
  }

  Widget _convertDateToWidget(DateTime date) {
    DateTime now = DateTime.now();
    String today = (now.day == date.day &&
            now.month == date.month &&
            now.year == date.year)
        ? "Heute, "
        : "";
    String day = date.day > 9 ? date.day.toString() : "0${date.day}";

    String month = "";
    switch (date.month) {
      case 1:
        month = "Januar";
        break;
      case 2:
        month = "Februar";
        break;
      case 3:
        month = "März";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "Mai";
        break;
      case 6:
        month = "Juni";
        break;
      case 7:
        month = "Juli";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "Oktober";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "Dezember";
        break;
      default:
        month = date.month.toString();
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "$today$day. $month",
        style: const TextStyle(fontSize: 25),
      ),
    );
  }

  @override
  void initState() {
    currentDate = widget.startDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        const delta = Duration(days: 1);
        if (details.primaryVelocity! > 0) {
          setState(() {
            currentDate = currentDate.subtract(delta);
          });
        } else if (details.primaryVelocity! < 0) {
          setState(() {
            currentDate = currentDate.add(delta);
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<ScheduleData>(
          future: context.read<ClientProvider>().getSchedule(currentDate),
          builder:
              (BuildContext context, AsyncSnapshot<ScheduleData> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  _convertDateToWidget(currentDate),
                  ..._aggregateBreaksInSchedule(snapshot.data!.appointments),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
