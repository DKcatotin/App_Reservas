//generar ids unicos
class IdGenerator {
  static String generate(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}
