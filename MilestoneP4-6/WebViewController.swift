//
//  WebViewController.swift
//  MilestoneP4-6
//
//  Created by Mehmet Can Şimşek on 20.06.2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var selectedShoppingList = [String]()
    var webView: WKWebView!
    var webIndex = 0
    var webName = ["amazon.com/s?k=", "hepsiburada.com/ara?q=" ]
    var webSites = ["amazon.com", "hepsiburada.com"]
 
    
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(openTapped))
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.superview?.backgroundColor = .white

        //
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .plain, target: webView, action: #selector(webView.goForward))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [goBack, goForward, spacer, progressButton,  spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        //
     
        
        guard let url = URL(string: "https://www.amazon.com/s?k=\(selectedShoppingList[webIndex])") else {
            return  }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        
    }
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        for website in webName {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
    }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel ))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action : UIAlertAction) {
        guard let firstUrl = action.title else { return}
        guard let url = URL(string: "https://www." + firstUrl + "\(selectedShoppingList[webIndex])") else { return}
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
