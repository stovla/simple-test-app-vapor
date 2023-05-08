//
//  ContentView.swift
//  TestApp
//
//  Created by Vlastimir Radojevic on 20.4.23..
//

import SwiftUI
import Shared

struct ContentView: View {
    
    @State var serverGreeting = ""
    let serverClient = MyServerClient()
    @State var donuts: [SharedDataModel.Donut] = []
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text(serverGreeting)
                .task {
                    do {
                        self.serverGreeting = try await serverClient.greet()
                    } catch {
                        self.serverGreeting = String(describing: error)
                    }
                }
            
            Button {
                Task {
                    donuts = try await serverClient.listDonuts()
                }
            } label: {
                Text("List Donuts in the log")
            }
            .buttonStyle(.borderedProminent)
            
            List {
                ForEach(donuts) { donut in
                    Text(donut.name)
                }
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
