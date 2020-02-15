//
//  DataBaseTableViewController.swift
//  
//
//  Created by Edward on 2/15/20.
//

import UIKit
import Alamofire

class DataBaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControl!.addTarget(self, action: #selector(refreshDataBase), for: .valueChanged)

        self.clearsSelectionOnViewWillAppear = false
    }
    
    @objc func refreshDataBase(_ sender: Any) {
        let url = "https://mixerserver.herokuapp.com/dbcontents"
        Alamofire.request(url, method: .get).responseJSON { response in
            if let json = response.result.value {
                self.refreshControl!.endRefreshing()
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dbcell", for: indexPath)
        
        return cell
    }

}
