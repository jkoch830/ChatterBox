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
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        let RVC: RecordViewController = self.storyboard?.instantiateViewController(withIdentifier: "record") as! RecordViewController
        self.addChild(RVC)
        self.scrollView.addSubview(RVC.view)
        RVC.didMove(toParent: self)
        
        let TVC: DataBaseTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "database") as! DataBaseTableViewController
        self.addChild(TVC)
        self.scrollView.addSubview(TVC.view)
        TVC.didMove(toParent: self)
        
        var TVCFrame: CGRect = TVC.view.frame
        TVCFrame.origin.x = self.view.frame.width
        TVC.view.frame = TVCFrame
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.size.height)
        
        self.scrollView.pinEdges(to: self.view)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.view = self.scrollView
    }

}

extension UIView {
    func pinEdges(to other: UIView) {
        leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
    }
}
