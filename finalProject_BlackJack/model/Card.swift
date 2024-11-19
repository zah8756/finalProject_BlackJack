//
//  Card.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/15/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit

struct Card {
    
    let rank : Rank?
    let suit : Suit?
   
    enum Rank:Int{
        case two = 2
        case three,four,five,six,seven,eight,nine,ten
        case Jack,Queen,King,Ace
        
        func describeCard() -> String {
            switch self {
            case .Jack: return "Jack"
            case .Queen: return "Queen"
            case .King: return "King"
            case .Ace: return "Ace"
            default: return String(self.rawValue)
            }
        }
        func cardValues() -> Int {
            switch self {
            case .Jack: return 10
            case .Queen: return 10
            case .King: return 10
            case .Ace: return 11 //you will need to create a function which checks so you could posibly change 11 to 1
            default: return Int(self.rawValue)
            }
        }
    }
    
    enum Suit: String {
        case spade = "Spade"
        case heart = "Heart"
        case diamond = "Diamond"
        case club = "Club"
    }
    
    
}
