//
//  ViewController.swift
//  Flashcard App
//
//  Created by Lilly Zhou on 10/13/18.
//  Copyright © 2018 Lilly Zhou. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var first: String
    var second: String
    var third: String
}

class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var buttonOption3: UIButton!
    @IBOutlet weak var buttonOption2: UIButton!
    @IBOutlet weak var buttonOption1: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        card.layer.cornerRadius = 20.0
        frontLabel.layer.cornerRadius = 20.0
        backLabel.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
        frontLabel.clipsToBounds = true
        backLabel.clipsToBounds = true
        
        buttonOption1.layer.borderWidth = 3.0
        buttonOption1.layer.borderColor = #colorLiteral(red: 1, green: 0.2934636772, blue: 0.4067368507, alpha: 1)
        buttonOption1.layer.cornerRadius = 20.0
        
        buttonOption2.layer.borderWidth = 3.0
        buttonOption2.layer.borderColor = #colorLiteral(red: 1, green: 0.2934636772, blue: 0.4067368507, alpha: 1)
        buttonOption2.layer.cornerRadius = 20.0
        
        buttonOption3.layer.borderWidth = 3.0
        buttonOption3.layer.borderColor = #colorLiteral(red: 1, green: 0.2934636772, blue: 0.4067368507, alpha: 1)
        buttonOption3.layer.cornerRadius = 20.0
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
        updateFlashcard(question: "What is the capital of US?", answer1: "Los Angeles", answer2: "Washington D.C.", answer3: "San Francisco")
        }else{
            updateLabels()
            updateNextPrevButtons()
        }
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as!
        CreationViewController
        creationController.flashcardsController = self
        
        if (segue.identifier == "EditSegue") {
        frontLabel.isHidden = false
        creationController.initialQuestion = frontLabel.text
        creationController.initialAnswer2 = backLabel.text
        creationController.initialAnswer1 = buttonOption1.currentTitle
        creationController.initialAnswer3 = buttonOption3.currentTitle
        }
    }
    
    @IBAction func didTapOnFlashCard(_ sender: Any) {
        if(frontLabel.isHidden == true){
            frontLabel.isHidden = false;
        }else{
            frontLabel.isHidden = true
        }
    }
    
    func updateFlashcard(question: String, answer1: String, answer2: String, answer3: String) {
        
        let flashcard = Flashcard(question: question, first: answer1, second: answer2, third: answer3)
        flashcards.append(flashcard)
        frontLabel.isHidden = false
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.second

        buttonOption1.setTitle(flashcard.first, for: .normal)
        buttonOption2.setTitle(flashcard.second, for: .normal)
        buttonOption3.setTitle(flashcard.third, for: .normal)
        
        currentIndex = flashcards.count - 1
        print("Added new flashcard")
        print("We now have \(currentIndex) flashcards")
        
        updateNextPrevButtons()
        updateLabels()
        saveALlFlashcardsToDisk()
    }
    
    @IBAction func ButtonAction1(_ sender: Any) {
        frontLabel.isHidden = false
    }
    
    @IBAction func ButtonAction2(_ sender: Any) {
        frontLabel.isHidden = true
    }
    
    @IBAction func ButtonAction3(_ sender: Any) {
        frontLabel.isHidden = false
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateLabels()
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButtons()
    }
    
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex <= 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.second
        
        buttonOption1.setTitle(currentFlashcard.first, for: .normal)
        buttonOption2.setTitle(currentFlashcard.second, for: .normal)
        buttonOption3.setTitle(currentFlashcard.third, for: .normal)
    }
    
    func saveALlFlashcardsToDisk(){
        let dictionaryArray = flashcards.map {(card) -> [String: String] in
            return ["question": card.question, "first": card.first, "second": card.second, "third": card.third]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("flashcards saved to default")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map{ dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, first: dictionary["first"]!, second: dictionary["second"]!, third: dictionary["third"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
}


