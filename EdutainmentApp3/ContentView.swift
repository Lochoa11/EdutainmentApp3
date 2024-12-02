//
//  ContentView.swift
//  EdutainmentApp3
//
//  Created by Lin Ochoa on 11/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var multiplicationNumber: Int = 2
    @State private var randomNumbers: [Int] = []
    @State private var numberOfQuestions: Int = 5
    @State private var gameStarted: Bool = false
    
    @State private var showingQuestion: Bool = false
    @State private var answer: Int? = nil
    @State private var positionInArray = 0
    
    @State private var showingResult: Bool = false
    @State private var resultTitle: String = ""
    @State private var resultMessage: String = ""
    
    @State private var numberOfCorrectAnswers: Int = 0
    
    @State private var showingScore: Bool = false
    @State private var scoreTitle: String = ""
    @State private var scoreMessage: String = ""
    
    
    var body: some View {
        VStack {
            if !gameStarted {
                VStack {
                    Text("Select times table number: \(multiplicationNumber)")
                    Stepper("Select times table number", value: $multiplicationNumber, in: 2...12)
                        .labelsHidden()
                        .background(.white)
                        .cornerRadius(20)
                        .padding(20)
                    Text("Select number of questions: \(numberOfQuestions)")
                    Stepper("Select number of questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...30, step: 5)
                        .labelsHidden()
                        .background(.white)
                        .cornerRadius(20)
                        .padding(20)
                    Button("Start Game") {
                        generateQuestions()
                        withAnimation {
                            gameStarted.toggle()
                        }
                    }
                    .frame(width: 100, height: 30)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(20)
                }
                .padding(20)
                .background(.gray)
                .transition(.scale)
                .cornerRadius(20)
            } else {
                VStack {
                    Text("\(multiplicationNumber) x \(getRandomNumber()) = ?")
                    TextField("Answer", value: $answer, format: .number)
                        .keyboardType(.numberPad)
                        .padding(10)
                        .background(.white)
                        .cornerRadius(20)
                    Button("Submit") {
                        checkAnswer()
                    }
                    .padding(10)
                    .background(.white)
                    .cornerRadius(20)
                    .disabled(answer == nil ? true : false)
                }
                .padding(20)
                .background(.red)
                .transition(.scale)
                .cornerRadius(20)
            }
            
        }
        .padding()
        .alert(resultTitle, isPresented: $showingResult) {
            Button("OK") {
                showingResult = false
                checkIfOver()
                nextQuestion()
            }
        } message: {
            Text(resultMessage)
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("OK") {
                showingScore = false
                withAnimation {
                    gameStarted.toggle()
                }
                resetGame()
            }
        } message: {
            Text(scoreMessage)
        }
    }
    
    func generateQuestions() {
        for _ in 0..<numberOfQuestions {
            randomNumbers.append(Int.random(in: 2...12))
        }
    }
    
    func getRandomNumber() -> Int {
        print("random number: \(randomNumbers)")
        print("position: \(positionInArray)")
        let number = randomNumbers[positionInArray]
        return number
    }
    
    func checkAnswer() {
        if answer == multiplicationNumber * randomNumbers[positionInArray] {
            resultTitle = "Correct!"
            resultMessage = "You are right!"
            numberOfCorrectAnswers += 1
        } else {
            resultTitle = "Wrong!"
            resultMessage = "That's not correct. The correct answer is \(multiplicationNumber) x \(randomNumbers[positionInArray]) = \(multiplicationNumber * randomNumbers[positionInArray])"
        }
        showingResult = true
    }
    
    func nextQuestion() {
        if positionInArray < randomNumbers.count {
            positionInArray += 1
        }
        answer = nil
    }
    
    func checkIfOver() {
        if positionInArray == randomNumbers.count - 1 {
            showingScore = true
            scoreTitle = "Game Over!"
            scoreMessage = "You got \(numberOfCorrectAnswers) out of \(numberOfQuestions) correct."
        }
    }
    
    func resetGame() {
        gameStarted = false
        positionInArray = 0
        numberOfCorrectAnswers = 0
        randomNumbers = []
    }
}

#Preview {
    ContentView()
}
