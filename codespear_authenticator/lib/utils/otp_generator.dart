import 'package:otp/otp.dart';

class OTPGenerator {
  static String generateTOTPCode(String secret) {
    return OTP.generateTOTPCodeString(
      secret,
      DateTime.now().millisecondsSinceEpoch,
      length: 6,
      interval: 30,
    );
  }
}
