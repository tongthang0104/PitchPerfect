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
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecord: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var buttonFlashing = false
    
    
    
    //MARK: - ViewController Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordAudio()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.recordButton.enabled = true
        recordButton.alpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Functions
    
    func recordAudio() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
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
    }
    
    // Thanks to http://stackoverflow.com/questions/31288914/issue-with-flash-animation-with-record-button-swift
    
    func buttonStartFlashing() {
        buttonFlashing = true
        recordButton.alpha = 1
        UIView.animateWithDuration(0.5, delay: 0.0, options:
            [
                UIViewAnimationOptions.CurveEaseInOut,
                UIViewAnimationOptions.Repeat,
                UIViewAnimationOptions.Autoreverse,
                UIViewAnimationOptions.AllowUserInteraction],
            animations: { () -> Void in
                self.recordButton.alpha = 0.1
            }) { Bool in
        }
    }
    
    func buttonStopFlashing() {
        buttonFlashing = false
        UIView.animateWithDuration(0.1, delay: 0.0, options: [
            UIViewAnimationOptions.CurveEaseInOut,
            UIViewAnimationOptions.BeginFromCurrentState],
            animations: {
                self.recordButton.alpha = 1
            }, completion: {Bool in
        })
    }
    
    // MARK: - Action
    
    @IBAction func recordButtonTapped(sender: UIButton) {
        
        stopButton.hidden = false
        if (!audioRecord.recording) {
            let audioSession  = AVAudioSession.sharedInstance()
            try! audioSession.setActive(true)
            recordLabel.text = "Recording in process..."
            audioRecord.record()
            buttonStartFlashing()
        } else {
            audioRecord.pause()
            recordLabel.text = "Paused"
            buttonStopFlashing()
        }
    }
    @IBAction func stopButtonTapped(sender: UIButton) {
        self.recordLabel.text = "Tap to record"
        audioRecord.stop()
        stopButton.hidden = true
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
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("error")
            recordButton.enabled = true
            
            // Let user know there is some error
            let alert = UIAlertController(title: "Audio cannot be recorded", message: "Please try again", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func audioRecorderBeginInterruption(recorder: AVAudioRecorder) {
        audioRecord.stop()
    }
    
}

