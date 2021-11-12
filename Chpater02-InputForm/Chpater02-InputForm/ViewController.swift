//
//  ViewController.swift
//  Chpater02-InputForm
//
//  Created by 신상우 on 2021/11/11.
//

import UIKit

class ViewController: UIViewController {
    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1. 네비게이션 바 타이틀을 입력한다.
        self.navigationItem.title = "설정"
        
        // 2. 이메일 레이블을 생성하고 영역과 기본 문구를 설정한다.
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 30, y: 100, width: 100, height: 30)
        lblEmail.text = "이메일"
        
        // 3. 레이블의 폰트를 설정한다.
        lblEmail.font = .systemFont(ofSize: 14)
        
        // 4. 레이블을 루트 뷰에 추가한다
        self.view.addSubview(lblEmail)
        
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: 30, y: 150, width: 100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = .systemFont(ofSize: 14)
        
        self.view.addSubview(lblUpdate)
        
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: 30, y: 200, width: 100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = .systemFont(ofSize: 14)
        
        self.view.addSubview(lblInterval)
        
        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y: 100, width: 220, height: 30)
        self.paramEmail.font = .systemFont(ofSize: 13)
        self.paramEmail.borderStyle = .roundedRect
        
        self.view.addSubview(self.paramEmail)
        
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y: 150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true) // set default Switch On
        
        self.view.addSubview(self.paramUpdate)
        
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y: 200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0 // 스태퍼가 가질 수 있는 최소값
        self.paramInterval.maximumValue = 100 // 스태퍼가 가질 수 있는 최대값
        self.paramInterval.stepValue = 1 // 스태퍼 값 변경 단위
        self.paramInterval.value = 0 // 초기값
        
        self.view.addSubview(self.paramInterval)
        
        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y: 150, width: 100, height: 30)
        self.txtUpdate.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate.textColor = .red
        self.txtUpdate.text = "갱신함"
        
        self.view.addSubview(self.txtUpdate)
        
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y: 200, width: 100, height: 30)
        self.txtInterval.font = UIFont.systemFont(ofSize: 12)
        self.txtInterval.textColor = .red
        self.txtInterval.text = "0분마다"
        
        self.view.addSubview(self.txtInterval)
        
        //전송 버튼을 네비게이션 아이템에 추가
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.submit(_:)))
        self.navigationItem.rightBarButtonItem = submitBtn
        
        // addTarget
        self.paramInterval.addTarget(self, action: #selector(self.presentIntervalValue(_:)), for: .valueChanged)
        self.paramUpdate.addTarget(self, action: #selector(self.presentUpdateVlaue(_:)), for: .valueChanged)
    }
    
    //MARK: Selector
    @objc func presentUpdateVlaue(_ sender: UISwitch){
        self.txtUpdate.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
    }
    
    @objc func presentIntervalValue(_ sender: UIStepper){
        self.txtInterval.text = ("\(Int(sender.value))분 마다")
    }
    
    @objc func submit(_ sender: Any){
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = self.paramInterval.value
        
        self.navigationController?.pushViewController(rvc, animated: true)
    }


}

