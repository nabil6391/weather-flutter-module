import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_profile_app/common/services/method_channel_service.dart';
import 'package:weather_profile_app/common/utils/constants.dart';
import 'package:weather_profile_app/features/dashboard/domain/weather_provider.dart';
import 'package:weather_profile_app/features/dashboard/presentation/widgets/weather_card.dart';
import 'package:weather_profile_app/features/user_profile/domain/user_provider.dart';
import 'package:weather_profile_app/features/user_profile/presentation/widgets/user_profile_card.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final FocusNode _feedbackFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _feedbackFocusNode.dispose();
    super.dispose();
  }

  void _fetchWeatherData() {
    if (mounted) {
      Provider.of<WeatherProvider>(context, listen: false)
          .fetchWeather(Constants.defaultCity);
    }
  }

  // Helper method to send feedback
  void _sendFeedback() {
    final feedbackText = _feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      // Dismiss keyboard
      _feedbackFocusNode.unfocus();

      MethodChannelService.sendFeedback(feedbackText).then((_) {
        // Clear the text field on success
        _feedbackController.clear();
        // Show confirmation message
        if (mounted) {
          // Check if widget is still in the tree
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback sent successfully!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }).catchError((error) {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send feedback: $error'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } else {
      // Optionally show a message if feedback is empty
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter feedback before sending.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    if (userProvider.userProfile != null) {
                      return UserProfileCard(
                          userProfile: userProvider.userProfile!);
                    } else {
                      return const Center(
                          child: Text('No user profile data available.'));
                    }
                  },
                ),

                const SizedBox(height: 16), // Spacing

                Consumer<WeatherProvider>(
                  builder: (context, weatherProvider, child) {
                    if (weatherProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (weatherProvider.error != null) {
                      return _buildErrorWidget(weatherProvider.error!);
                    } else if (weatherProvider.weather != null) {
                      return WeatherCard(weather: weatherProvider.weather!);
                    } else {
                      return const Center(
                          child: Text('No weather data available.'));
                    }
                  },
                ),

                const SizedBox(height: 24), // Spacing

                _buildFeedbackForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String errorMsg) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error fetching weather:\n$errorMsg',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[800]),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchWeatherData, // Retry button
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Card(
      margin: const EdgeInsets.only(top: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send Feedback to Native',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              focusNode: _feedbackFocusNode,
              // Assign focus node
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _sendFeedback(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _sendFeedback,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ), // Call the helper method
              child: const Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
