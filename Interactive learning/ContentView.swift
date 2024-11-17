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
    
    var climber: RiveViewModel
    var mainButton:RiveViewModel
    @State var value1:Int = 0
    @State var value2:Int = 0
    @State var choice:[Int] = []
    @State var isPressed: Bool = false
    @State var answer: Int = 0
    @State var selectedChoice: Int? = nil
    @State var answerState: answerState = .idle
    @State var level:Double = 0
    var correctAnswer: Int {
            value1 + value2
        }
    var body: some View {
        ZStack {
            VStack{
                climber.view()
                    .frame(height: 511)
                    .onChange(of: level) { oldValue, newValue in
                        if level == 4 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                level = 0
                            }
                            
                        }
                        climber.setInput("Stage", value: level)
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
                    HStack {
                        Text("\(value1) + \(value2)")
                        Text("=")
                            .font(.title)
                        
                            ZStack{
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("Bg.secondary").opacity(0.5))
                                    .frame(width:86,height:56)
                                if isPressed {
                                Text("\(answer)")
                                    .contentTransition(.numericText())
                            }
                        }
                    }.foregroundStyle(Color("text.main"))
                        .font(.system(size: 45))
                        .fontWeight(.medium)
                        .contentTransition(.numericText())
                    Spacer()
                        VStack {
                            ForEach(Array(zip(choice, choiceModels)), id: \.0) { (choice, model) in
                                ZStack {
                                    Divider()
                                        .tint(Color("text.main"))
                                    optionView(option: model, choice: choice, selectedChoice: $selectedChoice, answerState: $answerState) {
                                        withAnimation {
                                            answer = choice
                                            isPressed = true
                                            selectedChoice = choice
                                        }
                                    }
                                }
                            }
                        }
                        .allowsHitTesting(answerState == .idle)
                    Spacer()
                    mainButton.view()
                        .frame(height:70)
                        .onTapGesture {
                            if answerState == .idle {
                                if answer == correctAnswer {
                                    mainButton.setInput("type", value: Double(2))
                                    answerState = .correct
                                    level = level + 1
                                } else {
                                    mainButton.setInput("type", value: Double(3))
                                    answerState = .wrong
                                }
                            } else { withAnimation {
                                answerState = .idle
                                mainButton.setInput("type", value: Double(0))
                                isPressed = false
                                selectedChoice = nil
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
            .onAppear {
                generateChoices()
            }
            .onChange(of: answerState) { _,newValue in
                if answerState == .idle {
                    generateChoices()
                }
               
            }
    }
    // Function to generate the choices, including the correct answer and three random values
    @State var choiceModels: [RiveViewModel] = []

    func generateChoices() {
        value1 = Int.random(in: 1...20)
        value2 = Int.random(in: 1...20)
        choice = [correctAnswer]
        
        // Generate unique random choices
        while choice.count < 3 {
            let randomValue = Int.random(in: 1...40)
            if !choice.contains(randomValue) {
                choice.append(randomValue)
            }
        }
        choice.shuffle() // Shuffle to randomize the position of the correct answer
        
        // Create a separate RiveViewModel for each choice
        choiceModels = choice.map { _ in RiveViewModel(fileName: "option_button", stateMachineName: "main") }
    }

}

#Preview {
    ContentView(climber: character.shared.riveImage, mainButton: character.shared.mainButton)
}

struct optionView: View {
    var option:RiveViewModel
    @State var choice: Int
    @Binding var selectedChoice: Int?
    @Binding var answerState: answerState
    @State var isPressed: Bool = false
    var action: () -> Void
    
    var body: some View {
    /*    ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Background"))
                .offset(y: -5)
            Text(String(choice))
        }.background( Color(isPressed ? "Bg.dark" : "Bg.secondary"))
            .frame(width: 300, height: 55)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(content: {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(isPressed ? "text.main" :"border"), lineWidth:1 )
            })
        .onTapGesture {
            action()
        } */
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

class character: ObservableObject {
    static let shared = character()
    let riveImage = RiveViewModel(fileName: "climber", stateMachineName: "main")
    let optionButton = RiveViewModel(fileName: "option_button", stateMachineName: "main")
    let mainButton = RiveViewModel(fileName: "main_button", stateMachineName: "main")
}
