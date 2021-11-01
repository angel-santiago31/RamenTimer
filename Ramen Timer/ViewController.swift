//
//  ViewController.swift
//  Ramen Timer
//
//  Created by Angel Santiago on 10/30/21.
//

import UIKit
// Import Gifu library to allow animating gif
import Gifu
// Import SwiftySound to play audio
import SwiftySound

class ViewController: UIViewController {
    
    // Cooking time (in seconds)
    let cookingTime = 180
    
    // How long the alarm will ring (in seconds)
    let alarmTime = 4
    
    // Seconds passed of the total cooking time
    var secondsPassed = 0
    
    // Variable to store the Timer object
    var timer: Timer?
    
    // The number of seconds between firings of the timer
    let timerInt = 1.0
    
    // GIF name (without .gif extension)
    let gifName = "ramen"
    
    // GIF view dimensions
    // Match image view constraints for better results
    let gifDimensions = ["width": 200, "height": 200]
    
    // Variable to store our GIF of type GIFImageVIew
    var gifImageView: GIFImageView?
    
    // Image view for static ramen picture
    @IBOutlet weak var imageView: UIImageView!
    
    // Audio file names and formats
    let sound1 = ["name": "cooking", "format": "wav"]
    let sound2 = ["name": "alarm", "format": "wav"]
    
    // Label displayed at the top view
    @IBOutlet weak var label: UILabel!
    
    // Start/Stop button
    @IBOutlet weak var startStopButton: UIButton!
    
    // Font Family
    let fontFamily = "MarkerFelt-Wide"
    
    // Label font size
    let labelFontSize = 50.0
    
    // Button font size
    let buttonFontSize = 30.0
    
    // Attributed strings for startStopButton and label
    var attributesLabel: [NSAttributedString.Key: Any]?
    var attributesButton: [NSAttributedString.Key: Any]?
    var attributedStringStart: NSAttributedString?
    var attributedStringStop: NSAttributedString?
    var attributedStringReady: NSAttributedString?
    var attributedStringCooking: NSAttributedString?
    var attributedStringDone: NSAttributedString?
    
    // Strings for button text
    let btnTxt1 = "Start"
    let btnTxt2 = "Stop"
    
    // Strings for label text
    let labelTxt1 = "Ready to cook!"
    let labelTxt2 = "Cooking..."
    let labelTxt3 = "Itadakimasu!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        gifInit()
        attributedStringsInit()
    }
    
    /**
     Initializes GIFImageView and add it to the center of the middle view with the specified dimensions in gifDimensions.
     */
    func gifInit () {
        // Get the middle view
        let middleView = view.viewWithTag(2)
        
        // Create GIFImageView object with width and height equal to the constraint given using
        // the Auto Layout (view image view constraint values in Document Outline)
        gifImageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: gifDimensions["width"]!, height: gifDimensions["height"]!))
        
        // Center gif within the middle view
        gifImageView?.center = CGPoint(x: middleView!.bounds.midX, y: middleView!.bounds.midY)
        
        // Prepare gif for animation
         gifImageView!.prepareForAnimation(withGIFNamed: gifName)
        
        // Add gif view to middle view
        middleView!.addSubview(gifImageView!)
    }
    
    /**
     Initializes attributed strings to update stopStartButton and label text.
     */
    func attributedStringsInit () {
       attributesLabel = [
           .foregroundColor: UIColor.black,
           .font: UIFont(name: fontFamily, size: labelFontSize)!
       ]
        attributesButton = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: fontFamily, size: buttonFontSize)!
        ]
        attributedStringReady = NSAttributedString(string: labelTxt1, attributes: attributesLabel)
        attributedStringCooking = NSAttributedString(string: labelTxt2, attributes: attributesLabel)
        attributedStringDone = NSAttributedString(string: labelTxt3, attributes: attributesLabel)
        attributedStringStart = NSAttributedString(string: btnTxt1, attributes: attributesButton)
        attributedStringStop = NSAttributedString(string: btnTxt2, attributes: attributesButton)
    }
    
    /**
     Checks if the startStopButton titleLabel.text is set to Start.
     Starts the timer if true. Otherwise, the timer is reset.
     */
    @IBAction func buttonPressed (_ sender: UIButton) {
        if startStopButton.titleLabel?.text == btnTxt1 {
            timer?.invalidate()
            label.attributedText = attributedStringCooking
            gifImageView!.isHidden = false
            imageView.image = #imageLiteral(resourceName: "ramen")
            imageView.isHidden = true
            gifImageView!.startAnimatingGIF()
            startStopButton.setAttributedTitle(attributedStringStop, for: .normal)
            Sound.stopAll()
            // Will play infinetly as stated in the documentation
            Sound.play(file: sound1["name"]!, fileExtension: sound1["format"], numberOfLoops: -1)
            timer = Timer.scheduledTimer(timeInterval: timerInt, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            reset()
        }
    }
    
    /**
     Updates the seconds passed.
     Resets the timer when the seconds passed reaches the specified time.
     */
    @objc func updateTimer () {
        if secondsPassed < cookingTime {
            secondsPassed += 1
        } else {
            reset()
            label.attributedText = attributedStringDone
            imageView.image = #imageLiteral(resourceName: "ramenReady")
            // Will play alarmTime + 1 times as stated in the documentation
            timer = Timer.scheduledTimer(timeInterval: timerInt, target: self, selector: #selector(innerTimer), userInfo: nil, repeats: true)
            Sound.play(file: sound2["name"]!, fileExtension: sound2["format"], numberOfLoops: alarmTime - 1)
        }
    }
    
    /**
     Update interface while alarm is playing.
     */
    @objc func innerTimer () {
        if secondsPassed < alarmTime - 1 {
            secondsPassed += 1
        } else {
            reset()
            imageView.image = #imageLiteral(resourceName: "ramen")
        }
    }
    
    /**
     Resets the interface, timer and seconds passed.
     */
    func reset () {
        Sound.stopAll()
        label.attributedText = attributedStringReady
        gifImageView!.stopAnimatingGIF()
        startStopButton.setAttributedTitle(attributedStringStart, for: .normal)
        timer?.invalidate()
        secondsPassed = 0
        gifImageView!.isHidden = true
        imageView.isHidden = false
        
    }
}
