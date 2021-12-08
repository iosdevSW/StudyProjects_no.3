//
//  DepartmentDAO.swift
//  Chapter06-HR
//
//  Created by 신상우 on 2021/12/08.
//

import UIKit

class DepartmentDAO {
    // Data Access Object : 데이터 베이스에 SQL문을 전송하여 질의하거나 업데이트 하는 로직만 분리하여 독립적인 클래스로 구현한 것
    // 비즈니스 로직 계층과 데이터베이스 처리 계층을 구분하여 명확한 역할분담 뿐 아니라 전체 코들르 단순화 하는 장점이 있다.
    
    typealias DepartRecord = (Int, String, String) // 부서 데이터를 담을 튜플 형식 타입 얼리어스
    
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
        
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
        
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbsource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbsource!, toPath: dbPath)
        }
        
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
    
    func find() -> [DepartRecord] {
        var departList = [DepartRecord]() // 반환될 데이터를 담을 객체
        
        do {
            let sql = """
                SELECT depart_cd, depart_title, depart_addr
                FROM department
                ORDER BY depart_cd ASC
                """
            
            let rs = try self.fmdb.executeQuery(sql, values: nil)
            
            while rs.next() {
                let departCd = rs.int(forColumn: "depart_cd")
                let departTitle = rs.string(forColumn: "depart_title")
                let departAddr = rs.string(forColumn: "depart_addr")
                
                departList.append( ( Int(departCd), departTitle!, departAddr! ) )
            }
        } catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
        return departList
    }
    
    func get(departCd: Int) -> DepartRecord? {
        //sql구문만 먼저 컴파일 해두고
        let sql = """
            SELECT depart_cd, depart_title, depart_addr
            FROM department
            WHERE depart_cd = ?
            """
        
        // 데이터 값을 인자로 받아 실행! -> 인자값만 다르고 반복되는 구문이 많은 SQL특성상 효율이 좋다. but 한 번만 쓴다면 그냥 쓰는게 좋다.
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [departCd]) // prepareStatement
        
        
        if let _rs = rs {
            _rs.next() // FMRESULTSET에서 레코드를 읽어오는? 가져오는 함수로써 가져올게 있으면 true 없으면 false 반환
            
            let departId = _rs.int(forColumn: "depart_cd")
            let departTitle = _rs.string(forColumn: "depart_title")
            let departAddr = _rs.string(forColumn: "depart_addr")
            
            return ( Int(departId), departTitle!, departAddr! )
        } else {
            return nil
        }
    }
    
    func create(title: String!, addr: String!) ->Bool {
        guard title != nil && title?.isEmpty == false else { return false }
        guard addr != nil && title?.isEmpty == false else { return false}
        
        do {
            let sql = """
                INSERT INTO department ( depart_title, depart_addr)
                VALUES ( ?, ? )
                """
            try self.fmdb.executeUpdate(sql, values: [title!, addr!])
            
            return true
        } catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func remove(departCd: Int ) ->Bool {
        do {
            let sql = "DELETE FROM department WHERE depart_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [departCd])
            
            return true
        }catch let error as NSError {
            print("DELETE Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
}
