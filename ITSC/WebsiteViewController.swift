//
//  WebsiteViewController.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/18.
//

import UIKit
import SwiftSoup
import WebKit

class WebsiteViewController: UIViewController {
    var urlString: String = ""
    var dataPreloads: DataPreloads?
    var webView: WKWebView = WKWebView()
    @IBOutlet var childView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
        if (childView.subviews.isEmpty) {
            childView.addSubview(webView)
            childView.bringSubviewToFront(childView.subviews[0])
        }
        // Do any additional setup after loading the view.
        if let data = dataPreloads!.loadWebpage(urlString, webView: self) {
            webView.load(data, mimeType: "text/html", characterEncodingName: ".utf8", baseURL: URL(string: urlString)!)
        }
        else {
            NotificationCenter.default.addObserver(self, selector: #selector(loadWebpage), name: NSNotification.Name(rawValue: "websiteLoaded"), object: nil)
        }
    }
    
    @objc func loadWebpage(notification: NSNotification) {
        guard let data = dataPreloads!.loadWebpage(urlString, webView: self) else { return }
        DispatchQueue.main.async {
            self.webView.load(data, mimeType: "text/html", characterEncodingName: ".utf8", baseURL: URL(string: self.urlString)!)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
