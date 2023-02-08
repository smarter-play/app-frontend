import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/state.dart';
import 'package:app_frontend/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class LoginPage extends ConsumerStatefulWidget {
  LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(builder: (context, size) {
            return Column(children: [
              if (size.maxHeight > 600)
                Image.asset(
                  "assets/logo.jpg",
                  height: 250.0,
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomButton(
                  colored: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  },
                  text: "Sign Up",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("or"),
              ),
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
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        icon: showPassword
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomButton(
                  onPressed: () async {
                    String? result = await backend.logIn(
                        _emailController.text, _passwordController.text);

                    if (result != null) {
                      ref.read(sessionProvider.notifier).logIn(result);
                    } else {
                      if (!context.mounted) return;
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
                  text: "Login",
                ),
              ),
            ]);
          }),
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
  bool showPassword = false, showConfirmPassword = false;

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
          id: 0, // don't need to set a score, the backend will set it
          name: _nameController.text,
          surname: _surnameController.text,
          email: _emailController.text,
          dateOfBirth: pickedDate!,
          score: 0, // don't need to set this either, it will start at 0 anyway
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
      ),
    );
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
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          showPassword = !showPassword;
                        }),
                        icon: showPassword
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined),
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
                    controller: _confirmPasswordController,
                    obscureText: !showConfirmPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Confirm Password",
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          showConfirmPassword = !showConfirmPassword;
                        }),
                        icon: showConfirmPassword
                            ? const Icon(Icons.visibility_off_outlined)
                            : const Icon(Icons.visibility_outlined),
                      ),
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
