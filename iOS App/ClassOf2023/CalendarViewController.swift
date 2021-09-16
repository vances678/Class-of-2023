//
//  CalendarViewController.swift
//  ClassOf2023
//
//  Created by Vance Spears on 8/5/21.
//

import UIKit
import WebKit

class CalendarViewController: UIViewController, WKNavigationDelegate {

    // Outlets
    @IBOutlet var webView: WKWebView!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!
    
    // Runs when view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup webView
        webView.navigationDelegate = self
        let url = URL(string: "https://calendar.google.com/calendar/embed?src=c_vq487522gqpf4ov6hsm22a9di8%40group.calendar.google.com&ctz=America%2FNew_York")
        webView.load(URLRequest(url: url!))
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
