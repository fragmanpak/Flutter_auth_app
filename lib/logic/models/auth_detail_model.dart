class AuthenticationDetailModel {
  final bool? isValid;
  final String? uid;
  final String? photoUrl;
  final String? email;
  final String? displayName;

  AuthenticationDetailModel({
    required this.isValid,
    this.uid,
    this.photoUrl,
    this.email,
    this.displayName,
  });

  AuthenticationDetailModel copyWith({
    bool? isValid,
    String? uid,
    String? photoUrl,
    String? email,
    String? displayName,
  }) {
    return AuthenticationDetailModel(
      isValid: isValid ?? this.isValid,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isValid': isValid,
      'uid': uid,
      'photoUrl': photoUrl,
      'email': email,
      'displayName': displayName,
    };
  }

  factory AuthenticationDetailModel.fromMap(Map<String, dynamic>? map) {
    return AuthenticationDetailModel(
      isValid: map?['isValid'],
      uid: map?['uid'],
      photoUrl: map?['photoUrl'],
      email: map?['email'],
      displayName: map?['displayName'],
    );
  }

}
