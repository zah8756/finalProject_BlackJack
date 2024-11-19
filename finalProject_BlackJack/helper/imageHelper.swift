//
//  imageHelper.swift
//  finalProject_BlackJack
//
//  Created by zach on 5/1/19.
//  Copyright © 2019 zach. All rights reserved.
//

import UIKit

// this classis used to create an array of my images so that they can be attached to each card

class imageHelper{
    var imageName:[UIImage]
    
    init(imageN:[UIImage]) {
        self.imageName = imageN
    }
    convenience init(){
        var imageArray = [UIImage]()
        var i = 2
        let suite = ["C","H","D","S"]
        
        for suites in suite{
        while (i <= 10){
            imageArray += [UIImage(named: "\(i)\(suites)")!]
            i += 1
        }
        imageArray += [UIImage(named: "J\(suites)")!, UIImage(named: "Q\(suites)")!,UIImage(named: "K\(suites)")!,UIImage(named:"A\(suites)")!]
        i = 2
            
        
    }
        self.init(imageN: imageArray)
    }
    
    //this function is used to match each card image to its corresopding card in the deck array 
    
    func findCardImage(suite:String,rank:Int) -> UIImage{
        if(suite == "Club"){
            return imageName[rank-2]
        }
        else if(suite == "Heart"){
            return imageName[rank+11]
        }
        else if(suite == "Diamond"){
           return imageName[rank+24]
        }
        else if(suite == "Spade")
        {
            return imageName[rank+37]
        }
        else{
            return imageName[0]
        }
        
    }
}
    

