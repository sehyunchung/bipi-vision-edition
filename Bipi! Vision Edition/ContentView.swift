//
//  ContentView.swift
//  Bipi! Vision Edition
//
//  Created by Sehyun Chung on 2023/06/22.
//

import SwiftUI
import RealityKit
import RealityKitContent

var tapper = BpmTapper()

class BpmState: ObservableObject {
    @Published var interval: Double = 100_000
    @Published var intStr: String = "0"
    @Published var decimalStr: String = ""
    @Published var beat: Bool = true
}

struct ContentView: View {
    @StateObject private var bpmState = BpmState()
    
    func getBpmString(_ bpm: Double) {
        let bpmStrings: [String] = String(bpm).components(separatedBy: ".")
        bpmState.intStr = bpmStrings.first!
        bpmState.decimalStr = bpmStrings.last != "0" ? "." + bpmStrings.last! : ""
    }
    
    func tap() {
        tapper.tap()
        getBpmString(tapper.bpm)
        bpmState.interval = tapper.interval
    }

    func reset() {
        tapper.reset()
        getBpmString(tapper.bpm)
        bpmState.interval = tapper.interval
        bpmState.beat = true
    }
    
    var body: some View {
            VStack {
                ZStack(alignment:.init(horizontal: .center, vertical: .center)) {
                    Model3D(named: "Scene", bundle: realityKitContentBundle)
                        .gesture(TapGesture().onEnded {
                            _ in self.tap()
                        }).gesture(LongPressGesture().onEnded {
                            _ in self.reset()
                        })
                    HStack{
                        Text(bpmState.intStr)
                            .foregroundColor(.primary)
                        Text(bpmState.decimalStr)
                            .foregroundColor(.secondary).offset(x:-12)
                    }.offset(x:5)
                }
            }
        
    }
}

#Preview {
    ContentView()
}
