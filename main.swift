import Kitura
import Cocoa
import Foundation
let router = Router()


router.all("/ClaimService/add", middleware: BodyParser())

router.get("/ClaimService/getAll"){
    request, response, next in
    let pList = Claim().getAll()
    let jsonData : Data = try JSONEncoder().encode(pList)
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    next()
}

router.post("ClaimService/add"){
    request, response, next in
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String] {
        if let _title = jDict["title"], let _date = jDict["date"]{
            let _id = UUID().uuidString
            let _isSolved = 0
            let pObj = Claimate(_id:_id, _title:_title, _date:_date, _isSolved:_isSolved)
            response.send("id: \(_id), title: \(_title), date: \(_date), isSolved: \(_isSolved)")
            Claim().addClaim(pObj: pObj)
            response.send(Claim().rsqlStmt(pObj: pObj))
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}

Kitura.addHTTPServer(onPort: 8040, with: router)
Kitura.run()
