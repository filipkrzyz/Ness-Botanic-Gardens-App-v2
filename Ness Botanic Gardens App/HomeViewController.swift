//
//  HomeViewController.swift
//  Ness Botanic Gardens App
//
//  Created by Filip Krzyzanowski on 05/02/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import UIKit
import CoreData
import WebKit


// Home View is the initial screen on opening the app. It will display greetings and give the user chance to select some options from the tableView (like opening times, contact, etc)
// In the background on opening the App it will check for updates in the database and download data and save in Core Data

class HomeViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    var offline: Bool = false
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // check for connectivity, display loading why loading 
        let myRequest = URLRequest(url: nessURL)
        webView.load(myRequest)
        
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load the page: ", error)
        webView.load(URLRequest(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Ness", ofType: "html")!)))
    }

}


