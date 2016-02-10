//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Thang H Tong on 2/1/16.
//  Copyright © 2016 Thang. All rights reserved.

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: - Properties
    
    var audioPlayer: AVAudioPlayer = AVAudioPlayer()
    var audioPlayer2: AVAudioPlayer = AVAudioPlayer()
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
                
                try audioPlayer2 = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl)
                audioPlayer2.enableRate = true
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
    
    // Thanks to http://sandmemory.blogspot.com/2014/12/how-would-you-add-reverbecho-to-audio.html
    
    func playEcho() {
        resetAudio()
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        let delay:NSTimeInterval = 0.2
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    // MARK: - Action
    
    @IBAction func fastButtonTapped(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func slowButtonTapped(sender: UIButton) {
        playAudio(0.3)
    }
    
    @IBAction func chipmunkButtonTapped(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func stopButtonTapped(sender: UIButton) {
        resetAudio()
        audioPlayer.currentTime = 0
    }
    
    @IBAction func darthvaderButtonTapped(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
        
    }
    @IBAction func playEchoButtonTapped(sender: UIButton) {
        playEcho()
    }
}
