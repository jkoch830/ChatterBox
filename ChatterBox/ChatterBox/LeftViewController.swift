//
//  LeftViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/14/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit
import AVFoundation

class LeftViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var recordButton: UIView!
    @IBOutlet var soundBars: [UIView]!
    
    var recordPress = UIGestureRecognizer()
    var isRecording = false
    weak var timer: Timer?
    
    var recorder = AVAudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
        self.recordButton.addGestureRecognizer(recordPress)
        recordPress.addTarget(self, action: #selector(pressRecord))
        self.setupRecorder()

        
    }
    
    func setupRecorder() {
        var recordSettings = [AVFormatIDKey : kAudioFormatAppleLossless,
                              AVEncoderAudioQualityKey : .max,
                              AVEncoderBitRateKey : 320000,
                              AVNumberOfChannelsKey : 2,
                              AVSampleRateKey : 44100 ]
        
        var error : NSError?
        
        self.recorder = AVAudioRecorder(URL: getFileURL(), settings: recordSettings as [NSObject : AnyObject], error: &error)
        
        if let err = error{
            print("SOmething Wrong")
        }
            
        else {
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
        }
        
    }

    
    @objc
    func pressRecord() {
        if !isRecording {
            self.recordButton.isHidden = true
        }
        else {
            self.recordButton.isHidden = false
        }
        isRecording = !isRecording
    }
    
    @objc
    func timerFired() {
        if isRecording {
            for bar in self.soundBars {
                let newHeight: CGFloat = CGFloat.random(in: 20..<500)
                bar.frame = CGRect(x: bar.center.x, y: bar.center.y, width: bar.frame.width, height: newHeight)
            }
        }
        else {
            for bar in self.soundBars {
                let newHeight: CGFloat = 125
                bar.frame = CGRect(x: bar.center.x, y: bar.center.y, width: bar.frame.width, height: newHeight)
            }
        }
    }

}
