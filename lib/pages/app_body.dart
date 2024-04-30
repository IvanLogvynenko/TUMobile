import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tumobile/schedule/view_model/schedule_data.dart';

import 'package:tumobile/schedule/view/schedule.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            const Placeholder(
              fallbackHeight: 200,
              child: Center(child: Text("here will be header")),
            ),
            FutureBuilder<ScheduleData>(
              future: client.getCalendar(DateTime.now()),
              builder:
                  (BuildContext context, AsyncSnapshot<ScheduleData> snapshot) {
                if (snapshot.hasData) {
                  return Schedule(data: snapshot.data);
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
