//
//  ViewController.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/15/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Player view elements
    @IBOutlet weak var leftCardImage: UIImageView!
    @IBOutlet weak var rightCardImage: UIImageView!
    @IBOutlet weak var handWorth: UILabel!
    
    //dealer view elements
    @IBOutlet weak var dealerHandWorth: UILabel!
    @IBOutlet weak var leftCardDealerImage: UIImageView!
    @IBOutlet weak var rightCardDealerImage: UIImageView!
    
    //bank / beting view elements
    @IBOutlet weak var moneyBank: UITextField!
    @IBOutlet weak var currentBet: UILabel!
    
    //game turn buttons
    @IBOutlet weak var nextTurnButton: UIButton!
    @IBOutlet weak var dealCardsButton: UIButton!
    
    //betting buttons
    @IBOutlet weak var fiveChip: UIButton!
    @IBOutlet weak var tenChip: UIButton!
    @IBOutlet weak var twentyChip: UIButton!
    
    
    //player card drawn images
    @IBOutlet weak var cardDrawn_1: UIImageView!
    @IBOutlet weak var cardDrawn_2: UIImageView!
    @IBOutlet weak var cardDrawn_3: UIImageView!
    @IBOutlet weak var cardDrawn_4: UIImageView!
    @IBOutlet weak var cardDrawn_5: UIImageView!
    
    //dealer card drawn images
    @IBOutlet weak var dealerCardDrawn_1: UIImageView!
    @IBOutlet weak var dealerCardDrawn_2: UIImageView!
    @IBOutlet weak var dealerCardDrawn_3: UIImageView!
    @IBOutlet weak var dealerCardDrawn_4: UIImageView!
    @IBOutlet weak var dealerCardDrawn_5: UIImageView!
    
    //gameplay buttons
    @IBOutlet weak var stayButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    
    //winner labels
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var endGameLabel: UILabel!
    
    
    
    //card arrays including each players hand and the deck itsslef
    var playerHand = [Card]()
    var dealerHand = [Card]()
    var deck = [Card]()
    
    //used to determine current player
    var currentPlayer = String()
    
    //the value of both players hand
    var totalWorth = Int()
    var dealerWorth = Int()
    
    //this is used to determine how many times each player drew a card from the deck
    var timesPushed = 0
    var timesPushedStay = 0
    
    //how much each player bet during the turn
    var bet = 0
    
    //this is used to get the 52 card images
    var imagesArray = imageHelper()
    var cardDrawnImageArray = [UIImageView]()
    var dealerImageArray = [UIImageView]()
    
    
    //calls an instace of the model class bankBrain
    var banker:bankBrain!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        //add all of the carddrawn uiImage view elements to arrays for easier use
        cardDrawnImageArray += [cardDrawn_1,cardDrawn_2,cardDrawn_3,cardDrawn_4,cardDrawn_5]
        dealerImageArray += [dealerCardDrawn_1,dealerCardDrawn_2,dealerCardDrawn_3,dealerCardDrawn_4,dealerCardDrawn_5]
        
        
    
        //create a new deck and then shuffle that deck
        deck = createDeck()
        deck.shuffle()
        
        //banker is then given the bet and looks for the money in the back that is stored in my appdata if there is no money $100 is added to the bak
        banker = bankBrain(total: bet, bank: MyAppData.shared.bankTotal)
        
        
        banker.startGame()
        dealVisible(visible: true)
        endGameLabel.isHidden = true
        
        //sets the minumum bet to 5
        banker.bet5()
        displayTotal()
    
        moneyBank.text = "$\(banker.bank)"
        currentBet.text = "current bet $\(banker.total)"
        
    }
    
  
    

    
    //this function creates an array of card structs
    func createDeck() -> [Card]{
        var myDeck:Array = [Card]()
        let maxCard = Card.Rank.Ace.rawValue
        let Suits:Array = [Card.Suit.club.rawValue,Card.Suit.diamond.rawValue,Card.Suit.heart.rawValue,Card.Suit.spade.rawValue]
    
        for count in 2...maxCard{
            for suit in Suits{
                let theRank = Card.Rank.init(rawValue: count)
                let theSuit = Card.Suit.init(rawValue: suit)
                let theImage = imagesArray.findCardImage(suite: suit, rank: count)
                let theCard = Card(rank: theRank!, suit: theSuit!,image: theImage)
                myDeck.append(theCard)
            }
        }
        return myDeck
    }
    
    //this function is used to pull data out of any card struct and make it more manageable
    func cardInfo(myCard:Card) -> (Name:String,Suit:String,Value:Int,picture:UIImage){
        let desc = myCard.rank?.describeCard()
        let mySuit = myCard.suit?.rawValue
        let cardWorth = myCard.rank?.cardValues()
        let pictureImage = myCard.image
        let card = (desc,mySuit,cardWorth,pictureImage)
        return card as! (Name: String, Suit: String, Value: Int, picture: UIImage)
    }
    
    
    
    //this function is used to help the draw card methond add cards to players hands it also creates a new deck when the curent decks contents are used up
    func playerPush(element:Card){
        if(deck.isEmpty){
            deck = createDeck()
            deck.shuffle()
        }
        if currentPlayer == "player"{
             playerHand.append(element)
             //deckPop()
        }
        else if currentPlayer == "dealer"{
            dealerHand.append(element)
            //deckPop()
        }
       
    }
    
    //this fucntion removes cards from the bottom of the deck whenver it is called
    func deckPop() -> Card{
        if (!deck.isEmpty){
            let index = deck.count - 1
            let popedCard = deck.remove(at: index)
            return popedCard
        }
        else{
            return Card(rank: nil, suit: nil, image: nil) // ask teacher about this one
        }
    }
    
    // this function check to see if any of the win condtions have been met and if not it will call teh car card method for the player. this function activates whne the hit button is pressed
    @IBAction func pressHit(_ sender: Any) {
        if(playerHand.count == 7 || dealerHand.count == 7){
            compareValue()
        }
        if (totalWorth <= 20){
            drawCard(player: "player")
        }
        if (totalWorth >= 21){
            compareValue()
        }
      
    }
    // when the stay button is pressed the computer check to see if it is less then 16 and if it has less then 7 cards if not it draws a card the check to see who won. the fuction also revales the hiden card of the dealer
    @IBAction func pressStay(_ sender: Any) {
      dealerTurn()
    }
    
    //dohbles your current bet then checks your hand vs the dealer hand
    @IBAction func pressDoubleDown(_ sender: Any) {
        if(totalWorth<=20){
        banker.doubleDown()
        drawCard(player: "player")
        displayTotal()
        dealerTurn()
        }
        else{
            compareValue()
        }
    }
    
    
    // The big boy. first this fuction check to see if the deck is empty if so then it refils the deck. then it checks which player and adds and image coresopnding to the new card in their hand and checks which space to place that image at
    
    func drawCard(player:String){
        
        currentPlayer = player
        
        if (deck.isEmpty){
            deck = createDeck()
            deck.shuffle()
        }
        
        playerPush(element: deckPop())
        //checks which player
        if (currentPlayer == "player"){
            
            let thirdCard = cardInfo(myCard: playerHand[2+timesPushed])
            cardDrawnImageArray[timesPushed].image = thirdCard.picture
            cardDrawnImageArray[timesPushed].isHidden = false
            totalWorth = handsTotal(hand: playerHand, player: "player")
            handWorth?.text = String(totalWorth)
            timesPushed = timesPushed + 1
        }
            
        else if(currentPlayer == "dealer"){
            
            let thirdCard = cardInfo(myCard: dealerHand[2+timesPushedStay])
            dealerImageArray[timesPushedStay].image = thirdCard.picture
            dealerImageArray[timesPushedStay].isHidden = false
            dealerWorth = handsTotal(hand: dealerHand, player: "dealer")
            dealerHandWorth?.text = String(dealerWorth)
            timesPushedStay = timesPushedStay + 1
        }
      
    }
    
    //betting fuctions used to bet certain ammouns of money based on which button is pressed
    @IBAction func bet5(_ sender: Any) {
        banker.bet5()
        displayTotal()
    }
    @IBAction func bet10(_ sender: Any) {
        banker.bet10()
        displayTotal()
    }
    @IBAction func bet20(_ sender: Any) {
        banker.bet20()
        displayTotal()
    }
    
    
    
    //compare function used check to see who won the round and how they won then distributes the money accordingly
    func compareValue()
    {
        
        if(playerHand.count == 7){
            banker.winBet()
            displayTotal()
            winnerLabel.text? = "player 7 card charlie"
        }
        else if(dealerHand.count == 7)
        {
            banker.busted()
            displayTotal()
            winnerLabel.text? = "dealer 7 card charlie"
        }
        else if (dealerWorth == 21) {
            banker.busted()
            displayTotal()
            winnerLabel.text? = "dealer 21"
        }
        else if(totalWorth == 21){
            banker.winBet()
            displayTotal()
           winnerLabel.text? = "player 21"
        }
        else if(totalWorth>21){
            banker.busted()
            displayTotal()
           winnerLabel.text? = "player busts"
               
        }
        else if(dealerWorth>21){
            banker.winBet()
            displayTotal()
            winnerLabel.text? = "dealear busts"
              
        }
        else if(dealerWorth > totalWorth)
        {
            banker.busted()
            displayTotal()
            winnerLabel.text? = "dealer wins"
            
        }
        else if(dealerWorth == totalWorth){
            banker.tieBet()
            displayTotal()
            winnerLabel.text? = "tie"
    
        }
        else if (totalWorth > dealerWorth)
        {
            banker.winBet()
            displayTotal()
            winnerLabel.text? = "player wins"
        }
        nextTurnButton.isHidden = false
        winnerLabel.isHidden = false
    }
    
    //used to put money into myAppData and to display what money is in the bank and is currenly being bet
    private func displayTotal(){
        MyAppData.shared.bankTotal = banker.bank
        moneyBank.text = "$\(banker.bank)"
        currentBet.text = "current bet $\(banker.total)"
    }
    
    //the dealer checks how many cards in hand iand if he has less than 7 or has les than 16 in total value he must draw a card
    func dealerTurn(){
        let dealerLeftHand = cardInfo(myCard: dealerHand[1])
        leftCardDealerImage.image = dealerLeftHand.picture
        dealerHandWorth.text? = String(dealerWorth)
        if dealerWorth <= 16{
            while dealerWorth <= 16 && dealerHand.count <= 6{
                drawCard(player: "dealer")
            }
        }
        compareValue()
    }
    
    
    // the other big fuction first this function changes the visiblity of buttons and uilables so that all betting fetures are disabled during this part of the turn then it deals each palyer 2 cards and dispalys the players cards and dispalys 1 of the dealers cards
    func deal(){
        dealVisible(visible: false)
        nextTurnButton.isHidden = true
        winnerLabel.isHidden = true
        
        
        currentPlayer = "player"
        playerPush(element: deckPop())
        playerPush(element: deckPop())
        
        currentPlayer = "dealer"
        playerPush(element: deckPop())
        playerPush(element: deckPop())
      
        
        let rightCard = cardInfo(myCard: playerHand[1])
        let leftCard = cardInfo(myCard: playerHand[0])
        
        let dealerRightCard = cardInfo(myCard: dealerHand[0])
        
        //leftCardPlayer.text? = "\(rightCard.Name) of \(rightCard.Suit)"
        leftCardImage.image = leftCard.picture
        rightCardImage.image = rightCard.picture
        
        leftCardDealerImage.image = UIImage(named:"blue_back")
        rightCardDealerImage.image = dealerRightCard.picture
        
        totalWorth = handsTotal(hand: playerHand, player: "player")
        dealerWorth = handsTotal(hand: dealerHand, player: "dealer")
        handWorth.text? = String(totalWorth)
        dealerHandWorth.text? = "?"
    }
    //this function is used to reset the turn makeing all the betting features visible and reseting both players hands and the times they drew a card is put back to zero. this function also checks to see if the player has won or lost the game and if so gives them the ability to reset the game.
    @IBAction func goToNextTurn(_ sender: Any) {
        if (MyAppData.shared.bankTotal<500 && MyAppData.shared.bankTotal>0){
            startNewTurn()
        }
        else if (MyAppData.shared.bankTotal>500||MyAppData.shared.bankTotal<=0){
            startNewTurn()
            fiveChip.isHidden = true
            tenChip.isHidden = true
            twentyChip.isHidden = true
            currentBet.isHidden = true
            moneyBank.isHidden = true
            dealCardsButton.isHidden = true
            nextTurnButton.isHidden = false
            endGameLabel.isHidden = false
            
            if (MyAppData.shared.bankTotal>500){
                endGameLabel.text? = "You Won the game! would you like to restart?"
                nextTurnButton.setTitle("new game?", for: .normal)
            }
                
            else if (MyAppData.shared.bankTotal<=0){
                endGameLabel.text? = "You lost all your chips would you like to restart?"
                nextTurnButton.setTitle("restart game?", for: .normal)
            }
            
            MyAppData.shared.bankTotal = 100
            banker.restartGame()
        }
        
    }
    // this function hides the betting buttons and then calls the deal fucntion
    @IBAction func dealCards(_ sender: Any)
    {
        dealCardsButton.isHidden = true
        fiveChip.isHidden = true
        tenChip.isHidden = true
        twentyChip.isHidden = true
        deal()
    }
    // this function is used to minimze the use of is Hidden
    func dealVisible(visible:Bool){
        nextTurnButton.isHidden = visible
        winnerLabel.isHidden = visible
        leftCardImage.isHidden = visible
        rightCardImage.isHidden = visible
        rightCardDealerImage.isHidden = visible
        leftCardDealerImage.isHidden = visible
        handWorth.isHidden = visible
        dealerHandWorth.isHidden = visible
        stayButton.isHidden = visible
        hitButton.isHidden = visible
        doubleButton.isHidden = visible
       
    }
    // ssets up for the next turn by turing many parts of the scene back to hidden. this function also sets the minum bet and sets the times pushed back to 0
    func startNewTurn(){
        dealVisible(visible: true)
        nextTurnButton.setTitle("Next Turn", for: .normal)
        currentBet.isHidden = false
        moneyBank.isHidden = false
        endGameLabel.isHidden = true
        fiveChip.isHidden = false
        tenChip.isHidden = false
        twentyChip.isHidden = false
        dealCardsButton.isHidden = false
        cardDrawn_1.isHidden = true
        cardDrawn_2.isHidden = true
        cardDrawn_3.isHidden = true
        cardDrawn_4.isHidden = true
        cardDrawn_5.isHidden = true
        dealerCardDrawn_1.isHidden = true
        dealerCardDrawn_2.isHidden = true
        dealerCardDrawn_3.isHidden = true
        dealerCardDrawn_4.isHidden = true
        dealerCardDrawn_5.isHidden = true
        banker.bet5()
        displayTotal()
        playerHand.removeAll()
        dealerHand.removeAll()
        timesPushed = 0
        timesPushedStay = 0
    }
    
    // this fucntion is used to figure out the value of my and nad check to see if i have and acc and go over. if i do it subtracts 10 from the toatl value makeing the ace card work like an ace 
    func handsTotal(hand:[Card],player:String) -> Int{
        
        var total = 0
        var AceCount = 0
        
        for i in hand{
            let cardDisplay = cardInfo(myCard: i)
            total += cardDisplay.Value
            if (cardDisplay.Name == "Ace"){
                AceCount += 1
            }
        }
        
  
        for _ in 0..<AceCount{
            if total > 21{
                total = total - 10
                if (player == "player"){
                    handWorth?.text = String(total)
                        
                }
                else if (player == "dealer")
                {
                    dealerHandWorth?.text = String(total)
                }
            }
            else{
                break
            }
        }
        return total
    }
    
    
    
    
   
}

