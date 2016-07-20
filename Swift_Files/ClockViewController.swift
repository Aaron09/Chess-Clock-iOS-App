//
//  ViewController.swift
//  ChessClock
//
//  Created by Aaron Green on 7/12/16.
//  Copyright © 2016 Aaron Green. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController {

    var GameHasBeenStarted = false
    let chessTimer = ChessClockTimer()
    let minimalTimeDelayForQuickUpdates = 0.005
    var timeAsString = "5:00"
    var minutesString = "5"
    var secondsString = "00"
    var endOfMinutes = false
    var backgroundImage = UIImage()
    let pauseImage = UIImage(named: "pause.png")
    let playImage = UIImage(named: "play.png")
    var backgroundImageView = UIImageView()
    var playerOneTurn = false
    var isPaused = false
 
    
    @IBOutlet weak var playerOneButton: UIButton!
    @IBOutlet weak var playerTwoButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad()
    {
        self.view.addBackground()
        playerOneButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    
    //background timer checking for time changes
         _ = NSTimer.scheduledTimerWithTimeInterval(minimalTimeDelayForQuickUpdates, target: self, selector: #selector(ClockViewController.updatePlayerLabels), userInfo: nil, repeats: true)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIDevice.currentDevice().orientation.isLandscape {
            self.view.addBackground()
        } else {
            self.view.addBackground()
        }
    }
    
    func resetButtonColors()
    {
        playerOneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playerTwoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    func setColorOfButtonWhoIsCounting()
    {
        if playerOneTurn {
            playerOneButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            playerTwoButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        } else {
            playerTwoButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            playerOneButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
    }
    
    func updatePlayerLabels()
    {
        //only updates text label if that player's time has changed
        if playerOneButton.currentTitle != "\(chessTimer.playerOneMinutes):\(formattedSeconds(chessTimer.playerOneSeconds))" {
                playerOneButton.setTitle("\(chessTimer.playerOneMinutes):\(formattedSeconds(chessTimer.playerOneSeconds))", forState: .Normal)
        } else if playerTwoButton.currentTitle != "\(chessTimer.playerTwoMinutes):\(formattedSeconds(chessTimer.playerTwoSeconds))" {
              playerTwoButton.setTitle("\(chessTimer.playerTwoMinutes):\(formattedSeconds(chessTimer.playerTwoSeconds))", forState: .Normal)
        }
    }
    
    //formats seconds if the second count is below 10 seconds (9 -> 09)
    func formattedSeconds(playerSeconds: Int) -> String
    {
        var properlyFormattedSeconds = ""
        if playerSeconds < 10 {
            properlyFormattedSeconds = "0\(playerSeconds)"
        } else {
            properlyFormattedSeconds = "\(playerSeconds)"
        }
        return properlyFormattedSeconds
    }
    
    @IBAction func setTimerButtonPressed(sender: UIButton)
    {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Configure Clock Timer", message: "Enter a time (e.g., for 10 minutes, write '10:00' or just '10')", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "10:00"
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            
            self.minutesString = ""
            self.secondsString = ""
            if self.checkParsable(textField.text!){
                self.timeAsString = textField.text!
                self.parseStringForTime()
                self.setTimerValues()
            } else {
                self.correctNonParsableInput()
            }
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkParsable(stringToBeTested: String) -> Bool
    {
        var isParsable = true
        let digits = NSCharacterSet.decimalDigitCharacterSet()
        
        for index in stringToBeTested.unicodeScalars {
            if !digits.longCharacterIsMember(index.value) && index != ":"{
                isParsable = false
            }
        }
        return isParsable
    }
    
    func correctNonParsableInput()
    {
        minutesString = "5"
        secondsString = "00"
    }
    
    func parseStringForTime()
    {
        //all text before the : is minutes, all text after is seconds
        for index in self.timeAsString.characters {
            if index != ":" && self.endOfMinutes != true {
                self.minutesString = self.minutesString + String(index)
            } else if index != ":" && self.endOfMinutes == true {
                self.secondsString = self.secondsString + String(index)
            }
            if index == ":" {
                self.endOfMinutes = true
            }
        }
        //resets for the next timer set
        self.endOfMinutes = false
        
        //nil input safety net
        if self.minutesString == "" {
            self.minutesString = "5"
        }
        if self.secondsString == "" {
            self.secondsString = "00"
        }
    }
    
    func setTimerValues()
    {
        self.chessTimer.playerOneMinutes = Int(self.minutesString)!
        self.chessTimer.playerTwoMinutes = Int(self.minutesString)!
        self.chessTimer.playerOneSeconds = Int(self.secondsString)!
        self.chessTimer.playerTwoSeconds = Int(self.secondsString)!
    }

    @IBAction func pauseAndPlay(sender: UIButton)
    {
        if !isPaused{
            chessTimer.stopPlayerOneTimer()
            chessTimer.stopPlayerTwoTimer()
            pauseButton.setBackgroundImage(playImage, forState: .Normal)
            isPaused = true
        } else {
            if playerOneTurn{
                chessTimer.startPlayerOneTimer()
            } else {
                chessTimer.startPlayerTwoTimer()
            }
            pauseButton.setBackgroundImage(pauseImage, forState: .Normal)
            isPaused = false
        }
    }
    
    @IBAction func newGame(sender: UIButton)
    {
        chessTimer.stopPlayerOneTimer()
        chessTimer.stopPlayerTwoTimer()
        resetButtonColors()
        chessTimer.playerOneSeconds = Int(secondsString)!
        chessTimer.playerTwoSeconds = Int(secondsString)!
        chessTimer.playerOneMinutes = Int(minutesString)!
        chessTimer.playerTwoMinutes = Int(minutesString)!
        chessTimer.isPlayerOneTurn = false
        isPaused = false
        pauseButton.setBackgroundImage(pauseImage, forState: .Normal)
        GameHasBeenStarted = false
    }
    
    @IBAction func playerOneButton(sender: UIButton)
    {
        playerOneTurn = false
        chessTimer.stopPlayerOneTimer()
        chessTimer.startPlayerTwoTimer()
        setColorOfButtonWhoIsCounting()
        if !GameHasBeenStarted {
           GameHasBeenStarted = true
        }
    }
  
    @IBAction func playerTwoButton(sender: UIButton)
    {
        playerOneTurn = true
        chessTimer.stopPlayerTwoTimer()
        chessTimer.startPlayerOneTimer()
        setColorOfButtonWhoIsCounting()
        if !GameHasBeenStarted {
            GameHasBeenStarted = true
        }
    }

}

