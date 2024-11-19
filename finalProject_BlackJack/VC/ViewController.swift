//
//  ViewController.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/15/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Player Varibles
    @IBOutlet weak var leftCardPlayer: UILabel!
    @IBOutlet weak var rightCardPlayer: UILabel!
    @IBOutlet weak var handWorth: UILabel!
    @IBOutlet weak var HitCard: UILabel!
    
    //Dealer Varibles
    @IBOutlet weak var leftCardDealer: UILabel!
    @IBOutlet weak var rightCardDealer: UILabel!
    @IBOutlet weak var dealerHandWorth: UILabel!
    @IBOutlet weak var dealerHitCard: UILabel!
    
    
    var playerHand = [Card]()
    var dealerHand = [Card]()
    var deck = [Card]()
    var roundWinner:String!
    var currentPlayer = String()
    var dealerRightCard :String!
    var totalWorth = Int()
    var dealerWorth = Int()
    var playerBust = false
    var dealerBust = false
    var timesPushed = 0
    var timesPushedStay = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = createDeck()
        deck.shuffle()
        
        HitCard.text? = ""
        dealerHitCard.text? = ""
        
        //print(deck.count)
        currentPlayer = "player"
        playerPush(element: deckPop())
        playerPush(element: deckPop())
        
        currentPlayer = "dealer"
        playerPush(element: deckPop())
        playerPush(element: deckPop())
        //print(deck.count)
        
        var rightCard = cardInfo(myCard: playerHand[0])
        var leftCard = cardInfo(myCard: playerHand[1])
        
        var dealerRightCard = cardInfo(myCard: dealerHand[0])
        var dealerLeftCard = cardInfo(myCard: dealerHand[1])
        

        
        leftCardPlayer.text? = "\(rightCard.Name) of \(rightCard.Suit)"
        rightCardPlayer.text? = "\(leftCard.Name) of \(leftCard.Suit)"
        
        leftCardDealer.text? = "?"
        rightCardDealer.text = "\(dealerRightCard.Name) of \(dealerRightCard.Suit)"
        
        
        
        totalWorth = rightCard.Value+leftCard.Value
        dealerWorth = dealerRightCard.Value+dealerLeftCard.Value
        handWorth.text? = String(totalWorth)
        dealerHandWorth.text? = "?"
        
    }
    
  
    
//    struct Card {
//        let Rank:Rank
//        let Suite:Suite
//    }
    
    //creating a deck of cards
    
    func createDeck() -> [Card]{
        var myDeck:Array = [Card]()
        let maxCard = Card.Rank.Ace.rawValue
        let Suits:Array = [Card.Suit.club.rawValue,Card.Suit.diamond.rawValue,Card.Suit.heart.rawValue,Card.Suit.spade.rawValue]
        
        for count in 2...maxCard{
            for suit in Suits{
                let theRank = Card.Rank.init(rawValue: count)
                let theSuit = Card.Suit.init(rawValue: suit)
                let theCard = Card(rank: theRank!, suit: theSuit!)
                myDeck.append(theCard)
            }
        }
        return myDeck
    }
    
    func cardInfo(myCard:Card) -> (Name:String,Suit:String,Value:Int){
        let desc = myCard.rank?.describeCard()
        let mySuit = myCard.suit?.rawValue
        let cardWorth = myCard.rank?.cardValues()
        let card = (desc,mySuit,cardWorth)
        return card as! (Name: String, Suit: String, Value: Int)
    }
    
    
    func playerPush(element:Card){
        if currentPlayer == "player"{
             playerHand.append(element)
             //deckPop()
        }
        else if currentPlayer == "dealer"{
            dealerHand.append(element)
            //deckPop()
        }
       
    }
    
    func deckPop() -> Card{
        print("deck poped")
        
        if (!deck.isEmpty){
            let index = deck.count - 1
            let popedCard = deck.remove(at: index)
            print(deck.count)
            return popedCard
        }
        else{
            deck = createDeck()
            print(deck.count)
            return Card(rank: nil, suit: nil) // ask teacher about this one
        }
    }
    
    @IBAction func pressHit(_ sender: Any) {
        if totalWorth <= 20{
            drawCard(player: "player")
       
            bust()
        }
}
    
    @IBAction func pressStay(_ sender: Any) {
        var dealerLeftHand = cardInfo(myCard: dealerHand[1])
        leftCardDealer.text? = "\(dealerLeftHand.Name) of \(dealerLeftHand.Suit)"
        dealerHandWorth.text? = String(dealerWorth)
        if dealerWorth <= 16{
            
            while dealerWorth <= 16{
            drawCard(player: "dealer")
            bust()
            }
        }
        
        //print(dealerHand)
        print(String(totalWorth))
        print(String(dealerWorth))
         compareValue()
    }
    
    func drawCard(player:String){
        currentPlayer = player
        
        if (deck.isEmpty){
            deck = createDeck()
            print("deck reset")
        }
        
        playerPush(element: deckPop())
        
        if (currentPlayer == "player"){
            print(timesPushed)
            var thirdCard = cardInfo(myCard: playerHand[2+timesPushed])
            HitCard?.text = "\(thirdCard.Name) of \(thirdCard.Suit)"
            totalWorth = totalWorth + thirdCard.Value
            handWorth?.text = String(totalWorth)
            print(thirdCard.Name)
            timesPushed = timesPushed + 1
        }
            
        else if(currentPlayer == "dealer"){
            var thirdCard = cardInfo(myCard: dealerHand[2+timesPushedStay])
            dealerHitCard?.text = "\(thirdCard.Name) of \(thirdCard.Suit)"
            dealerWorth = dealerWorth + thirdCard.Value
            dealerHandWorth?.text = String(dealerWorth)
            print(thirdCard.Name)
            timesPushedStay = timesPushedStay + 1
        }
     
      
    }
    
    func compareValue()
    {
        //this is where i will see who wins the round
        if(dealerBust == false && playerBust == false){
            if (totalWorth > dealerWorth && totalWorth <= 21)
            {
                print("player wins")
            }
            else if(dealerWorth > totalWorth && dealerWorth <= 21)
            {
                print("dealer wins")
            }
            else if(dealerWorth == totalWorth){
                print("tie")
            }
        }
    }
    
    func bust(){
        if(totalWorth > 21){
            print("player busts")
            playerBust = true
        }
        else if (dealerWorth > 21){
            print("dealear busts")
            dealerBust = true
        }
    }
    
   
}

