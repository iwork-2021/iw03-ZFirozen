//
//  GeneralTableViewController.swift
//  ITSC
//
//  Created by ZFirozen on 2021/11/18.
//

import UIKit

class GeneralTableViewController: UITableViewController, UISearchControllerDelegate {
    
    var dataPreloads: DataPreloads?
    var index: Int = 0
    var searchController: UISearchController?
    var refreshAction: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "dataLoaded" + String(index)), object: nil)
        
        searchController = UISearchController.init(searchResultsController: nil)
        searchController!.obscuresBackgroundDuringPresentation = false
        searchController!.searchResultsUpdater = dataPreloads!
        searchController!.delegate = self
        navigationItem.searchController = searchController
        let refreshAction = UIRefreshControl.init()
        refreshAction.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        refreshAction.attributedTitle = NSAttributedString.init(string: "刷新列表")
        tableView.addSubview(refreshAction)
    }
    
    @objc func loadList(notification: NSNotification) {
        //load data here
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func refreshList() {
        dataPreloads?.startLoad()
        refreshAction?.endRefreshing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController != nil && searchController!.isActive) {
            return dataPreloads?.resultNumber(index) ?? 0
        } else {
            return dataPreloads?.itemNumber(index) ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! GeneralTableViewCell

        // Configure the cell...
        if (searchController != nil && searchController!.isActive) {
            (cell.title.text, cell.detail.text, cell.link) = dataPreloads!.resultUpdate(index, indexPath.row)
        } else {
            (cell.title.text, cell.detail.text, cell.link) = dataPreloads!.itemUpdate(index, indexPath.row)
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let htmlViewController = segue.destination as! WebsiteViewController
        let cell = sender as! GeneralTableViewCell
        htmlViewController.urlString = cell.link
        htmlViewController.dataPreloads = dataPreloads
    }
    

}
