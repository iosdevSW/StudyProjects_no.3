//
//  FrontViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 신상우 on 2021/11/17.
//

import UIKit

class FrontViewController: UIViewController {
    var delegate: RevealViewController? //델리게이트 for 사이드 바 오픈
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //사이드 바 오픈 버튼
        let btnSideBar = UIBarButtonItem(image: UIImage(named: "sidemenu.png"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(self.moveSide(_:)))
        self.navigationItem.leftBarButtonItem = btnSideBar
        
        //왼쪽 화면 끝에서 오른쪽으로 패닝 하는 제스처 등록
        //패닝 : 화면의 한쪽 끝에서 시작하여 반대편까지 드래그가 이어지는 패턴
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.moveSide(_:)))
        dragLeft.edges = UIRectEdge.left // 시작 모서리는 왼쪽
        self.view.addGestureRecognizer(dragLeft)
        
        //화면을 스와이프 하는 제스처를 정의 (닫기용)
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(self.moveSide(_:)))
        dragRight.direction = .left
        self.view.addGestureRecognizer(dragRight)
    }
    
    @objc func moveSide(_ sender: Any){
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
    
}
