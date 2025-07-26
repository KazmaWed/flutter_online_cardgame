abstract class BaseResponse {
  final bool success;

  BaseResponse({required this.success});
}

class ApiError {
  final String code;
  final String message;

  ApiError({required this.code, required this.message});

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['code'] as String? ?? 'UNKNOWN',
      message: json['message'] as String? ?? 'Unknown error',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message)';
  }
}

class ErrorResponse extends BaseResponse {
  final ApiError error;

  ErrorResponse({required this.error}) : super(success: false);

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: ApiError.fromJson(json['error'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': false,
      'error': error.toJson(),
    };
  }
}

enum ApiErrorCode {
  unauthenticated,
  invalidArgument,
  notFound,
  permissionDenied,
  failedPrecondition,
  resourceExhausted,
  deadlineExceeded,
  alreadyExists,
  internal,
  unknown
}

extension ApiErrorCodeExtension on ApiErrorCode {
  String get value {
    switch (this) {
      case ApiErrorCode.unauthenticated:
        return 'UNAUTHENTICATED';
      case ApiErrorCode.invalidArgument:
        return 'INVALID_ARGUMENT';
      case ApiErrorCode.notFound:
        return 'NOT_FOUND';
      case ApiErrorCode.permissionDenied:
        return 'PERMISSION_DENIED';
      case ApiErrorCode.failedPrecondition:
        return 'FAILED_PRECONDITION';
      case ApiErrorCode.resourceExhausted:
        return 'RESOURCE_EXHAUSTED';
      case ApiErrorCode.deadlineExceeded:
        return 'DEADLINE_EXCEEDED';
      case ApiErrorCode.alreadyExists:
        return 'ALREADY_EXISTS';
      case ApiErrorCode.internal:
        return 'INTERNAL';
      case ApiErrorCode.unknown:
        return 'UNKNOWN';
    }
  }

  static ApiErrorCode fromString(String value) {
    switch (value) {
      case 'UNAUTHENTICATED':
        return ApiErrorCode.unauthenticated;
      case 'INVALID_ARGUMENT':
        return ApiErrorCode.invalidArgument;
      case 'NOT_FOUND':
        return ApiErrorCode.notFound;
      case 'PERMISSION_DENIED':
        return ApiErrorCode.permissionDenied;
      case 'FAILED_PRECONDITION':
        return ApiErrorCode.failedPrecondition;
      case 'RESOURCE_EXHAUSTED':
        return ApiErrorCode.resourceExhausted;
      case 'DEADLINE_EXCEEDED':
        return ApiErrorCode.deadlineExceeded;
      case 'ALREADY_EXISTS':
        return ApiErrorCode.alreadyExists;
      case 'INTERNAL':
        return ApiErrorCode.internal;
      default:
        return ApiErrorCode.unknown;
    }
  }
}