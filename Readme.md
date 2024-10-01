
# Install SDK

## 1. Introduction

This guide provides a comprehensive walkthrough for integrating the MyChips SDK into your iOS application, enabling the display of an engaging offerwall.

## 2. SDK Integration

In your project in Xcode, go to File -> Add Package Dependencies and then add the dependency using the following repo: `https://github.com/myappfree/mychips-ios-sdk`.

Now in your project, you can import the SDK:

```swift
import MyChipsSdk
```

## 3. Initializing the SDK

Before using the SDK or showing the offerwall, you must initialize it. You can optionally set a `userId`:

```swift
MCOfferwallSDK.shared.configure(apiKey: apiKey, userId: userId)
```

If the `userId` is not set, it will be generated automatically and used until manually set:

```swift
MCOfferwallSDK.shared.setUserId(userId: "YOUR_USER_ID")
```

Obtain your API key and User ID from [Universal Developer Portal](https://dashboard.maf.ad/Account/Login).

## 4. Displaying the Offerwall

To display the offerwall, we provide you with a `UIViewController` which you can integrate into either UIKit or a SwiftUI project.

To show the offerwall, you need to provide your `AdUnitId` and a closure to close the offerwall:

### UIKit Example

```swift
import UIKit
import MyChipsSdk

class ViewController: UIViewController {
    
    let adunitId = "YOUR_AD_UNIT_ID"
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let showOfferwallButton = UIButton(type: .system)
        showOfferwallButton.setTitle("Show Offerwall", for: .normal)
        showOfferwallButton.translatesAutoresizingMaskIntoConstraints = false
        showOfferwallButton.addTarget(self, action: #selector(showOfferwall), for: .touchUpInside)
        self.view.addSubview(showOfferwallButton)
    
        NSLayoutConstraint.activate([
            showOfferwallButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showOfferwallButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showOfferwallButton.widthAnchor.constraint(equalToConstant: 200),
            showOfferwallButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func showOfferwall() {
        let webViewController = MCWebViewController(adunitId: adunitId)
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
}
```

### SwiftUI Example

For SwiftUI, we first need to wrap the `UIViewController`:

```swift
struct WebViewWrapper: UIViewControllerRepresentable {
    let adunitId: String
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let webViewController = MCWebViewController(
            adunitId: adunitId,
            onClose: {
                presentationMode.wrappedValue.dismiss()
            }
        )
        
        return UINavigationController(rootViewController: webViewController)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
```

Now we use the wrapper in our view. Since we will use it in a `NavigationView`, we hide the default back button because the offerwall provides its own:

```swift
struct WebViewPage: View {
    var body: some View {
        WebViewWrapper(
            adunitId: "YOUR_AD_UNIT_ID"
        ).navigationBarBackButtonHidden()
    }
}
```

Now we can add this page to our `NavigationView` and show the offerwall on a button press:

```swift
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: WebViewPage()) {
                    Text("Open Offerwall")
                }
            }
        }
    }
}
```

Your Ad unit ID can be found [here](https://dashboard.maf.ad/Account/Login).

## 5. Reward User

### Fully Managed by MyChips

> **Warning:** Use this method only if you have selected Self-Managed Currency. If you already support S2S postback, please skip this snippet.

To check for a reward, use the `getReward` function. It requires your `adunitId`, a reward callback (which will be called if there is a reward), and an error callback.


```swift
MCOfferwallSDK.shared.getReward(adunitId: "YOUR_AD_UNIT_ID") { reward in
        //do something with the reward, here we just print it
        print(reward.virtualCurrencyReward)
    } onError: { error in
        //do something with the error, here we just print it
        print(error)
    }
```

> If there is no reward and no error, nothing will happen

You should check for the reward whenever the app is started or resumed. Example integration:

#### UIKit Example

```swift
import UIKit
import MyChipsSdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var firstActive = true

    func sceneDidBecomeActive(_ scene: UIScene) {
        if firstActive {
            // At the app start, initialize the SDK
            MCOfferwallSDK.shared.configure(apiKey: "YOUR_API_KEY")
            // Optionally set user ID
            MCOfferwallSDK.shared.setUserId(userId: "YOUR_USER_ID")
            firstActive = false
        }

        // On start or resume, check the reward
        MCOfferwallSDK.shared.getReward(adunitId: "YOUR_AD_UNIT_ID") { reward in
            print(reward.virtualCurrencyReward)
        } onError: { error in
            print(error)
        }
    }
    
    // Other SceneDelegate functions...
}
```

#### SwiftUI Example

You can handle rewards in SwiftUI using the `scenePhase` environment value:

```swift
import SwiftUI
import MyChipsSdk

@main
struct MyChipsSdkSwiftUIExampleApp: App {
    @Environment(\.scenePhase) var scenePhase
    @State private var firstActive = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase, perform: { phase in
                    if phase == .active {
                        if firstActive {
                            // Initialize your SDK on the app start
                            MCOfferwallSDK.shared.configure(apiKey: "YOUR_API_KEY")
                            // Optionally set user id
                            MCOfferwallSDK.shared.setUserId(userId: "YOUR_USER_ID")
                            firstActive = false
                        }
                        
                        // On start or resume, check the reward
                        MCOfferwallSDK.shared.getReward(
                            adunitId: "YOUR_AD_UNIT_ID") { reward in
                                print(reward.virtualCurrencyReward)
                            } onError: { error in
                                print(error)
                            }
                    }
                })
        }
    }
}
```

### Server-to-Server (S2S) Postbacks

If you prefer server-to-server communication, MyChips can send a postback to your server with bonus information. The configuration for postbacks is available in your publisher dashboard. This method is useful for validating and securely rewarding users without client-side manipulation.
