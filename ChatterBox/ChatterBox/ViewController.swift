//
//  NameViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/15/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Globals: NSObject {
    static var name: String = ""
    static var friends: [Friend] = []
}

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
 
        self.nameTextView.delegate = self
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true)
      return false
   }
    
    @IBAction func didPressSubmit(_ sender: Any) {
        guard let name = nameTextView.text, !name.isEmpty else { return }
        Globals.name = name.capitalized
        let url = "https://chatterboxweb.herokuapp.com/retrieve"
        let params = ["user" : Globals.name]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                print(json)
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
                print(friends[0].name, friends[1].name, friends[2].name)
                Globals.friends = friends
                case .failure(let error):
                    print(error)
                }
            }
        }

}
