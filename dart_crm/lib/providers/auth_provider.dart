//import 'package:dart_crm/blocs/auth_bloc.dart';
//import 'package:flutter_web/material.dart';
//
//class Provider extends InheritedWidget {
//  final bloc = Bloc();
//
//  Provider({Key key, Widget child}) : super(key: key, child: child);
//
//  bool updateShouldNotify(_) => true;
//
//  static Bloc of(BuildContext context) {
//    //* What it does is through the "of" function, it looks through the context of a widget from the deepest in the widget tree
//    //* and it keeps travelling up to each widget's parent's context until it finds a "Provider" widget
//    //* and performs the type conversion to Provider through "as Provider" and then access the Provider's bloc instance variable
//    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;
//  }
//}
import 'dart:async';
import 'dart:convert';

import 'package:dart_crm/models/datamodel.dart';
import 'package:http/http.dart' show Client;

class UserAuthApiProvider {
  var fakeJsonResponse_1 = """{
      "num_rows": 1,
  "error": false,
  "message": "Operation Successful.",
  "data": [
  {
  "userid": "amit@elishconsulting.com",
  "name": "Amit Shukla",
  "role": "Admin",
  "jwttoken": "abcd",
  "createdAt": "abcd",
  "updatedAt": "abcd"
  }
  ]
}""";
  var serverFailed = """{
      "num_rows": 0,
  "error": true,
  "message": "Server Error. Possible Broken Network. Please send an email to info@elishconsulting.com",
  "data": [
  {
  "userid": "",
  "name": "",
  "role": "",
  "jwttoken": "",
  "createdAt": "",
  "updatedAt": ""
  }
  ]
}""";
  Client client = Client();
  final _baseUrl = "http://localhost:3000";

//  let token = localStorage.getItem('token') ? localStorage.getItem('token') : "abcd";
//  let httpOptions = { headers: new HttpHeaders({ 'Content-Type': 'application/json', 'token': token }) };

  Future<DBDataModel> validateUserAuth(formData) async {
    try {
      final response = await client.post("$_baseUrl/login",
          headers: {
            //HttpHeaders.authorizationHeader: ["token" : "Basic your_api_token_here"]
            "token": "invalid_token"
          },
          body: formData);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        print(response.body);
        return await DBDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await DBDataModel.fromJson(json.decode(serverFailed));
    }
    return await DBDataModel.fromJson(json.decode(serverFailed));
  }

  Future<DBDataModel> createUser(formData) async {
    try {
      final response = await client.post("$_baseUrl/signup",
          headers: {
            //HttpHeaders.authorizationHeader: "Basic your_api_token_here"
            "token": "invalid_token"
          },
          body: formData);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return await DBDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await DBDataModel.fromJson(json.decode(serverFailed));
    }
    return await DBDataModel.fromJson(json.decode(serverFailed));
  }

  Future<DBDataModel> getUser() async {
    final formData = {};
//    final token = "invalid_token";
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXRAeWFob28uY29tIiwiaWF0IjoxNTYzODUwNDIwLCJleHAiOjE1NjY0NDI0MjB9.7TAxrqaRNwIEMQH-Qv51BLk3Zy_eYe3KtGN_Id1hVA4";
    // FLUTTER_WEB version is not working to store at present
    // TODO: enable this for android/ios version
//    final prefs = await SharedPreferences.getInstance();
//    final token = prefs.getInt('token') ?? "invalid_token";
    try {
      final response = await client.post("$_baseUrl/getuser",
          headers: {"token": token}, body: formData);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return await DBDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await DBDataModel.fromJson(json.decode(serverFailed));
    }
    return await DBDataModel.fromJson(json.decode(serverFailed));
  }

  Future<DBDataModel> setUser(formData) async {
    final formData2 = formData;
    //final token = "invalid_token";
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXRAeWFob28uY29tIiwiaWF0IjoxNTYzNzcxMDEyLCJleHAiOjE1NjYzNjMwMTJ9.c39YqxKYtdqi199Ivh_-7LPzTe8BC21xWtvcqv0TTck";
    // FLUTTER_WEB version is not working to store at present
    // TODO: enable this for android/ios version
//    final prefs = await SharedPreferences.getInstance();
//    final token = prefs.getInt('token') ?? "invalid_token";
    try {
      //print(formData.userid);
      final response = await client.post("$_baseUrl/setuser",
          headers: {"token": token}, body: formData2);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return await DBDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await DBDataModel.fromJson(json.decode(serverFailed));
    }
    return await DBDataModel.fromJson(json.decode(serverFailed));
  }

  Future<DBDataModel> setData(formData) async {
    final formData2 = formData;
    //final token = "invalid_token";
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXRAeWFob28uY29tIiwiaWF0IjoxNTYzNzcxMDEyLCJleHAiOjE1NjYzNjMwMTJ9.c39YqxKYtdqi199Ivh_-7LPzTe8BC21xWtvcqv0TTck";
    // FLUTTER_WEB version is not working to store at present
    // TODO: enable this for android/ios version
//    final prefs = await SharedPreferences.getInstance();
//    final token = prefs.getInt('token') ?? "invalid_token";
    try {
      //print(formData.userid);
      final response = await client.post("$_baseUrl/setdata",
          headers: {"token": token}, body: formData2);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        return await DBDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await DBDataModel.fromJson(json.decode(serverFailed));
    }
    return await DBDataModel.fromJson(json.decode(serverFailed));
  }

  Future<AddressDataModel> getData(formData) async {
    final formData2 = formData;
    //final token = "invalid_token";
    final token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXRAeWFob28uY29tIiwiaWF0IjoxNTYzNzcxMDEyLCJleHAiOjE1NjYzNjMwMTJ9.c39YqxKYtdqi199Ivh_-7LPzTe8BC21xWtvcqv0TTck";
    // FLUTTER_WEB version is not working to store at present
    // TODO: enable this for android/ios version
//    final prefs = await SharedPreferences.getInstance();
//    final token = prefs.getInt('token') ?? "invalid_token";
    try {
      //print(formData.userid);
      final response = await client.post("$_baseUrl/getdata",
          headers: {"token": token}, body: formData2);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
//        print(response.body);
        return await AddressDataModel.fromJson(json.decode(response.body));
      }
    } catch (_) {
      return await AddressDataModel.fromJson(json.decode(serverFailed));
    }
    return await AddressDataModel.fromJson(json.decode(serverFailed));
  }
}
