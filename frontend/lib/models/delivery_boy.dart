class DeliveryBoy {
  final int id;
  final String username;
  final String? phoneNumber;
  final String? vehicleNumber;
  final bool available;

  DeliveryBoy({
    required this.id,
    required this.username,
    this.phoneNumber,
    this.vehicleNumber,
    required this.available,
  });

  factory DeliveryBoy.fromJson(Map<String, dynamic> json) {
    return DeliveryBoy(
      id: json['id'],
      username: json['user']['username'],
      phoneNumber: json['phone_number'],
      vehicleNumber: json['vehicle_number'],
      available: json['available'],
    );
  }
}

