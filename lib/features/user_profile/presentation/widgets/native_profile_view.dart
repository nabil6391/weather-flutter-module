import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeProfileView extends StatelessWidget {
  const NativeProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use different platform views for iOS and Android
    if (Platform.isAndroid) {
      return _buildAndroidView();
    } else if (Platform.isIOS) {
      return _buildIOSView();
    } else {
      // Fallback for other platforms or web
      return Center(
        child: Text(
          'Native profile view is not supported on ${Platform.operatingSystem}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
  }

  Widget _buildAndroidView() {
    // The view type must match the one registered in the Android code
    const String viewType = 'profile-view';

    // Pass parameters to the platform side if needed
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  Widget _buildIOSView() {
    // The view type must match the one registered in the iOS code
    const String viewType = 'profile-view';

    // Pass parameters to the platform side if needed
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    // Optional callback when the platform view is created
    debugPrint('Native profile view created with id: $id');
  }
}
