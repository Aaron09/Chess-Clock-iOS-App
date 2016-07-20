//
//  ChessClockTimer.swift
//  ChessClock
//
//  Created by Aaron Green on 7/12/16.
//  Copyright © 2016 Aaron Green. All rights reserved.
//

import Foundation


class ChessClockTimer {
    
    var playerOneSeconds = 0
    var playerTwoSeconds = 0
    var playerOneMinutes = 5
    var playerTwoMinutes = 5
    
    private let timeDelay = 1.0
    private var playerOneTimer = NSTimer()
    private var playerTwoTimer = NSTimer()
    
    var playerOneStarted = false
    var playerTwoStarted = false
   
    var isPlayerOneTurn = false
    
    @objc private func incrementTime () {
        if isPlayerOneTurn && !(playerOneSeconds == 0 && playerOneMinutes == 0){
            if playerOneSeconds == 0 {
                playerOneMinutes -= 1
                playerOneSeconds = 60
            }
            playerOneSeconds -= 1
        } else if !(playerTwoSeconds == 0 && playerTwoMinutes == 0){
            if playerTwoSeconds == 0 {
                playerTwoMinutes -= 1
                playerTwoSeconds = 60
            }
            playerTwoSeconds -= 1
        }
    }
    
    func startPlayerOneTimer()
    {
        if !playerOneStarted {
            isPlayerOneTurn = true
            playerOneStarted = true
            playerOneTimer = NSTimer.scheduledTimerWithTimeInterval(timeDelay, target: self, selector: #selector(ChessClockTimer.incrementTime), userInfo: nil, repeats: true)
        }
    }
    
    func startPlayerTwoTimer()
    {
        if !playerTwoStarted {
            isPlayerOneTurn = false
            playerTwoStarted = true
            playerTwoTimer = NSTimer.scheduledTimerWithTimeInterval(timeDelay, target: self, selector: #selector(ChessClockTimer.incrementTime), userInfo: nil, repeats: true)
        }
    }
    
    func stopPlayerOneTimer()
    {
        playerOneStarted = false
        playerOneTimer.invalidate()
    }
    
    func stopPlayerTwoTimer()
    {
        playerTwoStarted = false
        playerTwoTimer.invalidate()
    } 

}