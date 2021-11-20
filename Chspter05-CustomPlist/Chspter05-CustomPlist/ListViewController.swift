//
//  ListViewController.swift
//  Chspter05-CustomPlist
//
//  Created by 신상우 on 2021/11/20.
//

import UIKit

class ListViewController: UITableViewController,  UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var married: UISwitch!
    
    var accountlist = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plist = UserDefaults.standard
        
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married)")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        self.account.inputView = picker // 텍스트 필드의 입력 방식을 가상 키보드 대신 피커 뷰로 설정
        
        //toolbar 객체 정의
        let toolbar = UIToolbar()
        // 액세서리 영역의 툴바는 높이값 뺴곤 자동으로 렌더링됨! 유일하게 제어할 수 있는값이 높이
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = .lightGray
        
        self.account.inputAccessoryView = toolbar
        
        //툴 바에 들어갈 닫기 버튼
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(self.pickerDone(_:))
        
        toolbar.setItems([done], animated: true)
        
        //가변 폭 버튼 정의
        //툴바 버튼 배치 원칙 : 입력된 순서에 따라 왼쪽부터 차례로 배치 그래서 flexiblespace button item이 쓰임. fixed는 고정 크기 버튼
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        //신규 계정 등록 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(self.newAccount(_:))
        
        toolbar.setItems([new,flexSpace,done], animated: true)
        
        let accountlist = plist.array(forKey: "accountlist") as? [String] ?? [String]()
        self.accountlist = accountlist
        
        if let account = plist.string(forKey: "selectedAccount") {
            self.account.text = account
        }
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true) // 입력 뷰 닫음
    }
    
    @objc func newAccount(_ sender: Any){
        self.view.endEditing(true) //입력 뷰 닫기
        
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        
        alert.addTextField(){
            $0.placeholder = "ex) abc@gmail.com"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
            if let account = alert.textFields?[0].text {
                self.accountlist.append(account)
                self.account.text = account
                
                //컨트롤 값 모두 초기화
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                let plist = UserDefaults.standard
                
                plist.set(self.accountlist, forKey: "accountlist")// 마스터 데이터 역할(계정 목록)
                plist.set(account, forKey: "selectedAccount")
                plist.synchronize() //동기화 처리
            }
        })
        
        self.present(alert, animated: false)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")

        plist.synchronize()// 동기화 처리
        
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
        let plist = UserDefaults.standard
        plist.set(value,forKey: "married")
        plist.synchronize() // 동기화 처리
    }
    
    //MARK: PickerView delegateMethod
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountlist.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountlist[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountlist[row]
        self.account.text = account
        
        let plist = UserDefaults.standard
        plist.set(account, forKey: "selectedAccount")
        plist.synchronize()
    }
    
    //MARK: TableViewDelegateMethod
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let alert = UIAlertController(title: nil, message: "이름을 입략하세요.", preferredStyle: .alert)
            
            alert.addTextField() {
                $0.text = self.name.text
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
                let value = alert.textFields?[0].text
                let plist = UserDefaults.standard
                plist.setValue(value, forKey: "name")
                plist.synchronize() //동기화 처리
                
                self.name.text = value
            })
            self.present(alert, animated: false)
        }
    }
}
