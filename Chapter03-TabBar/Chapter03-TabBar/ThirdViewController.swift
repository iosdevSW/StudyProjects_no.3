//
//  ThirdViewController.swift
//  Chapter03-TabBar
//
//  Created by 신상우 on 2021/11/12.
//

import UIKit

class ThirdViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "세 번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 14)
        title.sizeToFit() // 콘텐츠 내용에 맞게 레이블 크기 변경
        title.center.x = self.view.frame.width / 2 // 레이블을 화면 x축 중앙애 오게 설정
        self.view.addSubview(title)
    }

}
