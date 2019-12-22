//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var lblDoneText: UILabel!
    
    @IBOutlet weak var timeProgress: UIProgressView!
    
    var player: AVAudioPlayer?

    let eggTime = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var secondRemaining = 60
    
    var totalTime = 0
    
    var secondPassed = 0
    
    var timer = Timer()
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        let hardness = sender.currentTitle
        
        totalTime = Int(eggTime[hardness ?? ""] ?? 0)
        
        timeProgress.progress = 0.0
        secondPassed = 0
        lblDoneText.text = hardness
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime () {
        if secondPassed < totalTime {
            debugPrint("\(secondPassed) seconds.")
            
            secondPassed += 1
            
            let percentageProgress = Float(secondPassed) / Float(totalTime)
            
            timeProgress.progress = Float(percentageProgress)
            
        } else {
            timer.invalidate()
            playSound()
            lblDoneText.text = "DONE!"
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
}
