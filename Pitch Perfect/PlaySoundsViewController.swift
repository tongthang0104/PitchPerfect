//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thang H Tong on 2/1/16.
//  Copyright © 2016 Thang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - Properties
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var recordedAudio: RecordedAudio?
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        if let paths = NSBundle.mainBundle().pathForResource("movieQuote", ofType: "mp3") {
        //            print(paths)
        //            let audioURL = NSURL(fileURLWithPath: paths)
        //        } else {
        //            print("no audio")
        //        }
    }
    
    override func viewDidAppear(animated: Bool) {
        do {
            if let recordedAudio = self.recordedAudio {
                try audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
                audioPlayer.enableRate = true
            } else {
                print("no audio received")
            }
        } catch {
            print("no audio")
        }
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: (recordedAudio?.filePathUrl)!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        audioPlayer.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func playAudio(rate: Float) {
        
        audioPlayer.play()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // reset the audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()

        audioEngine.attachNode(audioPlayerNode)
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! self.audioEngine.start()
    }
    
    // MARK: - Action
    
    @IBAction func fastButtonTapped(sender: UIButton) {
        self.playAudio(2.0)
    }
    
    @IBAction func slowButtonTapped(sender: UIButton) {
        self.playAudio(0.3)
    }
    
    @IBAction func chipmunkButtonTapped(sender: UIButton) {
       self.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    @IBAction func darthvaderButtonTapped(sender: UIButton) {
        self.playAudioWithVariablePitch(-1000)
    }
}
