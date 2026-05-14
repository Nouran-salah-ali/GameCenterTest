//
//  PlayerViewModel.swift
//  GameCenterTest
//
//  Created by nouransalah on 27/11/1447 AH.
//

import Foundation
import GameKit
 import Combine

import Foundation
import CloudKit
import GameKit

@MainActor
final class PlayerViewModel: ObservableObject {

    @Published var profile: PlayerProfile?
    private let db = CKContainer.default().publicCloudDatabase
    //private let db = CKContainer.default().privateCloudDatabase

    // MARK: - Called from onAppear

//    func loadPlayer() async {
//        let gcID = await getGameCenterID()
//        guard let gcID else { return }
//
//        if let existing = await fetchPlayer(gcID: gcID) {
//            profile = existing
//        } else {
//            await createPlayer(gcID: gcID)
//        }
//    }
    func loadPlayer() async {
        print("=== loadPlayer started ===")
        
        let gcID = await getGameCenterID()
        print("Game Center ID: \(gcID ?? "NIL - not authenticated")")
        guard let gcID else { return }

        if let existing = await fetchPlayer(gcID: gcID) {
            print("✅ Found existing player: \(existing)")
            profile = existing
        } else {
            print("🆕 No player found, creating new one...")
            await createPlayer(gcID: gcID)
            print("✅ Created: \(String(describing: profile))")
        }
    }

    // MARK: - Get Game Center ID

    private func getGameCenterID() async -> String? {
        guard GKLocalPlayer.local.isAuthenticated else { return nil }
        return GKLocalPlayer.local.gamePlayerID
    }

    // MARK: - Check + Fetch from CloudKit

    private func fetchPlayer(gcID: String) async -> PlayerProfile? {
        let predicate = NSPredicate(format: "gameCenterID == %@", gcID)
        let query = CKQuery(recordType: PlayerProfile.recordType, predicate: predicate)

        guard let results = try? await db.records(matching: query, resultsLimit: 1),
              let record = try? results.matchResults.first?.1.get() else { return nil }

        return PlayerProfile(
            gameCenterID: record["gameCenterID"] as? String ?? gcID,
            totalCoins: record["totalCoins"] as? Int64 ?? 0,
            weeklyCoins: record["weeklyCoins"] as? Int64 ?? 0,
            totalBloodBags: record["totalBloodBags"] as? Int64 ?? 0,
            totalDistance: record["totalDistance"] as? Double ?? 0.0,
            updatedAt: record["updatedAt"] as? Date ?? Date(),
            weekIdentifier: record["weekIdentifier"] as? String ?? ""
        )
    }

    // MARK: - Create New Player

    private func createPlayer(gcID: String) async {
        let newProfile = PlayerProfile(gameCenterID: gcID)
//fill it the data shape
        let record = CKRecord(recordType: PlayerProfile.recordType)
        record["gameCenterID"] = gcID
        record["totalCoins"] = Int64(0)
        record["weeklyCoins"] = Int64(0)
        record["totalBloodBags"] = Int64(0)
        record["totalDistance"] = Double(0.0)
        record["updatedAt"] = Date()
        record["weekIdentifier"] = ""

        if (try? await db.save(record)) != nil {
            profile = newProfile
        }
    }
}
//// Sits between the view and the two managers.
//// The view only talks to this; it never calls GameManager or CloudKitManager directly.
//@MainActor
//final class PlayerViewModel: ObservableObject {
//
//    @Published var profile: PlayerProfile?
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//
//    // Called from .onAppear — runs the full startup flow.
//    func onAppear() {
//        Task {
//            await startupFlow()
//        }
//    }
//
//    // The three-step flow you described:
//    // 1. Authenticate with Game Center
//    // 2. Fetch profile from CloudKit
//    // 3. If not found, create a new one
//    private func startupFlow() async {
//        isLoading = true
//        defer { isLoading = false }
//
//        // Step 1: Authenticate (GameManager handles Game Center)
//        await GameManager.shared.authenticateAsync()
//
//        guard GKLocalPlayer.local.isAuthenticated else {
//            errorMessage = "Game Center authentication failed."
//            return
//        }
//
//        let gcID = GKLocalPlayer.local.gamePlayerID  // stable unique ID
//
//        do {
//            // Step 2: Try to fetch existing profile
//            if let existing = try await CloudKitManager.shared.fetchProfile(gameCenterID: gcID) {
//                profile = existing
//                print("CloudKit: Loaded profile for \(gcID)")
//
//            } else {
//                // Step 3: First launch — create a fresh profile
//                let newProfile = PlayerProfile.newProfile(for: gcID)
//                profile = try await CloudKitManager.shared.createProfile(newProfile)
//                print("CloudKit: Created new profile for \(gcID)")
//            }
//        } catch {
//            errorMessage = "Could not load your profile: \(error.localizedDescription)"
//            print("CloudKit error: \(error)")
//        }
//    }
//
//    // Call this after any local change (e.g. coin collected) to persist.
//    func save() {
//        guard let profile else { return }
//        Task {
//            do {
//                try await CloudKitManager.shared.saveProfile(profile)
//            } catch {
//                print("CloudKit save error: \(error)")
//            }
//        }
//    }
//
//    // Example mutation — add this pattern for every stat update.
//    func addCoin() {
//        profile?.totalCoins += 1
//        profile?.weeklyCoins += 1
//        save()
//    }
//}
