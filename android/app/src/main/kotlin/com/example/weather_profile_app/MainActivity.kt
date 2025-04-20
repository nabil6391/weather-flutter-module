package com.example.weather_profile_app

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.example.weather_profile/channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // Register the ProfileViewFactory with the messenger
        flutterEngine.platformViewsController.registry
            .registerViewFactory("profile-view", ProfileViewFactory(flutterEngine.dartExecutor.binaryMessenger))

        // Setup method channel
        setupMethodChannel(flutterEngine)
    }

    private fun setupMethodChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUserProfile" -> {
                    // Return mock user profile data

                    val userProfile = mapOf(
                        "name" to "John Doe",
                        "email" to "john.doe@example.com",
                        "profilePicture" to "https://randomuser.me/api/portraits/men/1.jpg"
                    )
                    result.success(userProfile)
                }
                "sendFeedback" -> {
                    val feedback = call.argument<String>("feedback")
                    if (feedback != null) {
                        // Show feedback in native context
                        showFeedbackAlert(feedback)
                        result.success(true)
                    } else {
                        result.error("INVALID_ARGUMENT", "Feedback text is required", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun showFeedbackAlert(feedback: String) {
        // Create an AlertDialog to display the feedback
        val builder = android.app.AlertDialog.Builder(this)
        builder.setTitle("Feedback Received")
        builder.setMessage(feedback)
        builder.setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }

        // Show the dialog on the UI thread
        runOnUiThread {
            builder.create().show()
        }
    }
}