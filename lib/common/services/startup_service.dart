import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:weather_profile_app/features/user_profile/data/user_profile.dart';
import 'package:weather_profile_app/features/user_profile/domain/user_provider.dart';

import 'method_channel_service.dart';

/// Service to handle app startup tasks
class StartupService {
  /// Initialize method channel handlers and other cross-platform communication
  static void initializeNativeCommunication(context) {
    debugPrint('Initializing native communication...');

    // Set up method channel handler for receiving user profile from native
    MethodChannelService.setupUserProfileReceiver((UserProfile userProfile) {
      debugPrint('Received user profile from native: $userProfile');

      // Update the user provider with the profile data
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserProfile(userProfile);
    });
  }
}
