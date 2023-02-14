import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ProfilePage(this.user, [this.editable = false]);

  final User user;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: editable
            ? [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditProfile(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/logo.jpg'),
                    radius: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "${user.name} ${user.surname}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "SCORE",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "${user.score}",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ],
            ),
            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );
  }
}

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late final notifier = ref.watch(sessionProvider.notifier);
  late var user = ref.watch(sessionProvider)!.user;
  late final _nameController = TextEditingController(text: user.name);
  late final _surnameController = TextEditingController(text: user.surname);
  late final _emailController = TextEditingController(text: user.email);
  late var _dob = user.dateOfBirth;
  late final _dobController = TextEditingController(
      text:
          DateFormat.yMd(Localizations.localeOf(context).scriptCode ?? "it_IT")
              .format(_dob));

  late final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text("Edit profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              child: GestureDetector(
                onTap: () async {
                  initializeDateFormatting();
                  var date = await showDatePicker(
                    context: context,
                    initialDate: _dob,
                    firstDate: DateTime(1900, 01, 01),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _dob = date;
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
          ],
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          onPressed: () async {
            await backend.editUser(
              _nameController.text,
              _surnameController.text,
              _emailController.text,
              _dob,
            );
            await notifier.updateProfile();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Profile updated"),
            ));
          },
          child: const Icon(Icons.save),
        );
      }),
    );
  }
}
