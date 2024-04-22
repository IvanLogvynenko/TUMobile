import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tumobile/api/schedule/schedule_data.dart';

import 'package:tumobile/custom_widgets/footer.dart';
import 'package:tumobile/custom_widgets/schedule.dart';

import 'package:tumobile/pages/login_page.dart';

import 'package:tumobile/providers/client_provider.dart';

class AppBody extends StatelessWidget {
  const AppBody({super.key});

  @override
  Widget build(BuildContext context) {
    var client = context.read<ClientProvider>().client;

    if (!client.credentialsProvided || !client.isLoggedIn) {
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Hi, ",
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<ScheduleData>(
          future: client.getCalendar(DateTime.now()),
          builder: (BuildContext context, AsyncSnapshot<ScheduleData> snapshot) {
            if (snapshot.hasData) {
              return Schedule(data: snapshot.data);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      bottomSheet: const SizedBox(
        height: 75.0,
        child: Footer(),
      ),
    );
  }
}
