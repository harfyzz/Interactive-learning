//
//  ContentView.swift
//  Interactive learning
//
//  Created by Afeez Yunus on 31/10/2024.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    
    @State var climber = RiveViewModel(fileName: "climber", stateMachineName: "main")
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main", fit:.contain)
    @State var value1:Int = Int.random(in: 1...20)
    @State var value2:Int = Int.random(in: 1...20)
    @State var choice:[Int] = []
    @State var isPressed: Bool = false
    @State var answer: Int = 0
    var correctAnswer: Int {
            value1 + value2
        }
    var body: some View {
        ZStack {
            VStack{
                climber.view()
                    .frame(height: 511)
                Spacer()
            }
            VStack {
                Spacer()
                VStack{
                    HStack {
                        Text("\(value1) + \(value2)")
                        if isPressed {
                            Text("= \(answer)")
                                .contentTransition(.numericText())
                        }
                    }.foregroundStyle(Color("text.main"))
                        .font(.system(size: 55))
                        .fontWeight(.medium)
                        .contentTransition(.numericText())
                    LazyVGrid(columns: [GridItem(),GridItem()], spacing: 12) {
                        ForEach(choice, id: \.self) {choice in
                            optionView(choice: choice) {
                                withAnimation {
                                    answer = choice
                                    isPressed = true
                                }
                            }
                        }
                    }
                    
                }
                .frame(height: UIScreen.main.bounds.height/2)
                .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
            }
            
        }.padding()
            .background(Color("Background"))
            .ignoresSafeArea()
            .onAppear {
                generateChoices()
            }
    }
    // Function to generate the choices, including the correct answer and three random values
      func generateChoices() {
          
          choice = [correctAnswer]
          while choice.count < 4 {
              let randomValue = Int.random(in: 1...40)
              if !choice.contains(randomValue) {
                  choice.append(randomValue)
              }
          }
          choice.shuffle() // Shuffle to randomize the position of the correct answer
      }

}

#Preview {
    ContentView()
}

struct optionView: View {
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main", fit:.contain)
    @State var choice:Int
    @State var action: ()->Void
    var body: some View {
        option.view()
            .frame(height:50)
            .onAppear{
                try! option.setTextRunValue("option text", textValue: String(choice))
            }
            .onTapGesture{
                    option.triggerInput("pressed?")
                action()
            }
    }
}
