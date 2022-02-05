class User {
  User({this.name = 'null', this.credit = -1}) {
    print('this is the constructor');
  }

  final String name;
  final double credit;

  // void pay(double n) {
  //   credit -= n;
  // }
}
