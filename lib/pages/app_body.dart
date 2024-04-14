import 'package:flutter/material.dart';
import 'package:tumobile/api/general/custom_widgets/icolor_theme.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/schedule/ischedule.dart';
import 'package:tumobile/custom_widgets/footer.dart';
import 'package:tumobile/custom_widgets/schedule.dart';
import 'package:tumobile/pages/login_page.dart';

class AppBody extends StatelessWidget {
  final IClient? client;
  final ColorTheme? colorTheme;

  const AppBody(this.client, this.colorTheme, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!client!.credentialsProvided || !client!.isLoggedIn) {
      return LoginPage(client, colorTheme);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Welcome, *name*",
          ),
        ),
        backgroundColor: ColorTheme.appBar,
      ),
      body: SafeArea(
        child: FutureBuilder<ISchedule>(
          future: client!.getCalendar(DateTime.parse("2024-04-15")),
          builder: (BuildContext context, AsyncSnapshot<ISchedule> snapshot) {
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
