class Setting {
  String companyName;
  String address;
  String phone;
  String email;

  Setting({
    required this.companyName,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      companyName: json['company_name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}