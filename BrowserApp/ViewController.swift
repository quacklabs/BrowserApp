//
//  ViewController.swift
//  BrowserApp
//
//  Created by Sprinthub on 08/02/2019.
//  Copyright © 2019 Sprinthub Mobile. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!

    //arry of allowed sites
    var websites = ["apple.com", "hackingwithswift.com", "facebook.com"]

    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        //define our URL here
        let url = URL(string: "https://www." + websites[0])!
        
        //load it into the webview
        webView.load(URLRequest(url: url))
        
        //allow navigation and history
        webView.allowsBackForwardNavigationGestures = true
        
        
        //add observer to webview and update progress bar accordingly.
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        
        //set button on top navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        //set progressbar
        progressView = UIProgressView(progressViewStyle: .default)
        //automatically size progress bar to screen
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        //buttons on bottom navigation bar
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        
        for website in websites{
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://www." + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host{
            for website in websites{
                if host.contains(website){
                    //print(website)
                    decisionHandler(.allow)
                    return
                }
            }
            //print(url?.host)
        }
        
        decisionHandler(.cancel)
    }

}

