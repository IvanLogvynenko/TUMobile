import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tumobile/pages/app_body.dart';
import 'package:tumobile/providers/client_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  String username = '';
  String password = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getValues();
  }

  void _getValues() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('rememberMe')) {
      setState(() {
        rememberMe = prefs.getBool('rememberMe')!;
        if (rememberMe) {
          if (prefs.containsKey('username')) {
            username = prefs.getString('username')!;
          }
          if (prefs.containsKey('password')) {
            password = prefs.getString('password')!;
          }
        }
        _usernameController.text = username;
        _passwordController.text = password;
      });
    } else {
      prefs.setBool('rememberMe', false);
      setState(() {
        rememberMe = false;
      });
    }
  }

  void _saveValues() async {
    var prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      prefs.setBool('rememberMe', rememberMe);
      prefs.setString('username', username);
      prefs.setString('password', password);
    } else {
      prefs.setBool("rememberMe", rememberMe);
      prefs.remove('username');
      prefs.remove('password');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      controller: _usernameController,
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
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: "password",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Remember me"),
                        Checkbox(
                          value: rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberMe = value!;
                            });
                            _saveValues();
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
                if (username == "" || password == "" || password.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter valid login and password'),
                    ),
                  );
                } else {
                  if (rememberMe) {
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString('username', username);
                    prefs.setString('password', password);
                  }
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
