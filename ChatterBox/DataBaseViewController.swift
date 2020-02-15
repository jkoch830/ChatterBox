//
//  DataBaseTableViewController.swift
//
//
//  Created by Edward on 2/15/20.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    @objc
    func refreshDataBase(_ sender: Any) {
        let url = "https://chatterboxweb.herokuapp.com/"
        let params = ["user" : "Edward"]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
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
