class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  UserModel({required this.uid, this.displayName, this.email, this.photoUrl});

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }
}
