//
//  ViewController.swift
//  Chapter06-SQLite3
//
//  Created by 신상우 on 2021/12/06.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var db: OpaquePointer? = nil // SQLite 연결 정보를 담을 객체
        var stmt: OpaquePointer? = nil // 컴파일된 SQL을 담을 객체
        
        //앱 내 문서 디렉터리 경로에서 SQLite DB파일을 찾는다
        let fileMgr = FileManager() // 파일 매니저 객체 생성
        let docPathURL = fileMgr.urls(for: .documentDirectory, in: .userDomainMask).first! //앱 내 문서 디렉터리 경로생성
        //db.sqlite파일 경로를 추가한 db경로 저장(반환값이 URL타입 이기 때문에 .path 이용하여 string으로 저장)
        let dbPath = docPathURL.appendingPathComponent("db.sqlite").path
        
        //dbPath 경로에 파일이 없다면 앱 번들에 만들어 둔 db.sqlite을 가져와 복사한다.
        if fileMgr.fileExists(atPath: dbPath) == false {
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        
        let sql = "CREATE TABLE IF NOT EXISTS sequence (num INTEGER)" // sequence라는 이름의 테이블을 정의하라.(SQL구문 DDL)
        //sequence라는 테이블이 없을 때 INTEGER타입의 num 커럼 1개 가 있는 테이블 생성
        
        //db와 앱을 연결 (이 과정에서 db객체 생성)
        //첫 번째 인자는 SQLite파일의 경로
        //두 번째 인자는 생성된 db객체를 담을 변수 - &(레퍼런스 전달방식)을 사용하여 구조체 타입인 OpaquePointer타입의 주소를 전달.
        if sqlite3_open(dbPath, &db) == SQLITE_OK { // db가 잘 연결되었다면
            
            //SQL구문 준비 : sql문장을 컴파일하여 stmt에 저장
            //첫 번째 인자값 : 연결된 데이터베이스 참조
            //두 번째 인자값 : 컴파일할 SQL문장
            //네 번째 인자값 : 컴파일된 SQL객체 저장
            if sqlite3_prepare(db, sql, -1, &stmt, nil) == SQLITE_OK { // SQL컴파일이 잘 끝났다면
                //sql 객체를 데이터베이스db 에 전달
                if sqlite3_step(stmt) == SQLITE_DONE {
                    print("Create Talbe Success!")
                }
                
                //sql의 실행이 끝나면 더 이상 사용하지 않는 자원을 해제해주어야한다. 꼭 stmt -> db 객체 순으로 해제해야한다. 아니면 오류
                sqlite3_finalize(stmt)
            }else {
                print("Prepare Statement Fail")
            }
            //db연결 해제
            sqlite3_close(db) // 컴파일이 성공하든 실패하든 위에서 연결된 db를 무조건 끊어줘야 하기때문에 이 위치가 적절하다.
            
        }else {
            print("Database Connect Fail")
            return
        }
        
        //총 정리!
        // 1.sql경로 , 2.sql구문 작성 3.db객체 생성, 4.sql구문 컴파일하여 sql구문 객체생성, 5.컴파일된 sql구문 db에 전달 6.값 해제
        
    }


}

