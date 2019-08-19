import 'package:dart_crm/shared/custom_style.dart';
import 'package:flutter_web/material.dart';

class CustomSpinner extends StatelessWidget {
  final bool toggleSpinner;
  const CustomSpinner({Key key, this.toggleSpinner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: toggleSpinner ? CircularProgressIndicator() : null);
  }
}

class CustomMessage extends StatelessWidget {
  final bool toggleMessage;
  final toggleMessageType;
  final String toggleMessageTxt;
  const CustomMessage(
      {Key key,
      this.toggleMessage,
      this.toggleMessageType,
      this.toggleMessageTxt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: toggleMessage
            ? Text(toggleMessageTxt,
                style: toggleMessageType == cMessageType.error.toString()
                    ? cErrorText
                    : cSuccessText)
            : null);
  }
}

class CustomDrawer extends StatelessWidget {
  //final bool toggleSpinner;
  const CustomDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: cLabel,
// Add a ListView to the drawer. This ensures the user can scroll
// through the options in the drawer if there isn't enough vertical
// space to fit everything.
      child: ListView(
// Important: Remove any padding from the ListView.
        padding: EdgeInsets.all(4.0),
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(cAppTitle),
            accountEmail: Text(cEmailID),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(cSampleImage),
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.book),
            title: Text(
              "AddressBook",
              style: cNavText,
            ),
            onTap: () => {
              Navigator.pushReplacementNamed(
                context,
                '/addressbook',
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              "Marketing",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Manage Campaigns, Leads & Opportunities.'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text(
              "Call Register",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Manage Calls, eMails, enquiry, & visits'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text(
              "Customer",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Bills, Invoices & Sales register'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.sms),
            title: Text(
              "HelpDesk",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Service Tickets, Workorder'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.satellite),
            title: Text(
              "Vendors",
              style: cNavText,
            ),
            onTap: null,
            subtitle: Text('Vouchers, Bills, Invoices'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              "Admin",
              style: cNavText,
            ),
            onTap: null,
          ),
          RaisedButton(
            child: Text('Logout'),
            color: Colors.blue,
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/',
              );
            },
          ),
        ],
      ),
    );
  }
}
