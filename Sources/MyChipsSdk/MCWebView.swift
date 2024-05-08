
import Foundation

import UIKit
import WebKit

public class MCWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!
    var adunitId: String
    var onClose: (() -> Void)?
        
    public init(adunitId: String, onClose: (() -> Void)?) {
        self.adunitId = adunitId
        self.onClose = onClose
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView(
    ) {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        // Adding top bar
        let topBar = UIToolbar()
        topBar.translatesAutoresizingMaskIntoConstraints = false
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        topBar.items = [backButton, flexibleSpace]
        view.addSubview(topBar)

        // Add constraints for the top bar
        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Adding web view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)

        // Add constraints for the web view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Load web content
        let url = Constants.webBaseURL.appendingQueryItems(
            [
                URLQueryItem(name: "adunit_id", value: adunitId),
                URLQueryItem(name: "user_id", value: MCOfferwallSDK.getUserId()),
                URLQueryItem(name: "sdk", value: "ios")
            ]
        )!

        let request = URLRequest(url: url)
        webView.load(request)
    }

    @objc func backButtonTapped() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            onClose?()
        }
    }


//    @IBAction func swipeback(_ sender: UISwipeGestureRecognizer) {
//        print("back")
////        navigationController?.popToRootViewController(animated: true)
//    }
    
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString {
            if url.starts(with: "mychips://") {
                decisionHandler(.cancel)
                return
            }
            
            if url.starts(with: "https://api.mychips.io") && url.contains("redirect") {
                UIApplication.shared.open(navigationAction.request.url!)
                RateLimitService.resetSlidingWindow(methodName: Constants.balanceMethodName)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }

}
