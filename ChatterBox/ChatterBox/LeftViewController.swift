//
//  LeftViewController.swift
//  ChatterBox
//
//  Created by Edward on 2/14/20.
//  Copyright © 2020 Edward. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class LeftViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var soundBars: [UIView]!
    @IBOutlet weak var recordButton: UIButton!
    
    var isRecording = false
        
    let fileName = "record.m4a"
        
    var filemanager = FileManager.default
    var audioRecorder = AVAudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTranscribePermissions()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
        }
            
        catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        let fileURL = getFileURL()
        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            print("soundfile \(fileURL.absoluteString) exists")
        }
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print("bad")
        }
    }
    
    func startRecording() {
        audioRecorder.record()
    }
    
    func finishRecording() {
        self.audioRecorder.stop()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        return path as URL
    }
    
    func requestTranscribePermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("Good to go!")
                } else {
                    print("Transcription permission was declined.")
                }
            }
        }
    }
    
    func transcribeAudio(url: URL) {
        // create a new recognizer and point it at our audio
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        // start recognition!
        recognizer?.recognitionTask(with: request) { (result, error) in
            // abort if we didn't get any transcription back
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }

            // if we got the final transcription back, print it
            if result.isFinal {
                // pull out the best transcription...
                print(result.bestTranscription.formattedString)
            }
        }
    }

    @IBAction func pressedRecord(_ sender: Any) {
        if !self.audioRecorder.isRecording {
            for bar in self.soundBars {
                bar.isHidden = false
            }
            UIView.animate(withDuration: 0.75, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                for bar in self.soundBars {
                    bar.transform = CGAffineTransform(scaleX: 1, y: CGFloat.random(in: 0.2..<2.0))
                }
            }, completion: nil)
            startRecording()
        }
        else {
            for bar in self.soundBars {
                bar.isHidden = true
            }
            finishRecording()
            transcribeAudio(url: getFileURL())
        }
        isRecording = !isRecording
    }
}
