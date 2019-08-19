import 'package:dart_crm/blocs/blogic/addressbook_bloc.dart';
import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class AddressBookAdd extends StatefulWidget {
  static const routeName = '/addressbook-add';
  @override
  _addressBookAddState createState() => _addressBookAddState();
}

class _addressBookAddState extends State<AddressBookAdd> {
  final _addressBookFormKey = GlobalKey<FormState>();
//  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var txtFName = TextEditingController();
  var txtMName = TextEditingController();
  var txtLName = TextEditingController();
  var txtAddress = TextEditingController();
  var txtCity = TextEditingController();
  var txtCountry = TextEditingController();
  var txtZipCode = TextEditingController();
  var txtEmailID = TextEditingController();
  var txtEmailID2 = TextEditingController();
  var txtPhone1 = TextEditingController();
  var txtPhone2 = TextEditingController();
  final focusMiddleName = FocusNode();

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
        "first_name": txtFName.text,
        "middle_name": txtMName.text,
        "last_name": txtLName.text,
        "address": txtAddress.text,
        "city": txtCity.text,
        "country": txtCountry.text,
        "zip_code": txtZipCode.text,
        "emailid1": txtEmailID.text,
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
    AddressBookBloc addressBookBloc = AddressBookBloc();
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
            formBuilder(context)
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }

  Widget formBuilder(BuildContext context) {
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
                Text(cAddressBookAddTitle, style: cHeaderDarkText),
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
              new TextFormField(
                controller: txtEmailID,
                cursorColor: Colors.blueAccent,
                maxLength: 50,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'eMail ID #1',
                    labelText: 'emailid 1 *',
                    fillColor: Colors.grey),
                validator: (val) => validatorBloc.isValidEmail(val)
                    ? null
                    : 'please enter a valid email ID #1',
              ),
              new TextFormField(
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
