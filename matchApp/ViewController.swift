//
//  ViewController.swift
//  matchApp
//
//  Created by Sajad on 2020-06-22.
//  Copyright © 2020 camelKase. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Collection View Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return number of cards
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        // Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Configure the state of the cell based on the properties of the card that it represents
        // Get the card form the card array
        let cardCell = cell as? CardCollectionViewCell;
        
        let card = cardsArray[indexPath.row]
        
        // configuring the cell
        cardCell?.configureCell(card: card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell;
        
        // check the status of the card to determine how to flip it
        if (cell?.card?.isFlipped == false && cell?.card?.isMatched == false) {
            // flip the card up
            cell?.flipUp();
            
            // Check if this is the first card that was flipped or the second card
                
            if (firstFlippedCardIndex == nil) {
                
                // this is the first card flipped over
                firstFlippedCardIndex = indexPath;
            } else {
                // this is the second card that is flipped
                
                // Run the comparison logic
                checkForMatch(indexPath);
            }
        }
            
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        // Get the two card objects for the two indices and see if they match
        let cardOne = cardsArray[firstFlippedCardIndex!.row];
        let cardTwo = cardsArray[secondFlippedCardIndex.row];
        
        // Get the two collection view cells that represent cardOne and cardTwo
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell;
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell;
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //It's a match
            // Set the status and remove them
            cardOne.isMatched = true;
            cardTwo.isMatched = true;
            
            cardOneCell?.remove();
            cardTwoCell?.remove();
            
        }
        else {
            // It's not a match
            cardOne.isFlipped = false;
            cardTwo.isFlipped = false;
            // Flip them back over
            cardOneCell?.flipDown();
            cardTwoCell?.flipDown();
        }
        
        // Reset the firstFlippedCardIndex Property
        firstFlippedCardIndex = nil;
    }
}

