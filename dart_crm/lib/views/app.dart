import 'package:dart_crm/shared/custom_style.dart';
import 'package:dart_crm/views/addressbook/addressbook-add.dart';
import 'package:dart_crm/views/addressbook/addressbook-edit.dart';
import 'package:dart_crm/views/addressbook/addressbook.dart';
import 'package:dart_crm/views/auth/login.dart';
import 'package:dart_crm/views/auth/profile.dart';
import 'package:dart_crm/views/auth/settings.dart';
import 'package:dart_crm/views/auth/signup.dart';
import 'package:flutter_web/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // '/': (context) => ERPHomePage(), - can not set if home: ERPHomePage() is setup, only works with initiated route
          LoginScreen.routeName: (context) => LoginScreen(),
          Settings.routeName: (context) => Settings(),
          Profile.routeName: (context) => Profile(),
          SignUp.routeName: (context) => SignUp(),
          AddressBook.routeName: (context) => AddressBook(),
          AddressBookAdd.routeName: (context) => AddressBookAdd(),
          AddressBookEdit.routeName: (context) => AddressBookEdit(),
        },
        debugShowCheckedModeBanner: false,
        theme: cThemeData,
        title: cAppTitle,
        home: ERPHomePage());
  }
}

class ERPHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            IconButton(
              // TODO: Later change this navigation to about us page
              icon: Icon(Icons.dashboard, color: Colors.white),
              tooltip: 'Login',
              onPressed: null,
            ),
            Text(
              cAppTitle,
              style: TextStyle(wordSpacing: 2),
            ),
          ],
        ),
      ),
      body: Center(child: LoginScreen()),
    );
  }
}
