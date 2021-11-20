//
//  ListViewController.swift
//  Chapter05-UserDefaults
//
//  Created by 신상우 on 2021/11/19.
//

import UIKit

class ListViewController: UITableViewController {
    @IBOutlet var name: UILabel!
    @IBOutlet var married: UISwitch!
    @IBOutlet var gender: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plist = UserDefaults.standard
        
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section) // 부모 메소드 사용
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView) // 부모 메소드 사용
    }
    // 테이블뷰컨트롤러 델리게이트 메소드를 이용해 편집 하는 방법 1
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let alert = UIAlertController(title: nil, message: "이름을 입력하세오.", preferredStyle: .alert)
//            alert.addTextField(){ // 텍스트 필드 추가 (첫 번째 택스트필드 $0, 두 번째 tf $1 ...
//                $0.text = self.name.text
//            }
//            alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
//                //사용자가 OK 버튼을 누르면 텍스트 필드에 입력된 값을 저장
//                let value = alert.textFields?[0].text
//
//                let plist = UserDefaults.standard
//                plist.setValue(value, forKey: "name")
//                plist.synchronize() // 동기화처리
//
//                self.name.text = value
//            })
//
//            self.present(alert, animated: false)
//        }
//    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex // 0이면 남자, 1이면 여자
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize() //동기화 처리
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn // true 면 기혼, false면 미혼
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize() //동기화 처리
    }
    
    //탭 제스쳐를 레이블에 등록하여 편집 하는 방법 2
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        // 뷰 객체도 상호반응하려면 스토리보드에서 User Interraction Enabled 옵션 체크 처리해야 한다.
        let alert = UIAlertController(title: nil, message: "이름을 입력하세오.", preferredStyle: .alert)
        alert.addTextField(){ // 텍스트 필드 추가 (첫 번째 택스트필드 $0, 두 번째 tf $1 ...
            $0.text = self.name.text
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
            //사용자가 OK 버튼을 누르면 텍스트 필드에 입력된 값을 저장
            let value = alert.textFields?[0].text
            
            let plist = UserDefaults.standard
            plist.setValue(value, forKey: "name")
            plist.synchronize() // 동기화처리
            
            self.name.text = value
        })
        
        self.present(alert, animated: false)
    }
}
