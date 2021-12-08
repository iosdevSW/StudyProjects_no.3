//
//  EmployeeDAO.swift
//  Chapter06-HR
//
//  Created by 신상우 on 2021/12/08.
//

import UIKit

enum EmpStateType: Int {
    case ING = 0, STOP, OUT // 0: 재직중, 1 : 휴직중, 2 : 퇴사
    
    func desc() -> String {
        switch self{
        case .ING:
            return "재직중"
        case .STOP:
            return "휴직"
        case .OUT:
            return "퇴사"
        }
    }
}
    struct EmployeeVO {
        var empCd = 0
        var empName = ""
        var joinDate = ""
        var stateCd = EmpStateType.ING
        var departCd = 0
        var departTitle = ""
    }
    
class EmployeeDAO {
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
        
        let docPath = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first
        let dbPath = docPath!.appendingPathComponent("hr.sqlite").path
            
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "hr", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
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
        //전체 사원 목록 불러오기
    func find(departCd: Int = 0) -> [EmployeeVO] {
        var employeeList = [EmployeeVO]()
        do{
            //인자값이 0이면 부서 전체 목록을 가져오고 0이 아니면 해당 부서 코드의 사원 목록을 불러온다.
            let condition = departCd == 0 ? "" : "WHERE Employee.depart_cd = \(departCd)"
            
            let sql = """
                SELECT emp_cd, emp_name, join_date, state_cd, department.depart_title
                FROM employee
                JOIN department On department.depart_cd = employee.depart_cd
                \(condition)
                ORDER BY employee.depart_cd ASC
                """
                
            let rs = try self.fmdb.executeQuery(sql, values: nil)
                
            while rs.next() {
                var record = EmployeeVO()
                
                record.empCd = Int(rs.int(forColumn: "emp_cd") )
                record.empName = rs.string(forColumn: "emp_name")!
                record.joinDate = rs.string(forColumn: "join_date")!
                record.departTitle = rs.string(forColumn: "depart_title")!
                    
                let cd = Int(rs.int(forColumn: "state_cd"))
                record.stateCd = EmpStateType(rawValue: cd)!
                
                employeeList.append(record)
            }
        }catch let error as NSError {
            print("failed: \(error.localizedDescription)")
        }
      
        return employeeList
    }
    // 단일 사원 불러오기
    func get(empCd: Int) -> EmployeeVO? {
        let sql = """
            SELECT emp_cd, emp_name, join_date, state_cd,
            department.depart_title
            FROM employee
            JOIN department On department.depart_cd = employee.depart_cd
            WHERE emp_cd = ?
            """
        
        let rs = self.fmdb.executeQuery(sql, withArgumentsIn: [empCd])
        
        if let _rs = rs {
            _rs.next()
            
            var record = EmployeeVO()
            record.empCd = Int(_rs.int(forColumn: "emp_cd") )
            record.empName = _rs.string(forColumn: "emp_name")!
            record.joinDate = _rs.string(forColumn: "join_date")!
            record.departTitle = _rs.string(forColumn: "depart_title")!
                
            let cd = Int(_rs.int(forColumn: "state_cd"))
            record.stateCd = EmpStateType(rawValue: cd)!
        
            return record
        }else {
            return nil
        }
    }
    
    //신입사원 추가
    func create(param: EmployeeVO) -> Bool {
        do {
            let sql = """
                INSERT INTO employee (emp_name, join_date, state_cd, depart_cd)
                VALUES (?, ?, ?, ?)
                """
            
            var params = [Any]()
            params.append(param.empName)
            params.append(param.joinDate)
            params.append(param.stateCd.rawValue)
            params.append(param.departCd)
            
            try self.fmdb.executeUpdate(sql, values: params)
            
            return true
        }catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
    //사원 정보 삭제
    func remove(empCd: Int) -> Bool {
        do {
            let sql = " DELETE FROM employee WHERE emp_cd = ? "
            try self.fmdb.executeUpdate(sql, values: [empCd])
            
            return true
        }catch let error as NSError {
            print("Insert Error: \(error.localizedDescription)")
            
            return false
        }
    }
    
    func editState(empCd: Int, stateCd: EmpStateType) -> Bool {
        do {
            let sql = " UPDATE Employee SET state_cd = ? WHERE emp_cd = ? "
            
            var params = [Any]()
            
            params.append(stateCd.rawValue) // 재직상태코드
            params.append(empCd) // 사원 코드
            try self.fmdb.executeUpdate(sql, values: params)
            
            return true
        } catch let error as NSError {
            print("UPDATE Error: \(error.localizedDescription)")
            
            return false
        }
    }
}
