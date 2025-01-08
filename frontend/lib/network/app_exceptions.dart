class AppException implements Exception {
  final String message;
  final String prefix;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return '$prefix: $message';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message ?? 'Failed to fetch data', 'Fetch Data Exception');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message ?? 'Invalid request', 'Bad Request Exception');
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message ?? 'Unauthorized access', 'Unauthorized Exception');
}

class NotFoundException extends AppException {
  NotFoundException([String? message])
      : super(message ?? 'Resource not found', 'Not Found Exception');
}

class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
      : super(message ?? 'Internal server error', 'Internal Server Error Exception');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message ?? 'Invalid input', 'Invalid Input Exception');
}