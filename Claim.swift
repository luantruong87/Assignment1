//
//  Claim.swift
//  RestServer
//
//  Created by luan nguyen on 10/21/20.
//
import SQLite3

struct Claimate : Codable {
    var id : String?
    var title : String?
    var date : String?
    var isSolved : Int?
    init(_id : String?, _title: String?, _date: String?, _isSolved: Int?){
        id = _id
        title = _title
        date = _date
        isSolved = _isSolved
    }
}

class Claim{
    func addClaim(pObj : Claimate){
        let sqlStmt = String(format:"insert into Claim (id, title, date, isSolved) values ('%@', '%@', '%@', '%02d')", (pObj.id)!, (pObj.title)!, (pObj.date)!, (pObj.isSolved)!)
        // get database connection
        
        let conn = Database.getInstance().getDbConnection()
        // submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK{
            let errcode = sqlite3_errcode(conn)
            print("Falied to insert a Claim record due to error \(errcode)")
        }
        // close the connection
        sqlite3_close(conn)
    }
    func rsqlStmt(pObj : Claimate) -> String{
        let sqlStmt2 = String(format:"insert into Claim (id, title, date, isSolved) values ('%@', '%@', '%@', '%02d')", (pObj.id)!, (pObj.title)!, (pObj.date)!, (pObj.isSolved)!)
        return sqlStmt2;
        
    }
    
    func getAll() -> [Claimate]{
        var pList = [Claimate]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from Claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW){
                let id_val = sqlite3_column_text(resultSet, 0)
                let _id = String(cString: id_val!)
                let title_val = sqlite3_column_text(resultSet, 1)
                let _title = String(cString: title_val!)
                let date_val = sqlite3_column_text(resultSet, 2)
                let _date = String(cString: date_val!)
                let isSolved_val = sqlite3_column_text(resultSet, 3)
                let _isSolvedStr = String(cString: isSolved_val!)
                let _isSolved = Int(_isSolvedStr)
                pList.append(Claimate(_id:_id, _title:_title, _date:_date, _isSolved:_isSolved))
            }
        }
        sqlite3_close(conn)
        return pList
    }
     
}
