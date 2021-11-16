//
//  CSTabBarController.swift
//  Chapter03- CSTabBar
//
//  Created by 신상우 on 2021/11/16.
//

import UIKit

class CSTabBarController: UITabBarController{
    let csView = UIView()
    let tabItem01 = UIButton(type: .system)
    let tabItem02 = UIButton(type: .system)
    let tabItem03 = UIButton(type: .system)
    
    override func viewDidLoad() {
        self.tabBar.isHidden = true // 기존 탭 바를 화면에서 숨김
        //새로운 탭 바 역할을 할 뷰를 위해 기준 좌표와 크기를 정의
        let width = self.view.frame.width
        let height: CGFloat = 50
        let x: CGFloat = 0
        let y = self.view.frame.height - height
        
        self.csView.frame = CGRect(x: x, y: y, width: width, height: height)
        self.csView.backgroundColor = .brown
        
        self.view.addSubview(self.csView)
        
        let tabBtnWidth = self.csView.frame.size.width / 3
        let tabBtnHeight = self.csView.frame.height
        
        self.tabItem01.frame = CGRect(x: 0, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem02.frame = CGRect(x: tabBtnWidth, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        self.tabItem03.frame = CGRect(x: tabBtnWidth * 2, y: 0, width: tabBtnWidth, height: tabBtnHeight)
        
        self.addTabBarBtn(btn: self.tabItem01, title: "첫 번째 버튼", tag: 0)
        self.addTabBarBtn(btn: self.tabItem02, title: "두 번쨰 버튼", tag: 1)
        self.addTabBarBtn(btn: self.tabItem03, title: "세 번째 버튼", tag: 2)
        
        //처음에 첫 번째 탭이 선택되어 있도록 초기 상태 정의
        self.onTabBarItemClick(self.tabItem01)
    }
    
    // 버튼의 공통 속성을 정의하기 위한 메소드
    func addTabBarBtn(btn: UIButton, title: String, tag: Int) {
        btn.setTitle(title, for: .normal)
        btn.tag = tag
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.yellow, for: .selected)
        
        btn.addTarget(self, action: #selector(self.onTabBarItemClick(_:)), for: .touchUpInside)
        
        self.csView.addSubview(btn)
    }
    
    //MARK : Selector
    @objc func onTabBarItemClick(_ sender: UIButton){
        //모두 선택되지 않은 상태로 초기화
        self.tabItem01.isSelected = false
        self.tabItem02.isSelected = false
        self.tabItem03.isSelected = false
        
        //인자값으로 받은 버튼만 선택된 상태로 변경
        sender.isSelected = true
        
        // 버튼에 설정된 태그값을 사용하여 뷰 컨트롤러 전환
        self.selectedIndex = sender.tag
    }
}
