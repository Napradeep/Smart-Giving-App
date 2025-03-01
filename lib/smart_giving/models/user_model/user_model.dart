class UserModel {
  String id;
  String name;

  String contact;
  String monbileno;
  String password;
  String userType;
  String? deviceToken;

  UserModel({
    required this.id,
    required this.name,

    required this.contact,
    required this.monbileno,
    required this.password,
    required this.userType,
    this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'mobileno': monbileno,
      'password': password,
      'userType': userType,
      'deviceToken': deviceToken,
      if (userType == "DONOR") 'donorId': "D${monbileno.substring(0, 3)}",
    };
  }
}
