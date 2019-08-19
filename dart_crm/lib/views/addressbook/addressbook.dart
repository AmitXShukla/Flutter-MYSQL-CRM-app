import 'package:dart_crm/blocs/blogic/addressbook_bloc.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/shared/custom_components.dart';
import 'package:dart_crm/shared/custom_style.dart';
import 'package:dart_crm/views/addressbook/addressbook-edit.dart';
import 'package:flutter_web/cupertino.dart';
import 'package:flutter_web/material.dart';

class AddressBook extends StatefulWidget {
  static const routeName = '/addressbook';
  @override
  _addressBookState createState() => _addressBookState();
}

class _addressBookState extends State<AddressBook> {
  var txtSearch = TextEditingController();
  Future<AddressDataModel> dbData;
  List<AddressBookModel> addressItems = [];
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

  Future<AddressDataModel> _fetchData(AddressBookBloc bloc) async {
    setState(() {
      messageVisible = false;
      dbData = bloc.getData("", txtSearch.text);
    });
    return dbData;
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
            Row(
              children: <Widget>[
                SizedBox(width: 150, height: 50),
                Container(
                  width: 200,
                  child: TextFormField(
                    controller: txtSearch,
                    cursorColor: Colors.blueAccent,
                    maxLength: 100,
                    decoration: InputDecoration(
                        hintText: 'ph# or id# or name',
                        labelText: 'search by any text',
                        fillColor: Colors.grey),
                  ),
                ),
                GestureDetector(
                    child: Icon(Icons.search, color: Colors.blue, size: 30.0),
                    onTap: () => _fetchData(addressBookBloc)),
                SizedBox(width: 20, height: 50),
                GestureDetector(
                    child: Icon(Icons.add, color: Colors.blue, size: 30.0),
                    // TODO: navigate to add addressbook page
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        '/addressbook-add',
                      );
                    }),
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
    return FutureBuilder<AddressDataModel>(
      //future: _fetchData(bloc), // a previously-obtained Future<String> or null
      future: dbData,
      builder:
          (BuildContext context, AsyncSnapshot<AddressDataModel> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('click Search Icon to show results.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            //return Text('Awaiting result...');
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data.error) {
                return CustomMessage(
                    toggleMessage: snapshot.data.error,
                    toggleMessageType: cMessageType.error.toString(),
                    toggleMessageTxt: snapshot.data.message);
              } else {
                return _buildResultsList(context, snapshot.data);
              }
            }
        }
        return null; // unreachable
      },
    );
  }

  Widget _buildResultsList(context, AddressDataModel dbdata) {
    return Container(
      width: 500,
      height: 500,
      child: ListView.builder(
//        itemExtent: 125,
          itemCount: dbdata.data.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, dbdata.data[index])),
    );
  }

  Widget _buildListItem(context, AddressBookModel data) {
    return ListTile(
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                  child: Icon(Icons.mode_edit, color: Colors.blue, size: 20.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressBookEdit(
                            addressid: data.addressid.toString()),
                      ),
                    );
                  }
//                  {
//                    print("form addbook resuts");
//                    print(data.addressid);
//                    Navigator.pushReplacementNamed(context, '/addressbook-edit',
//                        arguments: {"addressid": data.addressid});
//                  }
                  ),
              SizedBox(width: 15.0),
              Text(data.first_name),
              SizedBox(width: 2.0),
              Text(data.middle_name),
              SizedBox(width: 2.0),
              Text(data.last_name),
            ],
          ),
          SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              SizedBox(width: 25.0),
              Text(data.address),
            ],
          ),
          SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              SizedBox(width: 25.0),
              Text(data.city),
              SizedBox(width: 2.0),
              Text(data.zip_code),
              SizedBox(width: 2.0),
              Text(data.country),
            ],
          ),
          SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              SizedBox(width: 25.0),
              Text(data.emailid1),
              SizedBox(width: 2.0),
              Text(data.emailid2),
            ],
          ),
          SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              SizedBox(width: 25.0),
              Text(data.phone1),
              SizedBox(width: 2.0),
              Text(data.phone2),
            ],
          ),
        ],
      ),
    );
  }
}
