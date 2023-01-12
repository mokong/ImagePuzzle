//
//  ImagePuzzlePuzzleBaseWebVC.swift
//  ImageMemorize
//
//  Created by MorganWang on 27/12/2022.
//

import UIKit
import WebKit

class ImagePuzzlePuzzleBaseWebVC: UIViewController {
    
    // MARK: - properties
    var webView: WKWebView?
    var urlStr: String?
    
    // MARK: - view life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tempBtn = UIButton(type: UIButton.ButtonType.custom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tempLabel = UILabel()
        tempLabel.font = UIFont.custom.courierFont
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        setupSubviews()
        load(urlStr: urlStr)
    }
    
    deinit {
        let classStr = NSStringFromClass(self.classForCoder)
        print(classStr, "deinit")
    }
    
    // MARK: - init
    fileprivate func setupSubviews() {
        let webConfigure = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: webConfigure)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        self.view.addSubview(webView!)
    }
    
    // MARK: - utils
    func load(urlStr: String?) {
        guard let str = urlStr,
              let url = URL(string: str) else {
                  return
              }
        
        webView?.load(URLRequest(url: url))
    }
    
    // MARK: - action
    
    
    // MARK: - other
    

}

extension ImagePuzzlePuzzleBaseWebVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        view.makeToastActivity(view.center)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.hideToastActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        view.hideToastActivity()
    }
}
