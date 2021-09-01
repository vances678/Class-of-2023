//
//  HubViewController.swift
//  ClassOf2023
//
//  Created by Vance Spears on 8/5/21.
//

import UIKit
import WebKit

class HubViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!
    
    var shouldLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: "https://sites.google.com/hotchkiss.org/hub")
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
        toggleNavButtons()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
        print(error)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        print(navigationAction.request.url!)
        print(webView.url!)
        if navigationAction.request.url == URL(string: "https://www.google.com/url?q=https%3A%2F%2Fsites.google.com%2Fhotchkiss.org%2Fart-club&sa=D&sntz=1&usg=AFQjCNEe9OGh_BZ42mn6jzMie4HPUBdKqA") {
            if shouldLoad {
                webView.load(URLRequest(url: navigationAction.request.url!))
                shouldLoad = false
            }
        }
        decisionHandler(.allow)
    }
    
    func toggleNavButtons() {
        if webView.canGoBack {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
    }
    
    @IBAction func back(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func forward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func share(_ sender: Any) {
        if let url = webView.url {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
