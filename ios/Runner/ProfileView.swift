import SwiftUI
import Flutter

struct UserProfileData {
    let name: String
    let email: String
    let profilePictureURL: String
}

struct ProfileView: View {
    let userProfile: UserProfileData
    let sendDataCallback: () -> Void

    init(sendDataCallback: @escaping () -> Void) {
        // Mock user data
        self.userProfile = UserProfileData(
            name: "John Doe",
            email: "john.doe@example.com",
            profilePictureURL: "https://randomuser.me/api/portraits/men/1.jpg"
        )
        self.sendDataCallback = sendDataCallback
    }

    var body: some View {
        VStack {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            Spacer().frame(height: 20)

            // Profile Image
            AsyncImage(url: URL(string: userProfile.profilePictureURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 120, height: 120)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.bottom, 20)

            // Profile Information
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Name:")
                        .fontWeight(.bold)
                    Text(userProfile.name)
                }
                .padding(.horizontal)

                HStack {
                    Text("Email:")
                        .fontWeight(.bold)
                    Text(userProfile.email)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer().frame(height: 30)

            // Button to send data to Flutter
            Button(action: {
                self.sendDataCallback()
            }) {
                Text("Send Profile to Dashboard")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .padding()
           .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
                .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
    }
}

// Flutter Platform View Factory
class ProfileViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return ProfilePlatformView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }

    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

// Flutter Platform View
class ProfilePlatformView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var messenger: FlutterBinaryMessenger

    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
        _view = UIView()
        self.messenger = messenger
        super.init()

        setupProfileView(frame: frame)
    }

    private func setupProfileView(frame: CGRect) {
        // Create the method channel for sending data
        let methodChannel = FlutterMethodChannel(
            name: "com.example.weather_profile/channel",
            binaryMessenger: messenger
        )

        // Create a callback to send user data to Flutter
        let sendDataCallback = {
            let userProfile = [
                "name": "John Doe",
                "email": "john.doe@example.com",
                "profilePicture": "https://randomuser.me/api/portraits/men/1.jpg"
            ]
            methodChannel.invokeMethod("getUserProfile", arguments: userProfile)
        }

        // Create the SwiftUI view
       let swiftUIView = UIHostingController(rootView: ProfileView(sendDataCallback: sendDataCallback))

       // Add the SwiftUI view as a child view
       swiftUIView.view.frame = _view.bounds
       swiftUIView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

       _view.addSubview(swiftUIView.view)
    }

    func view() -> UIView {
        return _view
    }
}
