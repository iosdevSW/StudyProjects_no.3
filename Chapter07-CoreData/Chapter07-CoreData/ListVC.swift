//
//  ListVC.swift
//  Chapter07-CoreData
//
//  Created by 신상우 on 2021/12/09.
//

import UIKit
import CoreData

class ListVC: UITableViewController {
    // 데이터 소스 역할을 할 배열 변수
    lazy var list: [NSManagedObject] = {
        return self.fetch()
    }()
    
    override func viewDidLoad() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.add(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
    // 데이터를 저장할 메소드
    func save(title: String, contents: String) -> Bool {
        //1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        
        //3. 관리 객체 생성 & 값을 설정
        let object = NSEntityDescription.insertNewObject(forEntityName: "Board", into: context)
        
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        //3-1. Log관리 객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.create.rawValue
        
        //3-2. 게시글 객체의 logs 속성에 새로 생성된 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)
        
        //4. 영구 저장소에 커밋되고 나면 list 프로퍼티에 추가한다.
        do{
            try context.save()
//            self.list.append(object)
            self.list.insert(object, at: 0) //새 게시글 등록 시 배열의 0번 인덱스에 삽입되도록( 최신글이 상위에 )
            return true
        } catch {
            context.rollback() //영구 저장소에 커밋이 실패하면 컨텍스트도 롤백 시켜서 영구 저장소와 컨텍스트의 객체를 일치시킨다.
            return false
        }
    }
    
    // 데이터 저장 버튼에 대한 액션 메소드
    @objc func add(_ sender: Any) {
        let alert = UIAlertController(title: "게시글 등록", message: nil, preferredStyle: .alert)
        
        alert.addTextField(){ $0.placeholder = "제목"}
        alert.addTextField(){ $0.placeholder = "내용"}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default){ (_) in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text else { return }
            if self.save(title: title, contents: contents) == true { // 데이터 저장하고 성공하면 테이블 뷰 리로드
                self.tableView.reloadData()
            }
        })
        self.present(alert, animated: false)
        
    }
    
    func delete(object: NSManagedObject) -> Bool {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        
        // 3. 컨텍스트로부터 해당 객체 삭제
        context.delete(object)
        
        // 4. 영구 저장소에 커밋
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    func edit(object: NSManagedObject, title: String, contents: String) -> Bool {
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        
        // 3. 관리 객체 값을 수정
        object.setValue(title, forKey: "title")
        object.setValue(contents, forKey: "contents")
        object.setValue(Date(), forKey: "regdate")
        
        // 3-1. Log관리 객체 생성 및 어트리뷰트에 값 대입
        let logObject = NSEntityDescription.insertNewObject(forEntityName: "Log", into: context) as! LogMO
        logObject.regdate = Date()
        logObject.type = LogType.edit.rawValue
        
        // 3-2. 게시글 객체의 logs 속성에 새로 생성딘 로그 객체 추가
        (object as! BoardMO).addToLogs(logObject)
        do {
            try context.save()
            self.list = self.fetch() //list 배열을 갱신 (정렬 위해서)
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    // 데이터를 읽어올 메소드
    func fetch() -> [NSManagedObject] { // fetch : 데이터 가져오기
        // 1. 앱 델리게이트 객체 참조
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // 2. 관리 객체 컨텍스트 참조
        let context = appDelegate.persistentContainer.viewContext
        
        // 3. 요청 객체 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Board") //Board라는 엔터티를 가진 레코드를 가져오는 객체!
        
        // 3-1. 정렬 속성 설정
        //key : 어떤 어트리뷰트를 기준으로 정렬할 것인가
        //ascending : 어떤 순서로 정렬할 것인가. 오름차순이면 true 내림차순은 false
        let sort = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        // 4. 데이터 가져오기
        let result = try! context.fetch(fetchRequest) // 컨텍스트를 통해 코어데이터에서 데이터를 읽어오는 객체
        
        return result
    }
    // 레코드를 저장하거나 수정된 내용을 반영할 때에는 save()메소드를 사용 객체 IDfmf dksekaus object메소드 사용
    // 데이터를 읽어올 때에는 fetch 메소드 사용
    
    //MARK:- delegate Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = self.list[indexPath.row]
        let title = record.value(forKey: "title") as? String
        let contents = record.value(forKey: "contents") as? String
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = contents
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row] //삭제할 대상 객체
        
        if self.delete(object: object) {
            //코어 데이터에서 삭제 되고 나면 배열 목록과 테이블 뷰 행도 삭제한다.
            self.list.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    // 셀 클릭하면 편집창이 열림
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let title = object.value(forKey: "title") as? String
        let contents = object.value(forKey: "contents") as? String
        
        let alert = UIAlertController(title: "게시글 수정", message: nil, preferredStyle: .alert)
        
        alert.addTextField(){ $0.text = title }
        alert.addTextField(){ $0.text = contents }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) {(_) in
            guard let title = alert.textFields?.first?.text, let contents = alert.textFields?.last?.text
            else { return } //비었으면 그냥 종료

            if self.edit(object: object, title: title, contents: contents) == true {
//                self.tableView.reloadData()
                let cell = self.tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = title
                cell?.detailTextLabel?.text = contents
                
                let firstIndexPath = IndexPath(item: 0, section: 0)
                self.tableView.moveRow(at: indexPath, to: firstIndexPath)
                
            }
        })
        self.present(alert, animated: false)
    }
    
    // 악세사리버튼 클릭시
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let object = self.list[indexPath.row]
        let uvc = self.storyboard?.instantiateViewController(withIdentifier: "LogVC") as! LogVC
        
        uvc.board = (object as! BoardMO)
        
        self.show(uvc, sender: self)
        
    }
}
