// models/user_info.dart
class UserInfo {
  final String fullName;
  final String username;
  final String email;
  final String mobile;
  final String phone;
  final String profileImage;
  final String vehicle;
  final String language;
  final String location;
  final bool enabled; // ✅ Add this

  UserInfo({
    required this.fullName,
    required this.username,
    required this.email,
    required this.mobile,
    required this.phone,
    required this.profileImage,
    required this.vehicle,
    required this.language,
    required this.location,
    required this.enabled, // ✅ Add this
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile_no'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_img'] ?? '',
      vehicle: json['vehicle'] ?? '',
      language: json['language'] ?? '',
      location: json['location'] ?? '',
      enabled: json['enabled'] == 1 || json['enabled'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'email': email,
      'mobile_no': mobile,
      'phone': phone,
      'profile_img': profileImage,
      'vehicle': vehicle,
      'language': language,
      'location': location,
      'enabled': enabled,
    };
  }
}
