//
//  Level01.swift
//  Interactive learning
//
//  Created by Afeez Yunus on 01/11/2024.
//

import SwiftUI
import RiveRuntime

struct Level03: View {
    
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main", fit:.contain)
    @State var choice:[String] = ["38","37","39"]
    @Binding var isPressed: Bool
    @State var answer: String = ""
    @State var selectedChoice: String? = nil
    @Binding var answerState: answerState
    @Binding var correctAnswer: String
    var body: some View {
        VStack {
                HStack {
                    Text("28 - 10 ")
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
                    VStack {
                        ForEach(choice, id: \.self) {choice in
                            ZStack {
                                Divider()
                                    .tint(Color("text.main"))
                                optionView(choice: choice, selectedChoice: $selectedChoice, answerState: $answerState) {
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
                    .onAppear{
                        correctAnswer = "18"
                    }
                
        }
    }
}

#Preview {
    Level01( isPressed: Binding.constant(false), answerState: Binding.constant(.idle), correctAnswer: Binding.constant("18"))
}
