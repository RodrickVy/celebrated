import 'package:celebrated/support/models/app.error.code.dart';

class ErrorReport {
  final ResponseCode code;
  final String message;
  final String stack;
  final String solutions;
  final int timestamp;
  final String route;
  final String uid;

  ErrorReport(
      {required this.solutions,
      required this.message,
      required this.code,
      required this.route,
        required this.uid,
      required this.stack,
      required this.timestamp});

  ErrorReport copyWith({
    ResponseCode? code,
    String? message,
    String? stack,
    String? solutions,
    int? timestamp,
    String? route,
    String? uid,
  }) {
    return ErrorReport(
      code: code ?? this.code,
      message: message ?? this.message,
      stack: stack ?? this.stack,
      solutions: solutions ?? this.solutions,
      timestamp: timestamp ?? this.timestamp,
      route: route ?? this.route,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'stack': stack,
      'solutions': solutions,
      'timestamp': timestamp,
      'route': route,
      'uid': uid,
    };
  }

  factory ErrorReport.fromMap(Map<String, dynamic> map) {
    return ErrorReport(
      code: map['code'] as ResponseCode,
      message: map['message'] as String,
      stack: map['stack'] as String,
      solutions: map['solutions'] as String,
      timestamp: map['timestamp'] as int,
      route: map['route'] as String,
      uid: map['uid'] as String,
    );
  }
}
