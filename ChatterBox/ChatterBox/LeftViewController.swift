//
//  LeftViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/14/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController {

    @IBOutlet weak var recordButton: UIView!
    @IBOutlet var soundBars: [UIView]!
    
    var recordPress = UIGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.recordButton.addGestureRecognizer(recordPress)
        recordPress.addTarget(self, action: #selector(pressRecord))
    }
    
    @objc
    func pressRecord() {
        
    }

}
