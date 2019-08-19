import 'package:dart_crm/blocs/auth/settings_bloc.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_forms.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _settingsState createState() => _settingsState();
}

class _settingsState extends State<Settings> {
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
    settingsBloc.dispose();
    super.dispose();
  }

  Future<DBDataModel> fetchData(SettingsBloc bloc) async {
    setState(() => spinnerVisible = !spinnerVisible);
    DBDataModel dbData = await bloc.getUser();
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
    }
    // TODO: comment this forced delay, this is only to check spinner
    await new Future.delayed(const Duration(seconds: 1), () {});
    setState(() {
      settingsBloc.changeEmail(dbData.data[0].userid);
    });
    setState(() => spinnerVisible = !spinnerVisible);
    return dbData;
  }

  @override
  Widget build(BuildContext context) {
    SettingsBloc settingsBloc = SettingsBloc();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(cSettingsTitle, style: cHeaderWhiteText),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white, size: 30.0),
            tooltip: 'Setup',
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/settings',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 200, height: 50),
                    RaisedButton(
                        child: Text('Show User Settings'),
                        color: Colors.blue,
                        onPressed: () => fetchData(settingsBloc)),
                    SizedBox(width: 10, height: 50),
                    RaisedButton(
                      child: Text('Logout'),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/',
                        );
                      },
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0),
                ),
                Text("Settings", style: cHeaderDarkText),
                //formEmailTxt(authBloc),
                CustomFormTxt(
                  streamBloc: settingsBloc.email,
                  boxLength: 50,
                  obscureTxt: false,
                  onChangeTxt: settingsBloc.changeEmail,
                  iconTxt: Icon(Icons.email),
                  hintTxt: 'username@domain.com',
                  labelTxt: 'EmailID *',
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                ),
                CustomFormTxt(
                  streamBloc: settingsBloc.name,
                  boxLength: 50,
                  obscureTxt: false,
                  onChangeTxt: settingsBloc.changeName,
                  iconTxt: Icon(Icons.account_box),
                  hintTxt: 'enter name',
                  labelTxt: 'Name *',
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                ),
                //formPasswordTxt(authBloc),
                CustomFormTxt(
                  streamBloc: settingsBloc.password,
                  boxLength: 20,
                  obscureTxt: true,
                  onChangeTxt: settingsBloc.changePassword,
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
                formSubmitBtn(settingsBloc)
              ],
            ),
          ),
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget formSubmitBtn(SettingsBloc bloc) {
    // TODO: Change this to column and add row for error, or circular indicator
    // see below example
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
            child: Text('Save'),
            color: Colors.blue,
            onPressed: snapshot.hasData ? () => fetchData(bloc) : null);
      },
    );
  }
}
