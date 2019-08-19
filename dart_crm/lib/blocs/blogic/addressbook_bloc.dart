import 'dart:async';

import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/models/datamodel.dart';
import 'package:dart_crm/providers/auth_resources.dart';

class AddressBookBloc extends Object with Validators {
  Future<DBDataModel> getUser() async {
    return await SettingsRepository().getUser();
  }

  Future<AddressDataModel> getData(String _id, String srchTxt) async {
    return await SettingsRepository()
        .getData({"table_name": "addressbook", "_id": _id, "srchTxt": srchTxt});
  }

  Future<DBDataModel> setData(formData) async {
    return SettingsRepository().setData(formData);
  }

  // API: dispose/cancel observables/subscriptions
  dispose() {}
}

final addressBookBloc = AddressBookBloc();
