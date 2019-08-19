import 'dart:async';

import 'package:dart_crm/blocs/auth/auth_bloc.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_forms.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _loginScreenState createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  Future<DBDataModel> fetchData(AuthBloc bloc) async {
    setState(() => spinnerVisible = !spinnerVisible);
    DBDataModel dbData = await bloc.validateUserAuth();
    // TODO: comment this forced delay, this is only to check spinner
    await new Future.delayed(const Duration(seconds: 1), () {});
    if (dbData.error) {
      messageVisible = dbData.error;
      messageTxt = dbData.message;
      messageType = cMessageType.error.toString();
    } else {
      messageVisible = dbData.message != "" ? true : false;
      messageTxt = dbData.message;
      messageType = cMessageType.success.toString();
      // obtain shared preferences
      // store jwttoken
      // FLUTTER_WEB version is not working to store at present
      // TODO: enable this for android/ios version
//      final prefs = await SharedPreferences.getInstance();
//      prefs.setInt('token', dbData.data[0].jwttoken);
      //await new Future.delayed(const Duration(seconds: 1), () {});
      Navigator.pushReplacementNamed(
        context,
        '/profile',
      );
    }
    setState(() => spinnerVisible = !spinnerVisible);
    return dbData;
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc();
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25.0),
            ),
            Text("Login", style: cHeaderDarkText),
            //formEmailTxt(authBloc),
            CustomFormRoundedTxt(
              streamBloc: authBloc.email,
              obscureTxt: false,
              onChangeTxt: authBloc.changeEmail,
              iconTxt: Icon(Icons.email),
              hintTxt: 'username@domain.com',
              labelTxt: 'EmailID *',
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
            ),
            //formPasswordTxt(authBloc),
            CustomFormRoundedTxt(
              streamBloc: authBloc.password,
              obscureTxt: true,
              onChangeTxt: authBloc.changePassword,
              iconTxt: Icon(Icons.lock_outline),
              hintTxt: 'enter password',
              labelTxt: 'Password *',
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
            ),
            //dbFunctions(authBloc),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            CustomSpinner(toggleSpinner: spinnerVisible),
            CustomMessage(
                toggleMessage: messageVisible,
                toggleMessageType: messageType,
                toggleMessageTxt: messageTxt),
            Container(
              margin: EdgeInsets.only(top: 15.0),
            ),
            formSubmitBtn(authBloc),
            Container(
              margin: EdgeInsets.only(top: 15.0),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/signup',
                  );
                },
                child: Chip(
                    avatar: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.add),
                    ),
                    label: Text("Create new Account", style: cNavText)))
          ],
        ),
      ),
    );
  }

  Widget formSubmitBtn(AuthBloc bloc) {
    // TODO: Change this to column and add row for error, or circular indicator
    // see below example
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
            child: Text('Login'),
            color: Colors.blue,
            onPressed: snapshot.hasData ? () => fetchData(bloc) : null);
      },
    );
  }
}
