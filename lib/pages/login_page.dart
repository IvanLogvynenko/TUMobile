import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tumobile/api/requests/client.dart';
import 'package:tumobile/pages/app_body.dart';
import 'package:tumobile/providers/client_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    var client = context.read<ClientProvider>().client;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset('assets/tum_logo.svg'),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: loginController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: "login",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: "password",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String username = loginController.text;
                String password = passwordController.text;
                if (username == "" || password == "" || password.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter valid login and password'),
                    ),
                  );
                } else {
                  client.setCredentials(username, password);
                  await client.login();
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppBody(),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(212, 33, 158, 180),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}
