//
//  gamemanger.swift
//  GameCenterTest
//
//  Created by nouransalah on 22/11/1447 AH.
//

import UIKit
import GameKit
import SwiftUI

// - UIKit not exist in pure macOS apps.

import UIKit // UIKit is the UI framework for iOS/tvOS; it's not available on macOS.
import CloudKit


// Why have a manager?
// - Keeps GameKit APIs isolated from view code so SwiftUI views stay simple.
final class GameManager: NSObject {
    // Inherit from NSObject for GameKit because it use object c
    //com.example.yourapp.totalScore
    static let leaderboardID = "vvvvv"


    // Shared singleton instance.
    // Why singleton?
    // - Game Center state is global (one local player, one access point), so a single instance is practical.
    // - Simplifies access from anywhere (views, managers) without passing references around.
    static let shared = GameManager()

    // Private initializer enforces singleton usage.
    // Note: override is required because we inherit from NSObject.
    private override init() {}

    // Authenticate the local player.
    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            // The type of `viewController` is platform-specific:
            // - On iOS it's a UIViewController (UIKit).
            // - On macOS it's an NSViewController (AppKit).
            // We forward it to `present(...)` which wraps the correct UIKit/AppKit presentation per platform.
            if let viewController = viewController {
                self?.present(viewController)
                return
            }

            if let error = error {
                print("Game Center auth error: \(error.localizedDescription)")
            }

            if GKLocalPlayer.local.isAuthenticated {
                #if os(iOS)
                // Configure the access point for iOS
                GKAccessPoint.shared.location = .topLeading
                GKAccessPoint.shared.isActive = true
                #elseif os(macOS)
                // Activate the access point on macOS
                GKAccessPoint.shared.isActive = true
                #endif
                print("Game Center: Player authenticated as \(GKLocalPlayer.local.displayName)")
            } else {
                print("Game Center: Player not authenticated.")
            }
        }
    }
    // Add inside GameManger — an async wrapper around the callback-based API.
    func authenticateAsync() async {
        await withCheckedContinuation { continuation in
            GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
                if let viewController = viewController {
                    self?.present(viewController)
                    // Don't resume yet — wait for the handler to fire again after the user signs in.
                    return
                }
                continuation.resume()   // authenticated or failed — either way, we're done waiting
            }
        }
    }

    // Present the system leaderboards UI.
    // Why gate on authentication?
    // - The controller requires an authenticated local player. If not authenticated,
    //   we trigger authenticate() and return.
    func showLeaderboards() {
        guard GKLocalPlayer.local.isAuthenticated else {
            authenticate()
            return
        }
        // Use the Access Point to navigate into Game Center.
        GKAccessPoint.shared.location = .topLeading
        GKAccessPoint.shared.isActive = true
        if GKAccessPoint.shared.isActive {
            // iOS 26+: trigger now requires a handler parameter; pass an empty closure to ignore completion.
            GKAccessPoint.shared.trigger(state: .leaderboards, handler: {})
        }

    }


    

    func submitScore(_ value: Int, to leaderboardID: String = GameManager.leaderboardID) {
        guard GKLocalPlayer.local.isAuthenticated else {
            authenticate()
            return
        }
        GKLeaderboard.submitScore(value, context: 0, player: GKLocalPlayer.local, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Game Center submit score error: \(error.localizedDescription)")
            } else {
                print("Game Center: Submitted score \(value) to leaderboard \(leaderboardID)")
            }
        }
    }
    
  
    // Present any UIKit controller from the top-most view controller.
    // Why not use a SwiftUI .sheet?
    // - This manager isn’t a View. Presenting here means we don’t need to thread presentation
    //   through the entire view hierarchy.
    // UIKit APIs are unavailable on macOS, so we provide two platform-specific implementations: UIKit for iOS and AppKit for macOS.
    private func present(_ viewController: UIViewController) {
        // UIKit presentation: find the top-most UIViewController and present modally.
        //Finding the "Active" Scene
        guard let root = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
            print("Game Center: Unable to find root view controller to present auth UI.")
            return
        }

        var top = root
        while let presented = top.presentedViewController {
            top = presented
        }
        top.present(viewController, animated: true)
    }


}
