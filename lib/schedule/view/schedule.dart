import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/providers/client_provider.dart';
import 'package:tumobile/schedule/view/appointment.dart';
import 'package:tumobile/schedule/view_model/schedule_data.dart';

class Schedule extends StatelessWidget {
  const Schedule(this.date, {super.key});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScheduleData>(
      future: context.read<ClientProvider>().getSchedule(date),
      builder: (BuildContext context, AsyncSnapshot<ScheduleData> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!.appointments.map((e) => Appointment(e)).toList(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
