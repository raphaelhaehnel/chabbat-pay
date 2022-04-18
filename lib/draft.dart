import 'dart:math';

generate_id(int n) {
  var random = Random();
  String id = '';
  for (int i = 0; i < n; i++) {
    String digit = random.nextInt(9).toString();
    id += digit;
  }
  return id;
}

main() {
  print(generate_id(6));
}
