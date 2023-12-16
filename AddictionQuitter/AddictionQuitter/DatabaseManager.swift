//
//  DatabaseManager.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 09/12/23.
//

import SQLite3
import Foundation

class DatabaseManager {
    private let userDefaults = UserDefaults.standard
    var db:OpaquePointer?
    private let dbPath = "AddictionQuitter.sqlite"
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private static var instance: DatabaseManager?
    private init() {
        self.db = createDB()
        self.createStreakTable()
    }
    
    @discardableResult
    static func getInstance() -> DatabaseManager {
        if instance == nil {
            instance = DatabaseManager()
        }
        return instance!
    }

}

extension DatabaseManager{
    
    private func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        print(filePath)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            print("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
}
protocol StreakDB{
    func createStreakTable()
    func insertStreak(streak:Streak)
}

extension DatabaseManager: StreakDB{
    func createStreakTable() {
        let createTableQuery = """
                CREATE TABLE IF NOT EXISTS Streaks(
                        ID INTEGER PRIMARY KEY NOT NULL,
                       createdTime TEXT NOT NULL,
                       reason TEXT NOT NULL,
                       category INTEGER NOT NULL
                );
            """
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Streaks table created.")
            } else {
                print("Streaks table could not be created.")
            }
        } else {
            print("Streaks CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertStreak(streak: Streak) {
        userDefaults.setValue(streak.id, forKey: "streaksCount")
        let insertQuery = """
            INSERT INTO Streaks(ID, createdTime, reason, category)
            VALUES (?, ?, ?, ?);
        """
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            let streakID = Int32(streak.id)  // Convert to Int32
            let streakCreatedTime = streak.timeDate.timeIntervalSinceReferenceDate
            let streakReason = streak.reason
            let streakCategory = streak.category

            // Bind parameters
            sqlite3_bind_int(insertStatement, 1, streakID)
            sqlite3_bind_double(insertStatement, 2, streakCreatedTime)
            sqlite3_bind_text(insertStatement, 3, streakReason, -1, nil)
            sqlite3_bind_text(insertStatement, 4, streakCategory, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Streak inserted!")
            } else {
                print("Not inserted")
            }
            sqlite3_finalize(insertStatement)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("Error preparing statement: \(errorMessage)")
        }
    }

    
    
   
    
    func fetchStreak(completionHan: @escaping ([Streak]) -> Void) {
        var result = [Streak]()
        let query = "SELECT * FROM Streaks"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                
                // Handle createdTime
                var createdTime: Date?
                if sqlite3_column_type(queryStatement, 1) != SQLITE_NULL {
                    createdTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStatement, 1))
                }
                
                let reason = String(cString: sqlite3_column_text(queryStatement, 2))
                let category = String(cString: sqlite3_column_text(queryStatement, 3))
                
                let streak = Streak(id: Int(id), timeDate: createdTime!, reason: reason, category: category)
                result.append(streak)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        completionHan(result)
    }

    
    func getStreakCount() -> Int {
        return userDefaults.integer(forKey: "streaksCount")
    }
    

    func fetchStreak() -> [Streak] {
        var result = [Streak]()
        let query = "SELECT * FROM Streaks"
        var queryStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                
                // Handle createdTime
                var createdTime: Date?
                if sqlite3_column_type(queryStatement, 1) != SQLITE_NULL {
                    createdTime = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStatement, 1))
                }
                
                let reason = String(cString: sqlite3_column_text(queryStatement, 2))
                let category = String(cString: sqlite3_column_text(queryStatement, 3))
                
                let streak = Streak(id: Int(id), timeDate: createdTime!, reason: reason, category: category)
                result.append(streak)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return result
    }

    @discardableResult
    public func recentStreak() -> Streak {
        let streaks = fetchStreak()
       
        if streaks.isEmpty {
            let streak = Streak(id: 0, timeDate: Date.getCurrentDate(), reason: "initial", category: "initial")
            insertStreak(streak: streak)
            return streak
        } else {
            return streaks.last!
        }
    }
}


