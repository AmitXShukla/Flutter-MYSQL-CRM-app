class DBDataModel {
  final int num_rows;
  final bool error;
  final String message;
  final List<dynamic> data;
  const DBDataModel({this.num_rows, this.error, this.message, this.data});
  factory DBDataModel.fromJson(Map<String, dynamic> json) {
    return DBDataModel(
        num_rows: json['num_rows'],
        error: json['error'],
        message: json['message'],
        data: json['data']
            .map((value) => new UserModel.fromJson(value))
            .toList());
  }
}

class AddressDataModel {
  final int num_rows;
  final bool error;
  final String message;
  final List<dynamic> data;
  const AddressDataModel({this.num_rows, this.error, this.message, this.data});
  factory AddressDataModel.fromJson(Map<String, dynamic> json) {
    return AddressDataModel(
        num_rows: json['num_rows'],
        error: json['error'],
        message: json['message'],
        data: json['data']
            .map((value) => new AddressBookModel.fromJson(value))
            .toList());
  }
}

class UserModel {
  final String userid;
  final String name;
  final String jwttoken;
  final String createdAt;
  final String updatedAt;
  final String role;

  const UserModel(
      {this.userid,
      this.name,
      this.jwttoken,
      this.createdAt,
      this.updatedAt,
      this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userid: json['userid'],
        name: json['name'],
        jwttoken: json['jwttoken'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        role: json['role']);
  }
  factory UserModel.toJson(Map<String, dynamic> json) {
    return UserModel(
      userid: json['userid'],
      name: json['name'],
      jwttoken: json['jwttoken'],
    );
  }
}

class AddressBookModel {
  final int addressid;
  final String first_name;
  final String middle_name;
  final String last_name;
  final String address;
  final String city;
  final String country;
  final String zip_code;
  final String emailid1;
  final String emailid2;
  final String phone1;
  final String phone2;
  final String createdAt;
  final String updatedAt;

  const AddressBookModel(
      {this.addressid,
      this.first_name,
      this.middle_name,
      this.last_name,
      this.address,
      this.city,
      this.country,
      this.zip_code,
      this.emailid1,
      this.emailid2,
      this.phone1,
      this.phone2,
      this.createdAt,
      this.updatedAt});

  factory AddressBookModel.fromJson(Map<String, dynamic> json) {
    return AddressBookModel(
        addressid: json['addressid'],
        first_name: json['first_name'],
        middle_name: json['middle_name'],
        last_name: json['last_name'],
        address: json['address'],
        city: json['city'],
        country: json['country'],
        zip_code: json['zip_code'],
        emailid1: json['emailid1'],
        emailid2: json['emailid2'],
        phone1: json['phone1'],
        phone2: json['phone2'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
  factory AddressBookModel.toJson(Map<String, dynamic> json) {
    return AddressBookModel(
        addressid: json['addressid'],
        first_name: json['first_name'],
        middle_name: json['middle_name'],
        last_name: json['last_name'],
        address: json['address'],
        city: json['city'],
        country: json['country'],
        zip_code: json['zip_code'],
        emailid1: json['emailid1'],
        emailid2: json['emailid2'],
        phone1: json['phone1'],
        phone2: json['phone2'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
