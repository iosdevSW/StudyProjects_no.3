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
    var defaultPList : NSDictionary! // 메인 번들에 정의된 PList 내용을 저장할 딕셔너리 (템플릿)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //메인 번들에 UserInfo.plist가 포함되어 있으면 이를 읽어와 딕셔너리에 담는다.
        //확장자와 파일명 분리하여쓴다. 첫번째가 파일명 두번쨰 인자가 확장자명
        //번들 : 쉽게 말하면 앱이 설치된 디렉터리
        if let defaultPListPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPList = NSDictionary(contentsOfFile: defaultPListPath)
        }
        
        //계정이 없으면 입력 비활성화
        if (self.account.text?.isEmpty)! {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
        
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
            let customPlist = "\(account).plist" // 읽어올 파일명
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
        //네비게이션바에 newaccount버튼 추가
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn]
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true) // 입력 뷰 닫음
        
        //선택된 계정에 대한 커스텀 프로퍼티 파일을 읽어와 셋팅한다.
        if let _account = self.account.text{
            let customPlist = "\(_account).plist" //읽어올 파일명
            
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPlist]).first!
            let data = NSDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
        
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
                
                //입력 항목 활성화 처리
                self.gender.isEnabled = true
                self.married.isEnabled = true
            }
        })
        
        self.present(alert, animated: false)
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        
//        let plist = UserDefaults.standard
//        plist.set(value, forKey: "gender")
//
//        plist.synchronize()// 동기화 처리
        
        let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        
//        let plist = UserDefaults.standard
//        plist.set(value,forKey: "married")
//        plist.synchronize() // 동기화 처리
        let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPlist]).first!
        
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        print("custom plist = \(plist)")
        
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
        if indexPath.row == 1 && (self.account.text?.isEmpty)! == false{
            let alert = UIAlertController(title: nil, message: "이름을 입략하세요.", preferredStyle: .alert)
            
            alert.addTextField() {
                $0.text = self.name.text
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default){(_) in
                let value = alert.textFields?[0].text
                
//                let plist = UserDefaults.standard
//                plist.setValue(value, forKey: "name")
//                plist.synchronize() //동기화 처리
                
                let customPlist = "\(self.account.text!).plist" // 읽어올 파일명
                //해당 어플리케이션과 연관된 디렉터리 정보를 찾아 반환하는 객체
                //첫 번째 인자로 지정된 대상을 두 번째 인자 값의 범위에서 찾음 세번쨰 인덱스는 true시 전체 경로 반환
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                
                let path = paths[0] as NSString //반환된 여러가지값 반환값 중 첫번째
                //NSString메소드로 기존 경로문자열 뒤에 입력받은 문자열을 붙여 하위경로 문자열을 만든다.
                // 기존 경로 뒤에 /가 있는지 없는지 판단 후 알맞은 경로 파일을 만듬
                // 만약 그냥 기존경로+ / + 하위경로 로 작성하려면 따로 기존 경로의 / 여부를 판단해줘야함.
                let plist = path.strings(byAppendingPaths: [customPlist]).first!
                
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true) //원자성 true : 임시 파일을 만들어 거기 저장해두고 나중에 파일 덮어씀
                self.name.text = value
            })
            self.present(alert, animated: false)
        }
    }
}
