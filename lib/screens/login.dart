import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignupPage(),
                    ),
                  );
                },
                child: const Text("Sign Up")),
            const Text("or"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Enter your login credentials",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 50.0,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 50.0,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () async {
                String? result = await backend.logIn(
                    _emailController.text, _passwordController.text);

                if (result != null) {
                  ref.read(sessionProvider.notifier).logIn(result);
                } else {
                  showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                            title: Text("Wrong credentials"),
                            content: Text(
                              "The credentials you entered are wrong. Please try again.",
                            ),
                          ));
                }
              },
              child: const Text("Login"),
            ),
          ]),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  DateTime? pickedDate;

  Future<void> signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text("Error"),
                content: Text(
                  "The passwords you entered are not the same. Please try again.",
                ),
              ));
      return;
    } else if (pickedDate == null) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text("Error"),
                content: Text(
                  "You have to enter your date of birth. Please try again.",
                ),
              ));
      return;
    }
    try {
      await backend.signUp(
        User(
          name: _nameController.text,
          surname: _surnameController.text,
          email: _emailController.text,
          dateOfBirth: pickedDate!,
        ),
        _passwordController.text,
      );
    } catch (e) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                title: Text("Error"),
                content: Text(
                  "The email you entered is already in use. Please try again.",
                ),
              ));
      return;
    }
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              title: Text("Signup successful"),
              content: Text(
                "You have successfully signed up to Smarter Play!",
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Enter your account data",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50.0,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Name",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50.0,
                  child: TextField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Surname",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () async {
                    initializeDateFormatting();
                    var date = await showDatePicker(
                      context: context,
                      initialDate: pickedDate ?? DateTime(2000),
                      firstDate: DateTime(1900, 01, 01),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        pickedDate = date;
                        var format = DateFormat.yMd(
                            Localizations.localeOf(context).scriptCode ??
                                "it_IT");
                        _dobController.text = format.format(date);
                      });
                    }
                  },
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SizedBox(
                      height: 50.0,
                      child: TextField(
                        enabled: false,
                        controller: _dobController,
                        decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.white70),
                          labelText: "Date of Birth",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50.0,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50.0,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 50.0,
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password",
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: signUp,
                child: const Text("Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
