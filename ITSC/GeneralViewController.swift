//
//  GeneralViewController.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/18.
//

import UIKit

class GeneralViewController: UINavigationController {
    
    var dataPreloads: DataPreloads?
    var navigatorIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let childViewController = self.viewControllers[0] as! GeneralTableViewController
        childViewController.dataPreloads = dataPreloads
        childViewController.index = navigatorIndex
        // Do any additional setup after loading the view.
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
