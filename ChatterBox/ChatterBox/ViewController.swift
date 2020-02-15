//
//  ViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/14/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        var V1: View1 = View1(nibName: "View1", bundle: nil)
        
        var V2: View2 = View2(nibName: "View2", bundle: nil)
        
        self.addChild(V1)
        self.scrollView.addSubview(V1.view)
        V1.didMove(toParent: self)
        
        self.addChild(V2)
        self.scrollView.addSubview(V2.view)
        V2.didMove(toParent: self)
        
        var V2Frame : CGRect = V2.view.frame
        V2Frame.origin.x = self.view.frame.width
        V2.view.frame = V2Frame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.size.height)
        
        
    
    
    }


}

