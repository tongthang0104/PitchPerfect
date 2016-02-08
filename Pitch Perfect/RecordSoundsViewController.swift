//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thang H Tong on 2/1/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    
    // MARK: - Properties
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecord: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
 
    //MARK: - ViewController Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recordButton.enabled = true
        self.recordLabel.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    func recordAudio() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        //        let currentDateTime = NSDate()
        //        let formatter = NSDateFormatter()
        //        formatter.dateFormat = "ddMMyyy-HHmmss"
        //        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let recordingName = "my_audio.wav"
        let pathArray = [path, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        do {
            try audioRecord = AVAudioRecorder(URL: filePath!, settings: [:])
            audioRecord.delegate = self
            
        } catch {
            print("error")
        }
        
        audioRecord.meteringEnabled = true
        audioRecord.prepareToRecord()
        audioRecord.record()
    }

    // MARK: - Action
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        self.recordLabel.hidden = false
        self.recordButton.enabled = false
        self.recordAudio()
    }
    @IBAction func stopButtonTapped(sender: UIButton) {
        self.recordLabel.hidden = true
        audioRecord.stop()
        let audioSession  = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            if let destinationController = segue.destinationViewController as? PlaySoundsViewController {
                _ = destinationController.view
                let data = sender as! RecordedAudio
                destinationController.recordedAudio = data
            }
        }
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recordedAudio = RecordedAudio()
            
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("error")
            recordButton.enabled = true
        }
    }
}

