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

@available(iOS 10.0, *)
class ViewController: UIViewController {
    
        
    var gameSound: SystemSoundID = 0
    
       
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var bButton: UIButton!
    @IBOutlet weak var cButton: UIButton!
    @IBOutlet weak var dButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerResult: UILabel!
    @IBOutlet weak var buttons: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
 
    var answerButtons = [UIButton]()
    var correctAnswer: String = ""
    var timeRemaining = 15
    var lightningModeTimer: Timer!


    let questionDictionary = trivia[indexOfSelectedQuestion]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSoundWith(name: "GameSound", ofFileType: "wav")
        
        // Start game
        playGameSound()
        displayQuestion()
        dopeButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func displayQuestion() {
        timeRemaining = 15
        answerResult.isHidden = true
        displayTimer()
        
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
        
        answerButtons = [
            aButton, bButton, cButton, dButton
        ]
        
        hideEmptyButton()
        playAgainButton.isHidden = true
        buttonsBeforeSelection()
        
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
        
        lightningModeTimer.invalidate()
        
        answerResult.isHidden = false
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        correctAnswer = selectedQuestionDict.answer
        
        if (sender.currentTitle == correctAnswer) {
            correctQuestions += 1
            answerResult.text = "Correct!"
            rightAnswerSound()
        } else {
            answerResult.text = "Sorry, wrong answer!"
            wrongAnswerSound()
        }
        
        buttonsAfterSelected()
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func noAnswer() {
        questionsAsked += 1
        
        answerResult.isHidden = false
        answerResult.text = "Times Up!"
        
        wrongAnswerSound()
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        correctAnswer = selectedQuestionDict.answer
        
        buttonsAfterSelected()
        loadNextRoundWithDelay(seconds: 2)
    }

    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            answerResult.isHidden = true 
            displayScore()
            rightAnswerSound()
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
    
    

    // MARK: Button Designs
    
    func dopeButtons() {
        for button in answerButtons {
            button.layer.cornerRadius = 10
        }
    }
    
    func buttonsBeforeSelection() {
        for button in answerButtons {
            button.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 0/255, alpha: 1)
            button.setTitleColor(UIColor.yellow, for: .normal)
            button.isEnabled = true
        }
    }
    
    func buttonsAfterSelected () {
        for button in answerButtons {
            button.backgroundColor = UIColor(red: 0/255, green: 102/255, blue: 0/255, alpha: 1)
            button.isEnabled = false
            if button.currentTitle == correctAnswer {
                button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1) , for: .normal)
            } else {
                button.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 0/255, alpha: 1), for: .normal)
            }
        }
        
    }
    
    func correctButton() {
        for button in answerButtons {
            if button.currentTitle == correctAnswer {
                button.setTitleColor(UIColor.white, for: .normal)
            }
        }
    }
    
    
    func hideEmptyButton() {
        for button in answerButtons {
            if button.currentTitle == nil {
                if let indexOfBlankButton = answerButtons.index(of: button) {
                    buttons.arrangedSubviews[indexOfBlankButton].isHidden = true
                }
            } else {
                button.isHidden = false
            }
        }
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
    
    func loadSoundWith(name: String, ofFileType: String) {
        let pathToSoundFile = Bundle.main.path(forResource: name, ofType: ofFileType)
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }

    func playGameSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func rightAnswerSound() {
        loadSoundWith(name: "applause", ofFileType: "wav")
        playGameSound()
    }
    
    func wrongAnswerSound() {
        loadSoundWith(name: "aah", ofFileType: "wav")
        playGameSound()
    }
    
    func countdown() {
        timeRemaining -= 1
        timerLabel.text = "\(timeRemaining)"
        if timeRemaining == 0 {
            lightningModeTimer.invalidate()
            noAnswer()
        }
    }
    
    func displayTimer() {
        
        lightningModeTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
}











