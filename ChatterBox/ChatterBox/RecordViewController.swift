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

class RecordViewController: UIViewController, AVAudioRecorderDelegate {

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
            print("failed to make audioRecorder")
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
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: url)

        recognizer?.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                print("UH OH: \(error!)")
                return
            }

            if result.isFinal {
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
