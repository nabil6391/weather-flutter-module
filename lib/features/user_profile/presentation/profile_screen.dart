import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_profile_app/features/user_profile/domain/user_provider.dart';
import 'package:weather_profile_app/features/user_profile/presentation/widgets/native_profile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return const NativeProfileView();
        },
      ),
    );
  }
}
