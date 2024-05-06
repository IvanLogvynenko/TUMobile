import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/custom_widgets/header/header.dart';

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
    DateTime today = DateTime.now();
    // .subtract(const Duration(days: 5));

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const Header(),
            SliverToBoxAdapter(
              child: Schedule(today),
            ),
          ],
        ),
      ),
    );
  }
}
