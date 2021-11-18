//
//  UITabBarViewController.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/17.
//

import UIKit
import WebKit

class UITabBarViewController: UITabBarController {
    
    var dataPreloads: DataPreloads = DataPreloads()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataPreloads.startLoad()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        for i in 0...4 {
            if (i < 4) {
                let generalViewController = self.viewControllers![i] as! GeneralViewController
                generalViewController.dataPreloads = dataPreloads
                generalViewController.navigatorIndex = i
            } else {
                let aboutViewController = self.viewControllers![4] as! AboutViewController
                aboutViewController.dataPreloads = dataPreloads
            }
            self.viewControllers?[i].view.setNeedsLayout()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }

}
