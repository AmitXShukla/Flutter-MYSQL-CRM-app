import 'package:dart_crm/blocs/blogic/addressbook_bloc.dart';
import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class AddressBookEdit extends StatefulWidget {
  final String addressid;
  AddressBookEdit({Key key, @required this.addressid}) : super(key: key);
  static const routeName = '/addressbook-edit';
  @override
  _addressBookEditState createState() => _addressBookEditState();
}

class _addressBookEditState extends State<AddressBookEdit> {
  final _addressBookFormKey = GlobalKey<FormState>();
  AddressBookBloc addressBookBloc = AddressBookBloc();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var txtAddressId = TextEditingController();
  var txtFName = TextEditingController();
  var txtMName = TextEditingController();
  var txtLName = TextEditingController();
  var txtAddress = TextEditingController();
  var txtCity = TextEditingController();
  var txtCountry = TextEditingController();
  var txtZipCode = TextEditingController();
  var txtEmailID1 = TextEditingController();
  var txtEmailID2 = TextEditingController();
  var txtPhone1 = TextEditingController();
  var txtPhone2 = TextEditingController();
  final focusMiddleName = FocusNode();

  Future<AddressDataModel> dbData;
  bool spinnerVisible = false;
  bool messageVisible = false;
  String messageTxt = "";
  String messageType = "";

  @override
  void initState() {
    super.initState();
    _fetchData(widget.addressid.toString(), addressBookBloc);
  }

  Future<AddressDataModel> _fetchData(String id, AddressBookBloc bloc) async {
    setState(() {
      messageVisible = false;
      dbData = bloc.getData(id, "");
    });
    var x = await bloc.getData(id, "");
    return dbData;
  }

  @override
  void dispose() {
    addressBookBloc.dispose();
    super.dispose();
  }

  void _submitForm(AddressBookBloc bloc) async {
    final FormState form = _addressBookFormKey.currentState;
    if (!form.validate()) {
//        showMessage('Form is not valid!  Please review and correct.');
      setState(() {
        messageVisible = true;
        messageTxt = "Form is not valid!  Please review and correct.";
        messageType = cMessageType.error.toString();
      });
    } else {
      form.save();
      DBDataModel dbData = await bloc.setData({
        "table_name": "addressbook",
        "addressid": txtAddressId.text,
        "first_name": txtFName.text,
        "middle_name": txtMName.text,
        "last_name": txtLName.text,
        "address": txtAddress.text,
        "city": txtCity.text,
        "country": txtCountry.text,
        "zip_code": txtZipCode.text,
        "emailid1": txtEmailID1.text,
        "emailid2": txtEmailID2.text,
        "phone1": txtPhone1.text,
        "phone2": txtPhone2.text
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
          '/addressbook',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(cAddressBookTitle, style: cHeaderWhiteText),
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
            SizedBox(
              width: 10,
              height: 20,
            ),
//            formBuilder(context, dbData)
            formData(context, dbData)
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget formData(BuildContext context, dbData) {
    return FutureBuilder<AddressDataModel>(
      //future: _fetchData(bloc), // a previously-obtained Future<String> or null
      future: dbData,
      builder:
          (BuildContext context, AsyncSnapshot<AddressDataModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('click Search Icon to show recent results.');
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

  Widget formBuilder(BuildContext context, dbData) {
    txtAddressId.text = dbData.data[0].addressid.toString();
    txtFName.text = dbData.data[0].first_name;
    txtMName.text = dbData.data[0].middle_name;
    txtLName.text = dbData.data[0].last_name;
    txtAddress.text = dbData.data[0].address;
    txtCity.text = dbData.data[0].city;
    txtCountry.text = dbData.data[0].country;
    txtZipCode.text = dbData.data[0].zip_code;
    txtEmailID1.text = dbData.data[0].emailid1;
    txtEmailID2.text = dbData.data[0].emailid2;
    txtPhone1.text = dbData.data[0].phone1;
    txtPhone2.text = dbData.data[0].phone2;
    return Form(
        key: _addressBookFormKey,
        autovalidate: true,
        child: Container(
          height: 500,
          width: 400,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: <Widget>[
              Row(children: [
                Text(cAddressBookEditTitle, style: cHeaderDarkText),
                SizedBox(
                  width: 100,
                  height: 10,
                ),
                GestureDetector(
                  child: Icon(Icons.search, color: Colors.blue, size: 30.0),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/addressbook',
                    );
                  },
                ),
                SizedBox(
                  width: 50,
                  height: 10,
                ),
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.blue, size: 30.0),
                  onTap: () {
                    // TODO: delete logic
                    Navigator.pushReplacementNamed(
                      context,
                      '/addressbook',
                    );
                  },
                ),
              ]),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  child: const Text('Save'),
                  onPressed: () => {_submitForm(addressBookBloc)},
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0),
              ),
              CustomSpinner(toggleSpinner: spinnerVisible),
              CustomMessage(
                  toggleMessage: messageVisible,
                  toggleMessageType: messageType,
                  toggleMessageTxt: messageTxt),
              TextFormField(
                controller: txtAddressId,
                enabled: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    hintText: 'Address ID',
                    labelText: 'Address ID *',
                    fillColor: Colors.grey),
              ),
              TextFormField(
                controller: txtFName,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focusMiddleName);
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'First Name',
                    labelText: 'First Name *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid text'
                    : null,
              ),
              TextFormField(
                controller: txtMName,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                focusNode: focusMiddleName,
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Middle Name',
                    labelText: 'Middle Name *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid text'
                    : null,
              ),
              TextFormField(
                controller: txtLName,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Last Name',
                    labelText: 'Last Name *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid text'
                    : null,
              ),
              TextFormField(
                controller: txtAddress,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                    icon: Icon(Icons.business),
                    hintText: 'Address',
                    labelText: 'Address *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid address'
                    : null,
              ),
              TextFormField(
                controller: txtCity,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                    icon: Icon(Icons.business),
                    hintText: 'City',
                    labelText: 'City *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid City'
                    : null,
              ),
              TextFormField(
                controller: txtCountry,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                decoration: InputDecoration(
                    icon: Icon(Icons.flag),
                    hintText: 'Country',
                    labelText: 'Country *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid Country Name'
                    : null,
              ),
              TextFormField(
                controller: txtZipCode,
                cursorColor: Colors.blueAccent,
                maxLength: 10,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    icon: Icon(Icons.gps_fixed),
                    hintText: 'Zip Code',
                    labelText: 'Zip Code *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.validateFormText(val)
                    ? 'please enter a valid zipcode'
                    : null,
              ),
              TextFormField(
                controller: txtEmailID1,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'eMail ID #1',
                    labelText: 'emailid 1 *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.isValidEmail(val)
                    ? null
                    : 'please enter a valid email ID #1',
              ),
              TextFormField(
                controller: txtEmailID2,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'eMail ID #2',
                    labelText: 'emailid 2 *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.isValidEmail(val)
                    ? null
                    : 'please enter a valid email ID #2',
              ),
              TextFormField(
                controller: txtPhone1,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: 'Phone #1',
                    labelText: 'Phone #1 *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.isValidPhoneNumber(val)
                    ? 'please enter a valid Phone 1 #'
                    : null,
              ),
              TextFormField(
                controller: txtPhone2,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    hintText: 'Phone #2',
                    labelText: 'Phone #2 *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.isValidPhoneNumber(val)
                    ? 'please enter a valid Phone 2 #'
                    : null,
              ),
            ],
          ),
        ));
  }
}

