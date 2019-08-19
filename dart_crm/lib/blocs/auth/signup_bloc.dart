import 'dart:async';

import 'package:dart_crm/blocs/validators.dart';
import 'package:dart_crm/providers/auth_resources.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends Object with Validators {
  final _emailController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // API: Add data to stream
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get name => _nameController.stream.transform(validateText);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid =>
      Observable.combineLatest3(email, name, password, (e, n, p) => true);

  // API: change data
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  signupUser() async {
    final validEmail = _emailController.value;
    final validName = _nameController.value;
    final validPassword = _passwordController.value;

    if (validEmail != "" && validName != "" && validPassword != "") {
      return SignupRepository().createUser({
        "email": validEmail,
        "name": validName,
        "enc_password": validPassword
      });
    }
  }

  // API: dispose/cancel observables/subscriptions
  dispose() {
    _emailController.close();
    _nameController.close();
    _passwordController.close();
  }
}

final signupBloc = SignUpBloc();
