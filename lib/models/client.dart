class Client {
  final String id;
  final String name;
  final String phone;

  Client({
    required this.id,
    required this.name,
    required this.phone,
  });
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'],
      phone: json['number'],
    );
  }
}