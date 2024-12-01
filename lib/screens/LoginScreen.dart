import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_resto_agent/Helpers/localization.dart';
import 'package:mobile_resto_agent/bloc/LoginBloc.dart';
import 'package:mobile_resto_agent/screens/MainScreen.dart';
import 'package:mobile_resto_agent/screens/SettingsScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final BorderRadius borderRadius = BorderRadius.circular(15);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVisible = true;
  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    final trs = AppLocalizations.of(context);

    void submitForm() {
      BlocProvider.of<LoginBloc>(context).add(SubmitEvent(
        name: nameController.text,
        password: passController.text,
      ));
    }

    Widget buildForm(bool error, String text) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        height: error ? 185 : 150,
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (error)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      trs.translate(text) ?? text,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.white,
                ),
                child: TextFormField(
                  autofocus: true,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: trs.translate('name'),
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: borderRadius,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Colors.white,
                ),
                child: TextFormField(
                  obscureText: isVisible,
                  controller: passController,
                  onFieldSubmitted: (String str) {
                    submitForm();
                  },
                  decoration: InputDecoration(
                    hintText: trs.translate('password'),
                    hintStyle: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.password,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(8.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: borderRadius,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColorLight),
                      borderRadius: borderRadius,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      side: BorderSide(
                        style: BorderStyle.solid,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    onPressed: () {
                      submitForm();
                    },
                    child: Text(trs.translate('submit') ?? 'submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Container(),
        title: Text(trs.translate('login_screen') ?? 'login_screen'),
        centerTitle: true,
        actions: [
          Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.only(right: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(),
                  ),
                );
              },
              child: Container(
                child: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColorLight,
                ),
                padding: EdgeInsets.all(8.0),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state is SuccessfulState) {
                    // if login and password is right it will navigate to
                    // MainScreen and there will be shown tables
                    nameController.text = '';
                    passController.text = '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MainScreen(name: state.waiterName),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is UnsuccessfulState) {
                    // if state is unseccessfulState it will show login or
                    // password wrong text and it will show same form for
                    // all states
                    return buildForm(true, state.text);
                  } else
                    return buildForm(false, '');
                },
              ),
            ),
          ),
          Container(
            height: height > 500 ? 200 : 0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    super.dispose();
  }
}
