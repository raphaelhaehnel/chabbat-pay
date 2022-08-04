class UserModel {
  final String name;
  final String mail;
  final int points;
  final List chabbats;

  UserModel({
    this.name = 'UNDEFINED',
    this.mail = 'UNDEFINED',
    this.points = 0,
    this.chabbats = const [],
  });

  UserModel.fromMap(Map<String, dynamic> user)
      : name = user['name'],
        mail = user['mail'],
        points = user['points'],
        chabbats = user['chabbats'];
}
