//
//  dataPreloads.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/17.
//

import UIKit
import WebKit
import SwiftSoup

class DataPreloads: NSObject, UISearchResultsUpdating {
    
    var searchResult: [[Int]] = [[], [], [], []]
    
    func updateSearchResults(for searchController: UISearchController) {
        if (searchController.searchBar.text == nil) {
            searchResult = [[], [], [], []]
            return
        }
        let operationQueue = OperationQueue()
        for i in 0...3 {
            operationQueue.addOperation {
                let searchText = searchController.searchBar.text!
                self.searchResult[i] = []
                for j in 0..<self.linkLists[i].count {
                    if (self.linkLists[i][j].0.range(of: searchText) != nil) {
                        self.searchResult[i].append(j)
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataLoaded" + String(i)), object: nil)
            }
        }
    }
    
    var aboutURL: String = "https://itsc.nju.edu.cn/main.htm"
    var urlList: [String] = [
        "https://itsc.nju.edu.cn/xwdt/list",
        "https://itsc.nju.edu.cn/tzgg/list",
        "https://itsc.nju.edu.cn/wlyxqk/list",
        "https://itsc.nju.edu.cn/aqtg/list"
        ]
    var suffix: String = ".htm"
    var aboutWeb: WKWebView = WKWebView()
    var linkLists: [[(String, String, String)]] = [[], [], [], []]
    var webpageLists: [String:Data] = [:]
        
    func startLoad() {
        let operationQueue = OperationQueue()
        for i in 0...3 {
            operationQueue.addOperation {
                do {
                    let pageTotal = try Int(SwiftSoup.parse(String(contentsOf: URL(string: self.urlList[i] + self.suffix)!)).select(".all_pages").first()!.html())
                    for k in 1...(pageTotal ?? 1) {
                        if let url = URL(string: self.urlList[i] + String(k) + self.suffix) {
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
                        }
                    }
                } catch {
                        
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
                var urlRequest = URLRequest(url: URL(string: url)!)
                urlRequest.setValue("iPhone AppleWebKit", forHTTPHeaderField: "User-Agent")
                let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {
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
    
    func resultNumber(_ index: Int) -> Int {
        return searchResult[index].count
    }
    
    func itemUpdate(_ index: Int, _ itemIndex: Int) -> (String, String, String) {
        return linkLists[index][itemIndex]
    }
    
    func resultUpdate(_ index: Int, _ itemIndex: Int) -> (String, String, String) {
        return linkLists[index][searchResult[index][itemIndex]]
    }
}
