//
//  SuggestionsViewController.swift
//  ClassOf2023
//
//  Created by Vance Spears on 8/5/21.
//

import UIKit
import WebKit

class SuggestionsViewController: UIViewController, WKNavigationDelegate {

    // Outlets
    @IBOutlet var webView: WKWebView!
    
    // Runs when view first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup webView
        webView.navigationDelegate = self
        let url = URL(string: "https://forms.gle/FtpLmUhh1UiAhuhAA")
        webView.load(URLRequest(url: url!))
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