/***
import 'package:dart_crm/blocs/blogic/addressbook_bloc.dart';
import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class AddressBookEdit extends StatefulWidget {
  static const routeName = '/addressbook-edit';
  @override
  _addressBookEditState createState() => _addressBookEditState();
}

class _addressBookEditState extends State<AddressBookEdit> {
  final _addressBookFormKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var txtSearch = TextEditingController();
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
    addressBookBloc.dispose();
    super.dispose();
  }

  Future<DBDataModel> _fetchData(AddressBookBloc bloc) async {
    setState(() {
      messageVisible = false;
      dbData = bloc.getUser();
    });
    return dbData;
  }

  void _submitForm(AddressBookBloc bloc) async {
    final FormState form = _addressBookFormKey.currentState;
    if (!form.validate()) {
//        showMessage('Form is not valid!  Please review and correct.');
      setState(() {
        messageVisible = true;
        messageTxt = "Form is not valid!  Please review and correct.";
        messageType = cMessageType.error.toString();
      });
    } else {
      form.save(); //This invokes each onSaved event
      DBDataModel dbData = await bloc.setData({
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
    AddressBookBloc addressBookBloc = AddressBookBloc();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(cAddressBookEditTitle, style: cHeaderWhiteText),
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
            Row(
              children: <Widget>[
                SizedBox(width: 150, height: 50),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: txtSearch,
                    cursorColor: Colors.blueAccent,
                    maxLength: 100,
                    //inputFormatters: [new LengthLimitingTextInputFormatter(50)],
                    //onChanged: settingsBloc.changeEmail,
                    decoration: InputDecoration(
//                        icon: Icon(Icons.email),
                        hintText: 'ph# or id# or name',
                        labelText: 'search by any text',
                        fillColor: Colors.grey
                        //errorText: snapshot.error,
                        ),
//                    validator: (val) => validatorBloc.validateFormText(val)
//                        ? 'please enter a valid email'
//                        : null,
                  ),
                ),
                GestureDetector(
                  child: Icon(Icons.search, color: Colors.blue, size: 30.0),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/addressbook',
                    );
                  },
                ),
                SizedBox(width: 20, height: 50),
                GestureDetector(
                    child: Icon(Icons.add, color: Colors.blue, size: 30.0),
                    // TODO: navigate to add addressbook page
                    onTap: () => _fetchData(addressBookBloc)),
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
            return Text('click Search Icon to show recent results.');
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
        key: _addressBookFormKey,
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
                  onPressed: () => {_submitForm(addressBookBloc)},
                ),
              ),
            ],
          ),
        ));
  }
}

    **/
