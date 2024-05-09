
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

        // Create a navigation item with a back button
        let navigationItem = UINavigationItem()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton

        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Add constraints for the navigation bar
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Adding web view
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsLinkPreview = true
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)

        // Add constraints for the web view
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
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
        if webView.url?.absoluteString.contains("page=detail") == true {
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
