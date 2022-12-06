

import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';

class VerifyEmailResponse{
  final bool success;
  final String error;
  final String code;
  final String emailSentTo;

  VerifyEmailResponse({ this.success=false,  this.error="",  this.code="", this.emailSentTo=""});


 bool get  failed => error.isNotEmpty || success == false;

  bool get  succeeded => error.isEmpty || success == true;

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'error': error,
      'code': code,
      'emailSentTo': emailSentTo,
    };
  }

  factory VerifyEmailResponse.fromMap(Map<String, dynamic> map) {
    return VerifyEmailResponse(
      success: map['success']??false,
      error: map['error']??'',
      code: map['code']??'',
      emailSentTo: map['emailSentTo']??'',
    );
  }


  String onErrorMessage(){
    if(error ==  'code-invalid-or-expired'){
      return 'The code you gave is either invalid or expired';
    }else{
      return "Something went wrong, please try resending new code";
    }
  }

  void announceError(){
    FeedbackService.announce(
        notification: AppNotification(
            title: onErrorMessage(),
            stack: error,
            appWide: true,
            message: "please try resending the link again",
            type: NotificationType.error));
  }
}