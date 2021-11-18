//
//  dataPreloads.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/17.
//

import UIKit
import WebKit
import SwiftSoup

class DataPreloads: NSObject {
    var aboutURL: String = "https://itsc.nju.edu.cn/main.htm"
    var urlList: [String] = [
        "https://itsc.nju.edu.cn/xwdt/list.htm",
        "https://itsc.nju.edu.cn/tzgg/list.htm",
        "https://itsc.nju.edu.cn/wlyxqk/list.htm",
        "https://itsc.nju.edu.cn/aqtg/list.htm"
        ]
    var aboutWeb: WKWebView = WKWebView()
    var linkLists: [[(String, String, String)]] = [[], [], [], []]
    var webpageLists: [String:Data] = [:]
        
    func startLoad() {
        let operationQueue = OperationQueue()
        for i in 0...3 {
            operationQueue.addOperation {
                if let url = URL(string: self.urlList[i]) {
                    do {
                        let html = try String(contentsOf: url)
                        let document = try SwiftSoup.parse(html)
                        let news_list = try SwiftSoup.parse(document.select("ul.news_list.list2").first()!.html())
                        let news_titles = try news_list.select("a").array()
                        let news_dates = try news_list.select(".news_meta")
                        var news_links: [String] = []
                        for element: Element in news_titles {
                            try news_links.append(element.attr("href"))
                        }
                        for j in 0..<news_titles.count {
                            self.linkLists[i].append((try! news_titles[j].text(), try! news_dates[j].text(), "https://itsc.nju.edu.cn" + news_links[j]))
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataLoaded" + String(i)), object: nil)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func loadWebpage(_ url: String, webView: WebsiteViewController) -> Data? {
        if (webpageLists[url] != nil) {
            return webpageLists[url]
        } else {
            let operationQueue = OperationQueue()
            let blockOperation = BlockOperation {
                let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {
                            data, response, error in
                            if let error = error {
                                print("\(error.localizedDescription)")
                                return
                            }
                            guard let httpResponse = response as? HTTPURLResponse,
                                  (200...299).contains(httpResponse.statusCode) else {
                                print("server error")
                                return
                            }
                    self.webpageLists.updateValue(data!, forKey: url)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "websiteLoaded"), object: nil)
                        })
                task.resume()
            }
            operationQueue.addOperation(blockOperation)
            return nil
        }
    }
    
    func itemNumber(_ index: Int) -> Int {
        return linkLists[index].count
    }
    
    func itemUpdate(_ index: Int, _ itemIndex: Int) -> (String, String, String) {
        return linkLists[index][itemIndex]
    }
}
