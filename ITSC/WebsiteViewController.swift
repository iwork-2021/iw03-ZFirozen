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
        if (view.frame.width > view.frame.height) {
            webView = WKWebView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width - 85, height: view.frame.height))
        } else {
            webView = WKWebView(frame: CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: view.frame.height))
        }
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
        // NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func receivedRotation() {
        var frameWidth = view.frame.width
        var frameHeight = view.frame.height
        var x = view.frame.origin.x
        var y = view.frame.origin.y
        print(frameWidth, frameHeight, x, y, "\n")
        
        switch UIDevice.current.orientation{
        case .portrait: if frameWidth > frameHeight {
            frameWidth = view.frame.height
            frameHeight = view.frame.width
            x = view.frame.origin.y
            y = view.frame.origin.x
        }
        case .portraitUpsideDown: if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return
        } else {
            if frameWidth > frameHeight {
                frameWidth = view.frame.height
                frameHeight = view.frame.width
                x = view.frame.origin.y
                y = view.frame.origin.x
            }
        }
        case .landscapeLeft: if frameWidth < frameHeight {
            frameWidth = view.frame.height
            frameHeight = view.frame.width
            x = view.frame.origin.y
            y = view.frame.origin.x
        }
        case .landscapeRight: if frameWidth < frameHeight {
            frameWidth = view.frame.height
            frameHeight = view.frame.width
            x = view.frame.origin.y
            y = view.frame.origin.x
        }
        case .faceUp: if frameWidth > frameHeight {
            frameWidth = view.frame.height
            frameHeight = view.frame.width
            x = view.frame.origin.y
            y = view.frame.origin.x
        }
        case .faceDown: if frameWidth > frameHeight {
            frameWidth = view.frame.height
            frameHeight = view.frame.width
            x = view.frame.origin.y
            y = view.frame.origin.x
        }
        case .unknown: return
        default: return
        }
        
        viewDidLoad()
    }
    
    @objc func loadWebpage(notification: NSNotification) {
        guard let data = dataPreloads!.loadWebpage(urlString, webView: self) else { return }
        DispatchQueue.main.async {
            self.webView.load(data, mimeType: "text/html", characterEncodingName: ".utf8", baseURL: URL(string: self.urlString)!)
            self.view.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 18)
            self.view.autoresizesSubviews = true
            self.webView.autoresizingMask = UIView.AutoresizingMask.init(rawValue: 18)
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
