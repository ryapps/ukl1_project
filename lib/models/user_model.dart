class UserProfile {
  bool? status;
  String? message;
  int? id;
  String? nama_pelanggan;
  String? alamat;
  String? gender;
  String? telepon;

  UserProfile({
    this.status,
    this.message,
    this.id,
    this.nama_pelanggan,
    this.alamat,
    this.gender,
    this.telepon,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      status: json['status'],
      message: json['message'],
      id: json['id'],
      nama_pelanggan: json['nama_pelanggan'],
      alamat: json['alamat'],
      gender: json['gender'],
      telepon: json['telepon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "id": id,
      "nama_pelanggan": nama_pelanggan,
      "alamat": alamat,
      "gender": gender,
      "telepon": telepon,
    };
  }
}
