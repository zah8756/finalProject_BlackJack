//
//  bankBrain.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/27/19.
//  Copyright © 2019 zach. All rights reserved.
//

import Foundation

//this class is used to change money and bets whener someone bets money or wins the round
class bankBrain{
    var total:Int = 0
    var bank: Int = 0
    
    
    init(total:Int,bank:Int) {
        self.total = total
        self.bank = bank
    }
    
    func bet5() {
        if(bank>=5){
            bank = bank - 5
            total = total + 5
        }
        
    }
    func bet10() {
        if(bank>=10){
            bank = bank - 10
            total = total + 10
        }
    }
    func bet20() {
        if(bank>=20){
            bank = bank - 20
            total = total + 20
        }
    }
    
    func doubleDown(){
        if (bank >= total*2){
            bank = bank - total
            total = total*2
        }
    }
    
    func busted(){
        total = 0
    }
    
    func winBet(){
        bank = bank + (total*2)
        total = 0
    }
    
    func tieBet(){
        bank = bank + total
        total = 0
    }
    
    //this function is used to detect if the user has any moey left or if they are just starting the game 
    func startGame(){
        if bank <= 0 {
            bank = 100
        }
    }
    
    func restartGame(){
        bank = 100
    }
    
    
}
