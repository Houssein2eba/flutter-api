import 'package:demo/models/permission.dart';

class Role {
  final String? id;
  final String? name;
  final int? usersCount;
  final List<Permission>? permissions;

  Role({required this.id, required this.name, this.usersCount = 0, this.permissions});

Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    
  };


  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      usersCount: json['users_count'] ?? 0,
      permissions: (json['permissions'] as List<dynamic>?)?.map((permission) => Permission.fromJson(permission)).toList(),
    );
  }
}

