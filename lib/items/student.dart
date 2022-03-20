class Student {
  Student({this.name = 'null', this.credit = -1, this.uid = '0'}) {
    print('this is the constructor');
  }

  final String uid;
  final String name;
  final double credit;

  // void pay(double n) {
  //   credit -= n;
  // }
}
