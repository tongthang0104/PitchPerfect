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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
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
       resetAudio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    
    func playAudio(rate: Float) {
        resetAudio()
        audioPlayer.play()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
    }
    
    func resetAudio() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        //reset the audio
        resetAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        
        
        audioEngine.attachNode(audioPlayerNode)
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
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
        resetAudio()
        audioPlayer.currentTime = 0
    }
    
    @IBAction func darthvaderButtonTapped(sender: UIButton) {
        self.playAudioWithVariablePitch(-1000)
    }
}
