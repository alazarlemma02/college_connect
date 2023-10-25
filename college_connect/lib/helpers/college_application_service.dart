import 'package:flutter/foundation.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class CollegeApplicationService {
  static Future<void> sendApplication(
    List<String> collegeEmails,
    String formData,
  ) async {
    final smtpServer = gmail('owner_email@gmail.com', 'owner_password');

    final message = Message()
          ..from = const Address('owner_email@gmail.com', 'owner Name')
          ..subject = 'College Application'
          ..text = formData
        // ..attachments = [ Attachment]
        ;

    for (String collegeEmail in collegeEmails) {
      message.recipients.add(collegeEmail);

      try {
        final sendReport = await send(message, smtpServer);
        if (kDebugMode) {
          print('Message sent: $sendReport');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error sending message: $e');
        }
      }

      message.recipients.clear();
    }
  }
}
