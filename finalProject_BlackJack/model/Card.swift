//
//  Card.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/15/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit

//this sctruct is used to create the back bone of my cards 

struct Card {
    
    let rank : Rank?
    let suit : Suit?
    var image : UIImage?
   
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
            case .Ace: return 11 
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
