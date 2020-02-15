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
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.refreshControl.addTarget(self, action: #selector(refreshDataBase), for: .valueChanged)
        
        self.tableView.reloadData()
        self.refreshDataBase(self)
    }
    
    @objc
    func refreshDataBase(_ sender: Any) {
        let url = "https://chatterboxweb.herokuapp.com/retrieve"
        let params = ["user" : Globals.name]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print("JSON: \(json)")
                var friends: [Friend] = []
                for (friend_name, subJson) in json {
                    var url = ""
                    var keywords: [String] = []
                    var emotions_dict: [String: Float] = [:]
                    for (title, subsubJson) in subJson {
                        if title == "url" {
                            url = subsubJson.string!
                        }
                        else {
                            for (title9, subsubsubJson) in subsubJson {
                                if title9 == "Emotion" {
                                    for (_, subsubsubsubJson) in subsubsubJson {
                                        for (emotion, val) in subsubsubsubJson {
                                            emotions_dict[emotion] = val.float!
                                        }
                                    }
                                }
                                else if title9 == "Key Words" {
                                    for str in subsubsubJson.array! {
                                        keywords.append(str.string!)
                                    }
                                }
                            }
                        }
                    }
                    let max_emotion = emotions_dict.max { a, b in a.value < b.value }
                    let best_emotion = (max_emotion?.key)!
                    friends.append(Friend(friend_name, best_emotion, keywords, url))
                }
                Globals.friends = friends.sorted(by: { $0.name > $1.name })
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        self.refreshControl.endRefreshing()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Globals.friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tvcell", for: indexPath) as? DataBaseTableViewCell else {
            fatalError("The dequeued cell is not an instance of DataBaseTableViewCell.")
        }
        let idx = indexPath.row
        let friend = Globals.friends[idx]
        
        cell.nameLabel.text = friend.name
        cell.dataLabel.text = "Common Phrases: \(friend.keywords.joined(separator: ", "))\n\nYour Past Conversation was: \(friend.emotion)"
        let url = URL(string: friend.url)!
        let data = try? Data(contentsOf: url)

        if let imageData = data {
            let image = UIImage(data: imageData)!
            let resized = resizeImage(image: image, targetSize: CGSize(width: 80, height: 80))
            cell.imageView!.image = resized
        }
        return cell
    }

}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    return newImage
}
