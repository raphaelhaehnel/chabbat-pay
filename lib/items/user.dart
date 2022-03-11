class User {
  User({this.name = 'null', this.credit = -1, this.uuid = '0'}) {
    print('this is the constructor');
  }

  final String uuid;
  final String name;
  final double credit;

  // void pay(double n) {
  //   credit -= n;
  // }
}
