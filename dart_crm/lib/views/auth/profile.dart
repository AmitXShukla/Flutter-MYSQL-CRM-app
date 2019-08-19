import 'package:dart_crm/blocs/auth/settings_bloc.dart';
import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class Profile extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile> {
  final _profileFormKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var txtUserID = TextEditingController();
  var txtName = TextEditingController();
  var txtPassword = TextEditingController();
  Future<DBDataModel> dbData;
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

  Future<DBDataModel> _fetchData(SettingsBloc bloc) async {
    setState(() {
      messageVisible = false;
      dbData = bloc.getUser();
    });
    return dbData;
  }

//  void showMessage(String message, [MaterialColor color = Colors.red]) {
//    _scaffoldKey.currentState.showSnackBar(
//        new SnackBar(backgroundColor: color, content: new Text(message)));
//  }

  void _submitForm(SettingsBloc bloc) async {
    final FormState form = _profileFormKey.currentState;
    if (!form.validate()) {
//        showMessage('Form is not valid!  Please review and correct.');
      setState(() {
        messageVisible = true;
        messageTxt = "Form is not valid!  Please review and correct.";
        messageType = cMessageType.error.toString();
      });
    } else {
      form.save(); //This invokes each onSaved event
//      UserModel formData = UserModel(
//          userid: txtUserID.text,
//          name: txtName.text,
//          jwttoken: txtPassword.text);
      DBDataModel dbData = await bloc.setUser({
        "userid": txtUserID.text,
        "name": txtName.text,
        "jwttoken": txtPassword.text
      });
      if (dbData.error) {
        setState(() {
          messageVisible = true;
          messageTxt = dbData.message;
          messageType = cMessageType.error.toString();
        });
      } else {
        messageVisible = true;
        messageTxt = "Record is updated. Please refresh page.";
        messageType = cMessageType.success.toString();
        setState(() {
          spinnerVisible = !spinnerVisible;
          Future.delayed(const Duration(seconds: 1), () {
            spinnerVisible = !spinnerVisible;
          });
        });
        await Future.delayed(const Duration(seconds: 1), () {});
        Navigator.pushReplacementNamed(
          context,
          '/profile',
        );
      }
    }
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
                '/profile',
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(width: 200, height: 50),
            Row(
              children: <Widget>[
                SizedBox(width: 200, height: 50),
                RaisedButton(
                    child: Text('Show User Settings'),
                    color: Colors.blue,
                    onPressed: () => _fetchData(settingsBloc)),
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
            formData(context)
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget formData(BuildContext context) {
    return FutureBuilder<DBDataModel>(
      //future: _fetchData(bloc), // a previously-obtained Future<String> or null
      future: dbData,
      builder: (BuildContext context, AsyncSnapshot<DBDataModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('click Show User settings.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            //return Text('Awaiting result...');
            return CircularProgressIndicator();
          case ConnectionState.done:
            // add jwt error component here
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            //return Text('Result: ${snapshot.data.message}');
            if (snapshot.data.error) {
              return CustomMessage(
                  toggleMessage: snapshot.data.error,
                  toggleMessageType: cMessageType.error.toString(),
                  toggleMessageTxt: snapshot.data.message);
            } else {
              return formBuilder(context, snapshot.data);
            }
        }
        return null; // unreachable
      },
    );
  }

  Widget formBuilder(BuildContext context, DBDataModel dbData) {
    txtUserID.text = dbData.data[0].userid;
    txtName.text = dbData.data[0].name;
    //txtPassword.text = dbData.data[0].jwttoken;
    // don't fill back password, it's jwttoken coming from REST API
    txtPassword.text = "";
    return Form(
        key: _profileFormKey,
        autovalidate: true,
        child: Container(
          height: 500,
          width: 300,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Text("Settings", style: cHeaderDarkText),
              TextFormField(
                controller: txtUserID,
                cursorColor: Colors.blueAccent,
                enabled: false,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                //onChanged: settingsBloc.changeEmail,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'username@domain.com',
                    labelText: 'EmailID *',
                    fillColor: Colors.grey
                    //errorText: snapshot.error,
                    ),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid email'
                    : null,
              ),
              TextFormField(
                controller: txtName,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                enabled: true,
                //onChanged: settingsBloc.changeEmail,
                decoration: InputDecoration(
                  icon: Icon(Icons.account_box),
                  hintText: 'Enter your name',
                  labelText: 'Name *',
                  //errorText: snapshot.error,
                ),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid name'
                    : null,
              ),
              TextFormField(
                controller: txtPassword,
                cursorColor: Colors.blueAccent,
                enabled: true,
                maxLength: 300,
                obscureText: true,
                //onChanged: settingsBloc.changeEmail,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock_outline),
                  hintText: 'enter password',
                  labelText: 'Password *',
                  //errorText: snapshot.error,
                ),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid password'
                    : null,
              ),
              Container(
                margin: EdgeInsets.only(top: 25.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible),
              CustomMessage(
                  toggleMessage: messageVisible,
                  toggleMessageType: messageType,
                  toggleMessageTxt: messageTxt),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  child: const Text('Save'),
                  onPressed: () => {_submitForm(settingsBloc)},
                ),
              ),
            ],
          ),
        ));
  }
}
