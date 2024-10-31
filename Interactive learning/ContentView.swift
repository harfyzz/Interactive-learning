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
    @State var option = RiveViewModel(fileName: "option_button", stateMachineName: "main")
    var answer: Int = 0
    var value1:Int = 0
    var value2:Int = 0
    @State var choice = 0
    @State var isPressed: Bool = false
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
                        let value1 = Int.random(in: 1...20)
                        let value2 = Int.random(in: 1...20)
                        Text("\(value1) + \(value2)")
                            .font(.system(size: 55))
                            .fontWeight(.medium)
                        if isPressed {
                            let answer = value1 + value2
                            Text("\(answer)")
                                .font(.largeTitle)
                        }
                    }.foregroundStyle(Color("text.main"))
                    Spacer()
                    VStack{
                        HStack{
                            option.view()
                                .onAppear{
                                    do {
                                        try option.setTextRunValue("option text", textValue: "2")
                                    } catch {
                                        print("Error: \(error)")
                                    }
                                }
                            option.view()
                        }
                    }
                    Spacer()
                }
                .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            
        }.padding()
            .background(Color("Background"))
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
