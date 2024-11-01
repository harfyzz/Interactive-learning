//
//  ContentView.swift
//  Interactive learning
//
//  Created by Afeez Yunus on 31/10/2024.
//

import SwiftUI
import RiveRuntime

enum answerState: String, CaseIterable {
    case idle
    case correct
    case wrong
}


struct ContentView: View {
    
    @State var climber = RiveViewModel(fileName: "climber", stateMachineName: "main")
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main", fit:.contain)
    @State var mainButton = RiveViewModel(fileName: "main_button", stateMachineName: "main", fit:.contain)
    @State var isPressed: Bool = false
    @State var answer: String = ""
    @State var selectedChoice: Int? = nil
    @State var answerState: answerState = .idle
    @State var stage:Double = 0
    @State var level = 1
    @State var correctAnswer = ""
    var body: some View {
        ZStack {
            VStack{
                
                climber.view()
                    .frame(height: 511)
                    .onChange(of: stage) { oldValue, newValue in
                        if stage == 4 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                stage = 0
                            }
                            
                        }
                        climber.setInput("Stage", value: stage)
                    }
                    .onChange(of: answerState) { oldValue, newValue in
                        if newValue == .wrong {
                            climber.triggerInput("wrong?")
                        }
                    }
                
                Spacer()
            }
            VStack {
                Spacer()
                VStack{
                    if level == 1 {
                        Level01(isPressed: $isPressed, answerState: $answerState, correctAnswer: $correctAnswer)
                            .transition(.slide)
                    } else if level == 2 {
                        Level02(isPressed: $isPressed, answerState: $answerState, correctAnswer: $correctAnswer)
                            .transition(.slide)
                    } else if level == 3 {
                        Level03(isPressed: $isPressed, answerState: $answerState, correctAnswer: $correctAnswer)
                            .transition(.slide)
                    }
                   
                    Spacer()
                    mainButton.view()
                        .frame(height:70)
                        .onTapGesture {
                            if answerState == .idle {
                                if answer == correctAnswer {
                                    mainButton.setInput("type", value: Double(2))
                                    answerState = .correct
                                    stage += 1
                                } else {
                                    mainButton.setInput("type", value: Double(3))
                                    answerState = .wrong
                                    print(correctAnswer)
                                    print(answer)
                                }
                            } else { withAnimation {
                                answerState = .idle
                                mainButton.setInput("type", value: Double(0))
                                isPressed = false
                                selectedChoice = nil
                                level += 1
                            }
                            }
                        }
                        .onChange(of: isPressed) { oldValue, newValue in
                            if isPressed {
                                mainButton.setInput("type", value: Double(1))
                            }
                        }
                }
                .padding(.vertical, 32)
                .frame(height: UIScreen.main.bounds.height/2)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 32))
                .shadow(color:Color("text.main").opacity(0.1), radius: 20)
                
            }
            
        }.padding()
            .background(Color("Background"))
            .ignoresSafeArea()
            .preferredColorScheme(.light)
        /*
         .onAppear {
         generateChoices()
         }
         .onChange(of: answerState) { _,newValue in
         if answerState == .idle {
         generateChoices()
         }
         
         } */
    }
    // Function to generate the choices, including the correct answer and three random values
 /*   func generateChoices() {
        value1 = Int.random(in: 1...20)
        value2 = Int.random(in: 1...20)
        choice = [correctAnswer]
        while choice.count < 3 {
            let randomValue = Int.random(in: 1...40)
            if !choice.contains(randomValue) {
                choice.append(randomValue)
            }
        }
        choice.shuffle() // Shuffle to randomize the position of the correct answer
    } */
    
}

#Preview {
    ContentView()
}

struct optionView: View {
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main", fit: .contain)
    @State var choice: String
    @Binding var selectedChoice: String?
    @Binding var answerState: answerState
    var action: () -> Void
    
    var body: some View {
        option.view()
            .frame(height: 55)
            .onAppear {
                try! option.setTextRunValue("option text", textValue: String(choice))
            }
            .onTapGesture {
                option.setInput("state", value: Double(1))
                action()
            }
            .onChange(of: selectedChoice) { _, newValue in
                if newValue != choice {
                    option.setInput("state", value: Double(0)) // Reset unselected options
                }
            }
            .onChange(of: answerState) { _, newValue in
                if selectedChoice == choice {
                    if newValue == .correct {
                        option.setInput("state", value: Double(2))
                    } else if answerState == .wrong {
                        option.setInput("state", value: Double(3))
                    }
                }
            }
    }
}
