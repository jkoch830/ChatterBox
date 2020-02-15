//
//  DataBaseTableViewController.swift
//  
//
//  Created by Edward on 2/15/20.
//

import UIKit
import Alamofire

class DataBaseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.addSubview(self.refreshControl)
        self.tableView.reloadData()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.addTarget(self, action: #selector(refreshDataBase), for: .valueChanged)
    }
    
    @objc func refreshDataBase(_ sender: Any) {
        let url = "https://chatterboxweb.herokuapp.com/"
        Alamofire.request(url, method: .get).responseJSON { response in
            if let json = response.result.value {
                print(json)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tvcell", for: indexPath) as? DataBaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of DataBaseTableViewCell.")
        }
        return cell
    }

}
