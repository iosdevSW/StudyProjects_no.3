//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by 신상우 on 2021/11/11.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.center = CGPoint(x: self.view.frame.size.width / 2, y: 100)
        btn.setTitle("테스트 버튼", for: .normal)
        btn.addTarget(self, action: #selector(self.btnOnClick(_:)), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    @objc func btnOnClick(_ sender: Any) {
        let btn = sender as! UIButton
        btn.setTitle("클릭되었습니다.", for: .normal)
    }


}

