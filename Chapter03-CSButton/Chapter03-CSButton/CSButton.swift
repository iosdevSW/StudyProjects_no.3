//
//  CSButton.swift
//  Chapter03-CSButton
//
//  Created by 신상우 on 2021/11/14.
//

import UIKit

public enum CSButtonType {
    case rect
    case circle
}

class CSButton: UIButton{
    var style: CSButtonType = .rect {
        didSet{
            switch style {
                case .rect:
                    self.backgroundColor = .black
                    self.layer.borderColor = UIColor.black.cgColor
                    self.layer.borderWidth = 2
                    self.layer.cornerRadius = 0
                    self.setTitleColor(.white, for: .normal)
                    self.setTitle("Rect Button", for: .normal)
                case .circle:
                    self.backgroundColor = .red
                    self.layer.borderColor = UIColor.blue.cgColor
                    self.layer.borderWidth = 2
                    self.layer.cornerRadius = 30
                    self.setTitle("Circle Button",for: .normal)
            }
        }
    }
    
    
    //스토리보드 방식으로 객체를 생성할 때 호출되는 초기화 메소드 (생성자)
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.backgroundColor = .green
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("버튼", for: .normal)
    }
    
    //프로그래밍 방식으로 객체를 생성할 때 호출되는 초기화 메소드 (생성자)
    override init(frame: CGRect) {
      //인자값이 중요~!
        super.init(frame: frame)
        self.backgroundColor = . gray
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.setTitle("코드로 생성된 버튼", for: .normal)
    }
    //매개변수가 없는 생성자
    init() {
        super.init(frame: CGRect.zero) // frame의 명시적 초기화를 위해 꼭 매개변수가 있어야함 / super.init() (x)
        //이 메소드 덕에 인자값 없이 커스텀버튼객체 생성가능.
        //주로 정확한 값이 없을때 이 생성자 이용
        //나중에 꼭 frame값 따로 설정해 주어야함. 안그럼 안뜸!
    }
    //버튼 스타일 지정 생성자
    convenience init(type: CSButtonType){
        self.init() //편의 생성자는 수평적 호출!
        
        switch type {
            case .rect:
                self.backgroundColor = .black
                self.layer.borderColor = UIColor.black.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 0
                self.setTitleColor(.white, for: .normal)
                self.setTitle("Rect Button", for: .normal)
            case .circle:
                self.backgroundColor = .red
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 2
                self.layer.cornerRadius = 30
                self.setTitle("Circle Button",for: .normal)
        }
        
        self.addTarget(self, action: #selector(self.counting(_:)), for: .touchUpInside)
    }
    
    @objc func counting(_ sender: UIButton){
        sender.tag = sender.tag + 1
        sender.setTitle("\(sender.tag) 번째 클릭", for: .normal)
    }
}
