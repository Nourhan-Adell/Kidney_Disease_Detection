class UserModel {
  String? email;
  String? role;
  String? uid;
  String? name;
  String? number;

// receiving data
  UserModel({this.uid, this.email, this.role, this.name, this.number});
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      role: map['role'],
      name: map['name'],
      number: map['number'],
    );
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'name': name,
      'number': number,
    };
  }
}
