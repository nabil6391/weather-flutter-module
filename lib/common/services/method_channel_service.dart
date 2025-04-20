import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../../features/user_profile/models/user_profile.dart'; // Adjusted import path
import '../utils/constants.dart';

class MethodChannelService {
  static const MethodChannel _channel = MethodChannel(Constants.methodChannelName);

  static void setupUserProfileReceiver(Function(UserProfile) callback) {
    _channel.setMethodCallHandler((call) async {
      debugPrint("MethodChannelService: Received method call: ${call.method}");
      if (call.method == Constants.getUserProfileMethod) {
        if (call.arguments is Map) {
           final Map<String, dynamic> userData = Map<String, dynamic>.from(call.arguments as Map);
           final userProfile = UserProfile.fromJson(userData);
           callback(userProfile);
        } else {
           debugPrint('MethodChannelService: Received invalid arguments type for ${Constants.getUserProfileMethod}');
        }
      }
    });
  }

  static Future<void> sendFeedback(String message) async {
    try {
      await _channel.invokeMethod(Constants.sendFeedbackMethod, {'feedback': message});
      debugPrint('Feedback sent successfully: $message');
    } on PlatformException catch (e) {
      debugPrint('Error sending feedback: ${e.message}');
      if (e.code == 'MethodNotImplemented') {
         debugPrint('Native method ${Constants.sendFeedbackMethod} not implemented.');
      }
    } catch (e) {
      debugPrint('Unexpected error sending feedback: $e');
    }
  }
}