import 'package:flutter/foundation.dart';
import 'package:weather_profile_app/features/user_profile/data/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;

  UserProfile? get userProfile => _userProfile;

  void setUserProfile(UserProfile newUserProfile) {
    // Only update and notify if the profile has actually changed
    if (_userProfile != newUserProfile) {
      _userProfile = newUserProfile;
      debugPrint('User profile updated: $newUserProfile');
      notifyListeners();
    } else {
      debugPrint('User profile unchanged. No notification needed.');
    }
  }

  void clearUserProfile() {
    if (_userProfile != null) {
      _userProfile = null;
      debugPrint('User profile cleared.');
      notifyListeners();
    }
  }
}
