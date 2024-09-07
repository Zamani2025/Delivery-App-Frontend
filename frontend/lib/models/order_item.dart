class Order {
  final int id;
  final String orderId;
  final String packageDetails;
  final String deliveryAddress;
  final String ppickupAddress;
  final String receiverName;
  final String receiverPhone;
  final String status;
  final String createdAt;
  final Map? driver;

  Order(
      {required this.id,
      required this.orderId,
      required this.packageDetails,
      required this.ppickupAddress,
      required this.receiverName,
      required this.receiverPhone,
      required this.deliveryAddress,
      required this.status,
      required this.driver,
      required this.createdAt});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        orderId: json['order_id'],
        receiverName: json['receiver_name'],
        receiverPhone: json['receiver_phone'],
        ppickupAddress: json['pickup_address'],
        deliveryAddress: json['delivery_address'],
        status: json['status'],
        packageDetails: json['package_details'],
        driver: json['driver'],
        createdAt: json['created_at']);
  }
}
