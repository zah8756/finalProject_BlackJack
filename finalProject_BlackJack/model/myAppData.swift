//
//  myAppData.swift
//  finalProject_BlackJack
//
//  Created by zach on 4/27/19.
//  Copyright © 2019 zach. All rights reserved.
//



import UIKit


//This class is used to sotre my the money found in my back even if the game closes 
class MyAppData{
    static let shared = MyAppData()
    let bankKey = "bankKey"
    
    var bankTotal:Int = 20{
        didSet{
            let defaults = UserDefaults.standard
            defaults.set(bankTotal, forKey: bankKey)
        }
    }
    
    private init(){
        readDefaultsData()
    }
    
    private func readDefaultsData(){
        let defaults = UserDefaults.standard
        bankTotal = defaults.integer(forKey: bankKey)
    }
    
}
