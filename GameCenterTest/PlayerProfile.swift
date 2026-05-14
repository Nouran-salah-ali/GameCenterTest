//
//  mode;player.swift
//  GameCenterTest
//
//  Created by nouransalah on 27/11/1447 AH.
//

//
//  modelplayer.swift
//  icloude_test1
//
//  Created by nouransalah on 27/11/1447 AH.
//
//
import Foundation
import CloudKit
//
import CloudKit

struct PlayerProfile {
    var gameCenterID: String
    var totalCoins: Int64 = 0
    var weeklyCoins: Int64 = 0
    var totalBloodBags: Int64 = 0
    var totalDistance: Double = 0.0
    var updatedAt: Date = Date()
    var weekIdentifier: String = ""

    static let recordType = "PlayerProfile"
}
//import Foundation
//import CloudKit
//
//// Pure value type — no CloudKit logic lives here.
//// This is just the shape of your data.
//struct PlayerProfile {
//    var gameCenterID: String
//    var totalCoins: Int64       = 0
//    var weeklyCoins: Int64      = 0
//    var totalBloodBags: Int64   = 0
//    var totalDistance: Double   = 0.0
//    var updatedAt: Date         = Date()
//    var weekIdentifier: String  = currentWeekIdentifier()
//
//    // Convenience: build a fresh profile for a new player.
//    static func newProfile(for gameCenterID: String) -> PlayerProfile {
//        PlayerProfile(gameCenterID: gameCenterID)
//    }
//
//    // Build a PlayerProfile from a CloudKit record.
//    // Returns nil if the required gameCenterID field is missing.
//    init?(from record: CKRecord) {
//        guard let id = record[CKKeys.gameCenterID] as? String else { return nil }
//        self.gameCenterID    = id
//        self.totalCoins      = record[CKKeys.totalCoins]      as? Int64  ?? 0
//        self.weeklyCoins     = record[CKKeys.weeklyCoins]     as? Int64  ?? 0
//        self.totalBloodBags  = record[CKKeys.totalBloodBags]  as? Int64  ?? 0
//        self.totalDistance   = record[CKKeys.totalDistance]   as? Double ?? 0.0
//        self.updatedAt       = record[CKKeys.updatedAt]       as? Date   ?? Date()
//        self.weekIdentifier  = record[CKKeys.weekIdentifier]  as? String ?? Self.currentWeekIdentifier()
//    }
//
//    // Plain memberwise init (used by newProfile).
//    init(gameCenterID: String) {
//        self.gameCenterID = gameCenterID
//    }
//
//    // Write this profile's values into a CKRecord.
//    func apply(to record: CKRecord) {
//        record[CKKeys.gameCenterID]   = gameCenterID
//        record[CKKeys.totalCoins]     = totalCoins
//        record[CKKeys.weeklyCoins]    = weeklyCoins
//        record[CKKeys.totalBloodBags] = totalBloodBags
//        record[CKKeys.totalDistance]  = totalDistance
//        record[CKKeys.updatedAt]      = updatedAt
//        record[CKKeys.weekIdentifier] = weekIdentifier
//    }
//
//    // Helper: "2025-W22" style string so you can reset weekly coins on a new week.
//    static func currentWeekIdentifier() -> String {
//        let cal  = Calendar(identifier: .iso8601)
//        let week = cal.component(.weekOfYear, from: Date())
//        let year = cal.component(.yearForWeekOfYear, from: Date())
//        return "\(year)-W\(week)"
//    }
//}
//
//// CloudKit field name constants — unchanged.
//enum CKKeys {
//    static let recordType      = "PlayerProfile"
//    static let gameCenterID    = "gameCenterID"
//    static let totalCoins      = "totalCoins"
//    static let weeklyCoins     = "weeklyCoins"
//    static let totalBloodBags  = "totalBloodBags"
//    static let totalDistance   = "totalDistance"
//    static let updatedAt       = "updatedAt"
//    static let weekIdentifier  = "weekIdentifier"
//}
////struct PlayerProfile {
////    
////    var gameCenterID: String
////    
////    // Permanent progression
////    var totalCoins: Int64
////    var weeklyCoins: Int64
////    var totalBloodBags: Int64
////    
////    // Stats
////    var totalDistance: Double
////    
////    // Sync
////    var updatedAt: Date
////    var weekIdentifier: String
////}
////
////enum CKKeys {
////    
////    static let recordType = "PlayerProfile"
////    
////    static let gameCenterID = "gameCenterID"
////    static let totalCoins = "totalCoins"
////    static let weeklyCoins = "weeklyCoins"
////    static let totalBloodBags = "totalBloodBags"
////    
////    static let totalDistance = "totalDistance"
////    
////    static let updatedAt = "updatedAt"
////    static let weekIdentifier = "weekIdentifier"
////}
////
////import CloudKit
////
////func createNewPlayer(gameCenterID: String) -> CKRecord {
////    
////    let record = CKRecord(recordType: CKKeys.recordType)
////    
////    record[CKKeys.gameCenterID] = gameCenterID
////    record[CKKeys.totalCoins] = Int64(0)
////    record[CKKeys.weeklyCoins] = Int64(0)
////    record[CKKeys.totalBloodBags] = Int64(0)
////    
////    record[CKKeys.totalDistance] = Double(0)
////    
////    record[CKKeys.updatedAt] = Date()
////    record[CKKeys.weekIdentifier] = currentWeekIdentifier()
////    
////    return record
////}
////func currentWeekIdentifier() -> String {
////    
////    let calendar = Calendar.current
////    
////    let week = calendar.component(.weekOfYear, from: Date())
////    let year = calendar.component(.yearForWeekOfYear, from: Date())
////    
////    return "\(year)-W\(week)"
////}
////
////
////struct RunResult {
////    
////    var collectedCoins: Int64
////    var collectedBloodBags: Int64
////    
////    var distance: Double
////    var kcal: Double
////}
////func updatePlayerRecord(
////    record: CKRecord,
////    result: RunResult
////) {
////    
////    // Weekly reset check
////    let currentWeek = currentWeekIdentifier()
////    
////    if record[CKKeys.weekIdentifier] as? String != currentWeek {
////        
////        record[CKKeys.weeklyCoins] = Int64(0)
////        record[CKKeys.weekIdentifier] = currentWeek
////    }
////    
////    // Current totals
////    let currentCoins =
////        record[CKKeys.totalCoins] as? Int64 ?? 0
////    
////    let currentWeeklyCoins =
////        record[CKKeys.weeklyCoins] as? Int64 ?? 0
////    
////    let currentBloodBags =
////        record[CKKeys.totalBloodBags] as? Int64 ?? 0
////    
////    let currentDistance =
////        record[CKKeys.totalDistance] as? Double ?? 0
////
////    
////    // Update totals
////    record[CKKeys.totalCoins] =
////        currentCoins + result.collectedCoins
////    
////    record[CKKeys.weeklyCoins] =
////        currentWeeklyCoins + result.collectedCoins
////    
////    record[CKKeys.totalBloodBags] =
////        currentBloodBags + result.collectedBloodBags
////    
////    record[CKKeys.totalDistance] =
////        currentDistance + result.distance
////    
////
////    
////    record[CKKeys.updatedAt] = Date()
////}
