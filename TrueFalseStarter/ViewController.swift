//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
        
    var gameSound: SystemSoundID = 0
    
       
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var buttons: UIStackView!
 
    

    let questionDictionary = trivia[indexOfSelectedQuestion]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayQuestion() {
        
        
        indexOfSelectedQuestion = order[nextQuestion]
        let questionDictionary = trivia[indexOfSelectedQuestion]
        //Checks to make sure that the question order is random, and that no question repeats
        print(order)
        print(indexOfSelectedQuestion)
        
        questionField.text = questionDictionary.question
        
        let randomChoices = randomizeAnswerChoices(for: questionDictionary)

        aButton.setTitle(questionDictionary.answerChoices[randomChoices[0]], for: .normal)
        bButton.setTitle(questionDictionary.answerChoices[randomChoices[1]], for: .normal)
        cButton.setTitle(questionDictionary.answerChoices[randomChoices[2]], for: .normal)
        dButton.setTitle(questionDictionary.answerChoices[randomChoices[3]], for: .normal)
        
        playAgainButton.isHidden = true
        
        nextQuestion += 1
    }
    
    
    func displayScore() {
        // Hide the answer buttons
        aButton.isHidden = true
        bButton.isHidden = true
        cButton.isHidden = true
        dButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        
        if (sender.currentTitle == correctAnswer) {
            correctQuestions += 1
            questionField.text = "Correct!"
        } else {
            questionField.text = "Sorry, wrong answer!"
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    /*
     'correctAnswer' holds the string value of the answer to the question
     check to see if the sender has a title that matches the answer
     */
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        aButton.isHidden = false
        bButton.isHidden = false
        cButton.isHidden = false
        dButton.isHidden = false
        
        
        questionsAsked = 0
        correctQuestions = 0
        nextQuestion = 0
        order = randomizeQuestionOrder(in: trivia)
        nextRound()
    }
    

    
    // MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

