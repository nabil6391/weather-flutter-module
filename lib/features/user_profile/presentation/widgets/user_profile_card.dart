import 'package:flutter/material.dart';
import 'package:weather_profile_app/features/user_profile/data/user_profile.dart';

class UserProfileCard extends StatelessWidget {
  final UserProfile userProfile;

  const UserProfileCard({
    Key? key,
    required this.userProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider? backgroundImage;
    Widget? fallbackIcon;

    if (userProfile.profilePicturePath != null &&
        userProfile.profilePicturePath!.isNotEmpty) {
      // Check if it's a network URL or a local asset/file path if necessary
      // Assuming network image for simplicity
      if (Uri.tryParse(userProfile.profilePicturePath!)?.hasAbsolutePath ??
          false) {
        backgroundImage = NetworkImage(userProfile.profilePicturePath!);
      } else {
        debugPrint(
            "Invalid profile picture URL: ${userProfile.profilePicturePath}");
        // Optionally: backgroundImage = FileImage('assets/default_avatar.png');
        fallbackIcon = const Icon(Icons.person,
            size: 40, color: Colors.white); // Fallback icon inside CircleAvatar
      }
    } else {
      fallbackIcon = const Icon(Icons.person,
          size: 40, color: Colors.white); // Default icon
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2, // Subtle elevation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              // Background color when no image
              backgroundImage: backgroundImage,
              // Show fallback icon if backgroundImage is null or loading fails
              onBackgroundImageError: backgroundImage != null
                  ? (dynamic exception, StackTrace? stackTrace) {
                      debugPrint("Error loading profile image: $exception");
                      // setState is not applicable here, rely on fallbackIcon provided below
                    }
                  : null,
              child: backgroundImage == null
                  ? fallbackIcon
                  : null, // Show icon if no image
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${userProfile.name}',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userProfile.email,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis, // Handle long emails
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
