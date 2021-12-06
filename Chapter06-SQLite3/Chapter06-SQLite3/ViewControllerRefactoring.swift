//
//  ViewControllerRefactoring.swift
//  Chapter06-SQLite3
//
//  Created by 신상우 on 2021/12/06.
//

import UIKit

class ViewControllerRefactoring: UIViewController {
    // 현재 뷰컨트롤러 상에서 리팩토링 대상요소
    // 1. 독립적인 기능 단위로 분리할수 있는 코드는 별도의 함수로 분리
    // 2. 하수에 여러 가지 작업이 혼재되어 성격이 불분명할 경우 목적에 따라 작은 함수로 분리한다.
    // 3. 코드의 깊이를 줄이기 위해 if 조건절 중 가능한 부분을 guard구문으로 변경한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dbPath = self.getDBPath()
        self.dbExecute(dbPath: dbPath)
    }
    
    func getDBPath() -> String {
        let fileMgr = FileManager()
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        return dbPath
    }
    
    func dbExecute(dbPath: String) {
        var db: OpaquePointer? = nil
        
        guard sqlite3_open(dbPath, &db) == SQLITE_OK else {
            print("Database Connect Fail")
            return
        }
        
        defer {
            print("Close Database Connection")
            sqlite3_close(db)
        }
        
        var stmt: OpaquePointer? = nil
        let sql = "CRATE TABLE IF NOT EXISTS sequence (num INTEGER)"
        
        guard sqlite3_prepare(db, sql,-1,&stmt, nil) == SQLITE_OK else {
            print("Prepare Statement Fail")
            return
        }
        
        // 지연블록 defer : 함수의 종료 직전에 항상 실행된다. 꼭 기억해야해!
        // 특성 1. defer 블록을 읽기 전에 실행이 종료될 경우 실행 x
        // 특성 2. defer 블록은 중복된다 순서는 마지막 defer부터 역순으로 실행된다.
        // 특성3. defer 블록은 중첩이 된다. 가장 바깥족 defer블록부터 실행되며 가장 안쪽 블록이 나중에 실행된다.
        defer {
            print("finalize Statement")
            sqlite3_finalize(stmt)
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE {
            print("Create Table Success!")
        }

        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            if sqlite3_prepare(db, sql,-1,&stmt, nil) == SQLITE_OK {
                sqlite3_finalize(stmt)
            }else{
                print("Prepare Statement Fail")
            }
            sqlite3_close(db)
        } else{
            print("Database Connect Fail")
            
            return
        }
    }
}
