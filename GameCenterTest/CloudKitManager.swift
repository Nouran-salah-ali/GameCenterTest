////
////  CloudKitManager.swift
////  GameCenterTest
////
////  Created by nouransalah on 27/11/1447 AH.
////
//
//import Foundation
//import CloudKit
//
//// Responsible for all CloudKit operations: fetch, create, save.
//// Never touches GameKit directly — GameManager owns that.
//final class CloudKitManager {
//
//    static let shared = CloudKitManager()
//    private init() {}
//
//    // Using the private database: data belongs to the user, not publicly visible.
//    private let db = CKContainer.default().privateCloudDatabase
//
//    // MARK: - Fetch
//
//    // Check if a profile exists for this Game Center ID.
//    // Returns the profile if found, nil if the player is new.
//    func fetchProfile(gameCenterID: String) async throws -> PlayerProfile? {
//        let predicate  = NSPredicate(format: "%K == %@", CKKeys.gameCenterID, gameCenterID)
//        let query      = CKQuery(recordType: CKKeys.recordType, predicate: predicate)
//
//        let (results, _) = try await db.records(matching: query, resultsLimit: 1)
//
//        // results is [(CKRecord.ID, Result<CKRecord, Error>)]
//        for (_, result) in results {
//            let record = try result.get()          // re-throws any per-record error
//            return PlayerProfile(from: record)     // nil if record is malformed
//        }
//
//        return nil  // No matching record → new player
//    }
//
//    // MARK: - Create
//
//    // Save a brand-new profile to CloudKit.
//    // Call this only after fetchProfile returns nil.
//    @discardableResult
//    func createProfile(_ profile: PlayerProfile) async throws -> PlayerProfile {
//        let record = CKRecord(recordType: CKKeys.recordType)
//        profile.apply(to: record)
//        let saved = try await db.save(record)
//        return PlayerProfile(from: saved) ?? profile
//    }
//
//    // MARK: - Save (update existing)
//
//    // Overwrite all fields of an existing record.
//    // Fetches the live record first so we don't stomp concurrent changes.
//    func saveProfile(_ profile: PlayerProfile) async throws {
//        let predicate  = NSPredicate(format: "%K == %@", CKKeys.gameCenterID, profile.gameCenterID)
//        let query      = CKQuery(recordType: CKKeys.recordType, predicate: predicate)
//        let (results, _) = try await db.records(matching: query, resultsLimit: 1)
//
//        for (_, result) in results {
//            let record = try result.get()
//            profile.apply(to: record)
//            try await db.save(record)
//            return
//        }
//
//        // Fallback: record disappeared — create it fresh.
//        try await createProfile(profile)
//    }
//}
