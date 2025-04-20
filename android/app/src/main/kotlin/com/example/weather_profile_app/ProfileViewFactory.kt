package com.example.weather_profile_app

import android.content.Context
import android.view.View
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import coil.request.ImageRequest
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

// Model for user profile data
data class UserProfileData(
    val name: String,
    val email: String,
    val profilePictureUrl: String
)

// Factory for creating the platform view
class ProfileViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as? Map<String, Any>
        return ProfilePlatformView(context, viewId, creationParams, messenger)
    }
}

// PlatformView implementation that hosts our Compose UI
class ProfilePlatformView(
    private val context: Context,
    id: Int,
    creationParams: Map<String, Any>?,
    private val messenger: BinaryMessenger
) : PlatformView {

    private val composeView: ComposeView = ComposeView(context)
    private val methodChannel = MethodChannel(messenger, "com.example.weather_profile/channel")
    init {
        setupComposeView()
    }

    private fun setupComposeView() {
        composeView.setContent {
            MaterialTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    ProfileScreen(
                        onSendDataClick = {
                            sendUserDataToFlutter()
                        }
                    )
                }
            }
        }
    }

    private fun sendUserDataToFlutter() {
        val userProfile = mapOf(
            "name" to "John Doe",
            "email" to "john.doe@example.com",
            "profilePicture" to "https://randomuser.me/api/portraits/men/1.jpg"
        )
        methodChannel.invokeMethod("getUserProfile", userProfile)
    }

    override fun getView(): View {
        return composeView
    }

    override fun dispose() {
        // Clean up resources if needed
    }

    @Composable
    fun ProfileScreen(onSendDataClick: () -> Unit) {
        val user = UserProfileData(
            name = "John Doe",
            email = "john.doe@example.com",
            profilePictureUrl = "https://randomuser.me/api/portraits/men/1.jpg"
        )

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "Profile",
                fontSize = 28.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.padding(vertical = 16.dp)
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Profile Image
            AsyncImage(
                model = ImageRequest.Builder(context)
                    .data(user.profilePictureUrl)
                    .crossfade(true)
                    .build(),
                contentDescription = "Profile Picture",
                modifier = Modifier
                    .size(120.dp)
                    .clip(CircleShape),
                contentScale = androidx.compose.ui.layout.ContentScale.Crop
            )

            Spacer(modifier = Modifier.height(24.dp))

            // Profile Information Card
            Card(
                modifier = Modifier.fillMaxWidth(),
                elevation = 4.dp
            ) {
                Column(
                    modifier = Modifier.padding(16.dp),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Name: ", fontWeight = FontWeight.Bold)
                        Text(user.name)
                    }

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Email: ", fontWeight = FontWeight.Bold)
                        Text(user.email)
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Button to send data to Flutter
            Button(
                onClick = onSendDataClick,
                modifier = Modifier
                    .fillMaxWidth()
                    .height(56.dp),
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(backgroundColor = Color(0xFF2196F3))
            ) {
                Text(
                    "Send Profile to Dashboard",
                    color = Color.White,
                    fontWeight = FontWeight.Bold
                )
            }
        }
    }
}