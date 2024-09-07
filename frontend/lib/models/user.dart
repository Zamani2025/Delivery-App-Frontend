class User {
  int? id;
  String? email;
  String? firstName;
  String? lastName;
  String? address;
  String? phone;
  String? userType;
  List? driverProfile;

  User(
      {this.address,
      this.lastName,
      this.firstName,
      this.id,
      this.userType,
      this.driverProfile,
      this.email,
      this.phone});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        address: json['data']['address'],
        driverProfile: json['data']['driver_profile'],
        userType: json['data']['user_type'],
        email: json['data']['email'],
        firstName: json['data']['first_name'],
        id: json['data']['id'],
        lastName: json['data']['last_name'],
        phone: json['data']['phone']);
  }
}
