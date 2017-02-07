//
//  Questions.swift
//  TrueFalseStarter
//
//  Created by Jevaughn McKenzie on 1/28/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import GameKit

let questionsPerRound = trivia.count
var questionsAsked = 0
var correctQuestions = 0
var indexOfSelectedQuestion: Int = 0
var indexOfQuestionAnswers: Int = 0
var nextQuestion = 0



class TriviaQuestion {
    let question: String
    let answer: String
    let wrongAnswer1: String
    var wrongAnswer2: String? = nil
    var wrongAnswer3: String? = nil
    let answerChoices: [String?]
    
    
    init(question: String, answer: String, wrongAnswer1: String, wrongAnswer2: String?, wrongAnswer3: String?){
        self.question = question
        self.answer = answer
        self.wrongAnswer1 = wrongAnswer1
        self.wrongAnswer2 = wrongAnswer2
        self.wrongAnswer3 = wrongAnswer3
        
         answerChoices = [
            answer, wrongAnswer1, wrongAnswer2, wrongAnswer3
        ]
    }
}



let question1 = TriviaQuestion(question: "Who was Marcus Garvey?", answer: "A renowned Black Nationalist", wrongAnswer1: "A blacksmith", wrongAnswer2: "A gospel singer", wrongAnswer3: "A painter")

let question2 = TriviaQuestion(question: "What was the name of the secret FBI taskforce that tried to discredit the Civil Rights Movement?", answer: "COINTELPRO", wrongAnswer1: "No such thing.", wrongAnswer2: "INFILTRATORS", wrongAnswer3: "The Black Panthers")

let question3 = TriviaQuestion(question: "How much do Black women make in comparison to each dollar their white male coworkers earn?", answer: "64 cents", wrongAnswer1: "70 cents", wrongAnswer2: "84 cents", wrongAnswer3: "75 cents")

let question4 = TriviaQuestion(question: "How many seats in Congress are held by women?", answer: "17%", wrongAnswer1: "34%", wrongAnswer2: "40%", wrongAnswer3: "25%")

let question5 = TriviaQuestion(question: "What is the term that was coined to describe feminism that places a special emphasis on marginalized women groups?", answer: "Womanism", wrongAnswer1: "Lesbians", wrongAnswer2: "man-haters", wrongAnswer3: "Communists")

let question6 = TriviaQuestion(question: "How can a person come to understand someone else?", answer: "Listen to them.", wrongAnswer1: "Interrupt and talk over them.", wrongAnswer2: nil, wrongAnswer3: nil)



let trivia: [TriviaQuestion] = [
    question1,
    question2,
    question3,
    question4,
    question5,
    question6
]

// sets the question order for the given round
var order = randomizeQuestionOrder(in: trivia)


// Randomizes the order that a answer choice might be shown

func randomizeAnswerChoices(for question: TriviaQuestion) -> [Int] {
    var answerChoiceIndex = [Int]()
    var counter = 0
    while counter < question.answerChoices.count{
        let indexOfQuestionAnswers = GKRandomSource.sharedRandom().nextInt(upperBound: question.answerChoices.count)
        if answerChoiceIndex.contains(indexOfQuestionAnswers) {
            continue
        } else {
            answerChoiceIndex.append(indexOfQuestionAnswers)
            counter += 1
        }
    }
    
    return answerChoiceIndex
}

// Randomizes the order questions are shown for a given round
// and prevents repetitions
func randomizeQuestionOrder(in round: [TriviaQuestion]) -> [Int] {
    var questionOrder = [Int]()
    var counter = 0
    while counter < round.count{
        let indexOfQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: round.count)
        if questionOrder.contains(indexOfQuestion) {
            continue
        } else {
            questionOrder.append(indexOfQuestion)
            counter += 1
        }
    }
    
    return questionOrder
}




















































