//
//  CSStepper.swift
//  Chapter03-CSStepper
//
//  Created by 신상우 on 2021/11/16.
//

import UIKit
//접근지정자
//private : 같은 클래스 내에서만 접근이 가능
//fileprivate : 같은 파일 내에서 접근이 가능
//interanl : 같은 모듈 또는 프로젝트 내에서 접근 가능
//public : 모듈 외부에서 접근이 가능 but 상속,메소드 오버라이드는 허용 x 가져다 사용만 가능
//open : public 범위를 가지며, 상속,메소드오버라이드까지 모두 허용

@IBDesignable // 이 클래스를 스토리보드에서 미리보기 형태로 처리해달라고 시스템에 요청하는 어트리뷰트
class CSStepper: UIControl{
    @IBInspectable public var stepValue: Int = 1
    @IBInspectable public var maximumValue: Int = 100
    @IBInspectable public var minimumValue: Int = -100
    
    public var leftBtn = UIButton(type: .system)
    public var rightBtn = UIButton(type: .system)
    public var centerLabel = UILabel()
   
    @IBInspectable // 우리가 정의한 속성을 인터페이스 빌더에서도 설정할 수 있도록 처리해주는 어트리뷰트(타입 어노테이션 필수)
    public var value: Int = 0 { //스태퍼의 현재 값을 저장할 변수
        didSet{
            self.centerLabel.text = String(self.value)
            
            self.sendActions(for: .valueChanged) // 이 클래스를 사용하는 객체들에게 valueChange 이벤트 신호를 보내준다.
        }
    }
    
    @IBInspectable public var leftTitle: String = "↓"{
        didSet{
            self.leftBtn.setTitle(self.leftTitle, for: .normal)
        }
    }
    
    @IBInspectable public var rightTitle: String = "↑"{
        didSet{
            self.rightBtn.setTitle(self.rightTitle, for: .normal)
        }
    }
    
    @IBInspectable public var bgColor:UIColor = UIColor.cyan {
        didSet{
            self.centerLabel.backgroundColor = self.bgColor
        }
    }
    
    
    
    // 스토리보드에서 호출할 초기화 메소드
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // 프로그래밍 방식 호출 초기화 메소드
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        //스테퍼의 기본 속성 설정
        let borderWidth: CGFloat = 0.5
        let borderColor = UIColor.blue.cgColor
        
        self.leftBtn.tag = -1
        self.leftBtn.setTitle(self.leftTitle, for: .normal)
        self.leftBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        self.leftBtn.layer.borderWidth = borderWidth
        self.leftBtn.layer.borderColor = borderColor
        
        self.rightBtn.tag = 1
        self.rightBtn.setTitle(self.rightTitle, for: .normal)
        self.rightBtn.titleLabel?.font = . boldSystemFont(ofSize: 20)
        
        self.rightBtn.layer.borderWidth = borderWidth
        self.rightBtn.layer.borderColor = borderColor
        
        self.centerLabel.text = String(self.value)
        self.centerLabel.font = .systemFont(ofSize: 16)
        self.centerLabel.textAlignment = .center
        self.centerLabel.backgroundColor = self.bgColor

        self.centerLabel.layer.borderColor = borderColor
        self.centerLabel.layer.borderWidth = borderWidth
        
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        self.addSubview(self.centerLabel)
        
        self.leftBtn.addTarget(self, action: #selector(self.valueChange(_:)), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(self.valueChange(_:)), for: .touchUpInside)
    }
    
    //view의 크기가 변할 때마다 호출되는 메소드!!!!!!
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let btnWidth = self.frame.height //버튼 넓이 = 뷰 높이
        let lblWidth = self.frame.width - (btnWidth * 2) // 레이블 넓이 = 뷰 전체 크기 - 양쪽 버튼 넓이 합
        
        self.leftBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnWidth)
        self.centerLabel.frame = CGRect(x: btnWidth, y: 0, width: lblWidth, height: btnWidth)
        self.rightBtn.frame = CGRect(x: btnWidth + lblWidth, y: 0, width: btnWidth, height: btnWidth)
        
    }
    
    //MARK: Selector
    
    @objc public func valueChange(_ sender: UIButton){

        let sum = self.value + (sender.tag * self.stepValue)
        
        if sum > self.maximumValue { return } //합이 max보다 크면 더하지 않고 종료
        
        if sum < self.minimumValue{ return } //합이 min 보다 작으면 합하지 않고 종료
    
        self.value += (sender.tag * self.stepValue)
    }
}
