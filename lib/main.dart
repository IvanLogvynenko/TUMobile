import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/color_theme/themes.dart';
import 'package:tumobile/pages/app_body.dart';
import 'package:tumobile/providers/client_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

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
      child: MaterialApp(
        theme: Themes.lightTheme,
        // darkTheme: Themes.darkTheme,
        home: const AppBody(),
      ),
    );
  }
}
