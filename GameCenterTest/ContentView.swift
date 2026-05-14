//
//  ContentView.swift
//  GameCenterTest
//
//  Created by nouransalah on 19/11/1447 AH.
//

import SwiftUI
//
import SwiftUI
import GameKit
//struct ContentView: View {
//    @StateObject private var vm = PlayerViewModel()
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            if vm.isLoading {
//                ProgressView("Loading profile…")
//            } else {
//                Text("Coins: \(vm.profile?.totalCoins ?? 0)")
//                    .font(.title2)
//
//                Button("Leaderboard") {
//                    GameManager.shared.showLeaderboards()
//                }
//
//                Button("Collect Coin") {
//                    vm.addCoin()
//                    // Also submit to Game Center leaderboard
//                    GameManager.shared.submitScore(
//                        Int(vm.profile?.totalCoins ?? 0),
//                        to: GameManager.leaderboardID
//                    )
//                }
//
//                if let error = vm.errorMessage {
//                    Text(error).foregroundStyle(.red).font(.caption)
//                }
//            }
//
//        }
//        .padding()
//        .onAppear { vm.onAppear() }
//    }
//}
struct ContentView: View {
    @AppStorage("cookieCount") private var coinCount: Int = 0
    @StateObject private var vm = PlayerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            
            //1
            Button {
                GameManager.shared.showLeaderboards()
            } label: {
                Text("Leaderboard")
                    .font(.headline)
            
            }
            .buttonStyle(.plain)
            .scaleEffect(1.0)
            

            
            
            //2
     
            Button {
                coinCount += 1;  print("Coin clicked")
            }label: {
                Text("Coin")
                    .font(.headline)
                }
                .buttonStyle(.plain)
                .scaleEffect(1.0)
            

            //3
            Button {
                GameManager.shared.submitScore(coinCount , to: GameManager.leaderboardID );  print("submit")
            }label: {
                Text("Submit Score")
                    .font(.headline)
                }
                .buttonStyle(.plain)
                .scaleEffect(1.0)
            
        }//v
        .padding()
        .onAppear {
            Task {
                await GameManager.shared.authenticateAsync() // wait for auth to finish
                await vm.loadPlayer()                        // then load player
            }
        }
    }
}



#Preview {
    ContentView()
}
