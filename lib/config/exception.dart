

class HTTPException implements Exception {
  HTTPException({
    required this.code,
    this.message,
  });

  final int code;
  final String? message;

  @override
  String toString() {
    return 'HTTPException{code: $code, message: $message}';
  }
}