import 'dart:async';

import 'auth_provider.dart';

class AuthRepository {
  final userAuthApiProvider = UserAuthApiProvider();
  Future validateUser(formData) =>
      userAuthApiProvider.validateUserAuth(formData);
}

class SignupRepository {
  final userAuthApiProvider = UserAuthApiProvider();
  Future createUser(formData) => userAuthApiProvider.createUser(formData);
}

class SettingsRepository {
  final userAuthApiProvider = UserAuthApiProvider();
  //Future getUser(formData) => userAuthApiProvider.getUser(formData);
  Future getUser() => userAuthApiProvider.getUser();
  Future setUser(formData) => userAuthApiProvider.setUser(formData);
  Future getData(formData) => userAuthApiProvider.getData(formData);
  Future setData(formData) => userAuthApiProvider.setData(formData);
}
