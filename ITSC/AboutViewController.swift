//
//  AboutViewController.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/18.
//

import UIKit
import WebKit
import SwiftSoup

class AboutViewController: UINavigationController {
    
    var dataPreloads: DataPreloads?
    var myContactUs: String = ""
    var myCContactUs: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (dataPreloads != nil) {
            if let url = URL(string: dataPreloads!.aboutURL) {
                do {
                    let html = try String(contentsOf: url)
                    let document = try SwiftSoup.parse(html)
                    let contactUs = try SwiftSoup.parse(document.select(".foot-center").first()!.html())
                    let itemsTitle = try contactUs.select("a").array()
                    let itemsFbt = try contactUs.select(".news_fbt").array()
                    let itemsText = try contactUs.select(".news_text").array()
                    myContactUs = ""
                    myCContactUs = ""
                    for i in 0...5 {
                        myContactUs += (try! itemsTitle[i].text()) + "\n"
                        myCContactUs += (try! itemsTitle[i].text()) + " "
                        if (try! itemsFbt[i].text() != "") {
                            myContactUs += (try! itemsFbt[i].text()) + "\n"
                            myCContactUs += (try! itemsFbt[i].text()) + "\n"
                        }
                        if (try! itemsText[i].text() == "") {
                            myContactUs += "\n"
                            myCContactUs += "\n"
                        } else {
                            myContactUs += (try! itemsText[i].text()) + "\n\n"
                            myCContactUs += (try! itemsText[i].text()) + "\n\n"
                        }
                    }
                } catch {
                    
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let aboutView = self.viewControllers[0] as! AboutView
        aboutView.label.text = myContactUs
        aboutView.cLabel.text = myCContactUs
        aboutView.label.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutView.cLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutView.label.numberOfLines = 0
        aboutView.cLabel.numberOfLines = 0
        //label.text = myContactUs
    }
    
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        }
    }
    */

}
