//
//  Database.swift
//  RestServer
//
//  Created by luan nguyen on 10/21/20.
//
import SQLite3


class Database{
    static var dbObj : Database!
    let dbname = "/Users/luannguyen/Documents/ClaimDb.sqlite"
    var conn : OpaquePointer?
    
    init(){
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error \(errcode)")
        }
    }
    
    private func initializeDB(){
        let sqlStmt = "create table if not exists Claim (id text unique, title text, date text, isSolved boolean not null)"
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK{
            let errcode = sqlite3_errcode(conn)
            print("Create table falied due to error \(errcode)")
        }
    }
    
    func getDbConnection() -> OpaquePointer?{
        var conn : OpaquePointer?
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            return conn
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Create table falied due to error \(errcode)")
        }
        return conn
    }
    
    static func getInstance() -> Database {
        if dbObj == nil {
            dbObj = Database()
        }
        return dbObj
    }
}
