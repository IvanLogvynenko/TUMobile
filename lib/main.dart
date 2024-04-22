import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/pages/app_body.dart';
import 'package:tumobile/providers/client_provider.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClientProvider()),
      ],
      child: const MaterialApp(home: AppBody()),
    );
  }
}
