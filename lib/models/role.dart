class Role {
  final String? id;
  final String? name;
  final int? usersCount;

  Role({required this.id, required this.name, this.usersCount = 0});

Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };


  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      usersCount: json['users_count'] ?? 0,
    );
  }
}

