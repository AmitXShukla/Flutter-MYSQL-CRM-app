import 'package:dart_crm/blocs/auth/signup_bloc.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_forms.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/material.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<SignUp> {
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
    signupBloc.dispose();
    super.dispose();
  }

  Future<DBDataModel> fetchData(SignUpBloc bloc) async {
    setState(() => spinnerVisible = !spinnerVisible);
    DBDataModel dbData = await bloc.signupUser();
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
      // TODO: comment this forced delay, this is only to check spinner
      await new Future.delayed(const Duration(seconds: 1), () {});
      Navigator.pushReplacementNamed(
        context,
        '/',
      );
    }
    setState(() => spinnerVisible = !spinnerVisible);
    return dbData;
  }

  @override
  Widget build(BuildContext context) {
    SignUpBloc signUpBloc = SignUpBloc();
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.add_box),
        backgroundColor: Colors.blue,
        title: Text(cSignUpTitle, style: cHeaderWhiteText),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30.0),
            tooltip: 'Setup',
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 25.0),
              ),
              Text("Sign up", style: cHeaderDarkText),
              //formEmailTxt(authBloc),
              CustomFormTxt(
                streamBloc: signUpBloc.email,
                boxLength: 50,
                obscureTxt: false,
                onChangeTxt: signUpBloc.changeEmail,
                iconTxt: Icon(Icons.email),
                hintTxt: 'username@domain.com',
                labelTxt: 'EmailID *',
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
              ),
              CustomFormTxt(
                streamBloc: signUpBloc.name,
                boxLength: 50,
                obscureTxt: false,
                onChangeTxt: signUpBloc.changeName,
                iconTxt: Icon(Icons.account_box),
                hintTxt: 'enter name',
                labelTxt: 'Name *',
              ),
              Container(
                margin: EdgeInsets.only(top: 5.0),
              ),
              //formPasswordTxt(authBloc),
              CustomFormTxt(
                streamBloc: signUpBloc.password,
                boxLength: 20,
                obscureTxt: true,
                onChangeTxt: signUpBloc.changePassword,
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
              formSubmitBtn(signUpBloc),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/',
                    );
                  },
                  child: Chip(
                      avatar: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.add),
                      ),
                      label: Text("Already have an account", style: cNavText)))
            ],
          ),
        ),
      ),
    );
  }

  Widget formSubmitBtn(SignUpBloc bloc) {
    // TODO: Change this to column and add row for error, or circular indicator
    // see below example
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
            child: Text('Create User'),
            color: Colors.blue,
            onPressed: snapshot.hasData ? () => fetchData(bloc) : null);
      },
    );
  }
}
