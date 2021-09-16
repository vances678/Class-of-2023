//
//  HubViewController.swift
//  ClassOf2023
//
//  Created by Vance Spears on 8/5/21.
//

import UIKit
import WebKit

class HubViewController: UIViewController, WKNavigationDelegate {

    // Outlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!
        
    // Runs when view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup webView
        webView.navigationDelegate = self
        let url = URL(string: "https://sites.google.com/hotchkiss.org/hub")
        webView.load(URLRequest(url: url!))
    }
    
    // Waits 0.5 seconds after page loads, then changes target of all links to "_self" so they open in the same tab
    // (Before, certain links had target="_blank" so they opened in a new tab (but WKWebView could not handle this and therefore did not open link))
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("setTimeout(() => {for (object of Array.from(document.links)) {object.target='_self'}}, 500)")
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestURL = navigationAction.request.url?.absoluteString ?? "" // url to load
        let approvedURLParts = ["www.google.com/url?q=", "docs.google.com"] // start of urls to be whitelisted
        // The following code fixes certain redirect links and embeds that would not load when clicked
        // For each url part in the above array, the loop checks:
        //   - If the request url contains the approved url part
        //   - If the request url is not equal to the current url (caused infinite loading without check)
        //   - If the user clicked on the link (otherwise embeds loaded by the website load in full screen when page loads)
        // If the checks are passed, the url is loaded
        for part in approvedURLParts {
            if requestURL.contains(part) && requestURL != webView.url?.absoluteString && navigationAction.navigationType.rawValue == 0 {
                webView.load(URLRequest(url: navigationAction.request.url!))
            }
        }
        // The following code deals with embedded videos from google drive that only load horizontally by prompting user to rotate device
        if requestURL.contains("clients6.google.com") && requestURL.contains("sites.google.com") && !UIDevice.current.orientation.isLandscape {
            if self.presentedViewController == nil {
                let alert = UIAlertController(title: "Please rotate device to horizontal to view video", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        decisionHandler(.allow) // Allows navigation to occur
    }
    
    // Toggles navigation buttons on page load
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        toggleNavButtons()
    }
    
    // Toggles navigation buttons (forward/back buttons)
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
    
    // Setup back button
    @IBAction func back(_ sender: Any) {
        webView.goBack()
    }
    
    // Setup forward button
    @IBAction func forward(_ sender: Any) {
        webView.goForward()
    }
    
    // Setup reload button
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
    
    // Setup share button (opens share sheet for current url)
    @IBAction func share(_ sender: Any) {
        if let url = webView.url {
            let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

