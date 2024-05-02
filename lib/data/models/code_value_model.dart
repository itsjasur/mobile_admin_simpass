class CodeValue {
  final String cd;
  final String value;

  CodeValue({
    required this.cd,
    required this.value,
  });

  factory CodeValue.fromJson(Map<String, dynamic> map) {
    return CodeValue(
      cd: map['cd'] ?? '',
      value: map['value'] ?? '',
    );
  }
}
