import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumobile/api/TUM/requests/tum_client.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
// import 'package:tumobile/custom_widgets/schedule.dart';

void main() async {
  IClient client = TUMClient();
  await client.init();
  await client.login();
  runApp(MainApp(client: client,));
}

class MainApp extends StatelessWidget {
  final IClient? client;
  const MainApp({super.key, this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.light,
          ),
          textTheme: GoogleFonts.anonymousProTextTheme(),
          scaffoldBackgroundColor: const Color(0xFFDFDFDF),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                "Welcome, *name*",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
            backgroundColor: const Color(0xFFA7A1E8),
          ),
          body: const SafeArea(
            child: Placeholder(),
          ),
          bottomSheet: const SizedBox(
            height: 50.0,
            child: Placeholder(),
          ),
        )
        // appBar:
        // body: const SafeArea(
        //   child: Placeholder(),
        // ),
        // ),
        );
  }
}
