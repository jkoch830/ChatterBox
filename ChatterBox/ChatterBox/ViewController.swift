//
//  NameViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/15/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit

class Globals: NSObject {
    static var name: String = ""
}

class ViewController: UIViewController {

    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
 
    self.myTextField.delegate = self
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
       }
    
    @IBAction func didPressSubmit(_ sender: Any) {
        guard let name = nameTextView.text else { return}
        Globals.name = name.capitalized
    }
}
