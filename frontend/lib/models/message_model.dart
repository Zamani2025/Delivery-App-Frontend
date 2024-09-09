class Message {
  final int id;
  final String message;
  final String createdAt;
  final Map? order;
  final Map? user;
  final Map? driver;

  Message(
      {required this.id,
      required this.message,
      required this.order,
      required this.user,
      required this.driver,
      required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        id: json['id'],
        message: json['message'],
        user: json['user'],
        order: json['order'],
        driver: json['driver'],
        createdAt: json['created_at']);
  }
}
