//
//  RevealViewController.swift
//  Chapter04-SideBarDIY
//
//  Created by 신상우 on 2021/11/17.
//

import UIKit
//Custom Container ViewController
class RevealViewController: UIViewController {
    //MARK: Properties
    var contentVC: UIViewController?
    var sideVC: UIViewController?
    
    var isSideBarShowing = false
    
    let SLIDE_TIME = 0.3 //사이드바가 열리고 닫히는데 걸리는 시간
    let SIDEBAR_WIDTH: CGFloat = 260 // 사이드 바가 열릴 넓이
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    //MARK: Method
    func setupView() { // 초기 회면 설정
        if let vc = self.storyboard?.instantiateViewController(identifier: "sw_front") as? UINavigationController {
            self.contentVC = vc
            self.addChild(vc) // 프론트 컨트롤러를 메인 컨트롤러의 자식 뷰컨트롤러로 등록
            self.view.addSubview(vc.view) // 프론터 컨트롤러의 뷰를 메인컨트롤러의 서브 뷰로 등록
            vc.didMove(toParent: self) // 프론트 컨트롤러에 부모 뷰 컨트롤러가 바꼈음을 알린다.

            //프론트 컨트롤러의 델리게이트 변수에 참조 정보를 넣어준다.
            let frontVC = vc.viewControllers[0] as? FrontViewController
            frontVC?.delegate = self
        }
    }
    
    func getSideView() { //사이드 바의 뷰를 읽어온다.
        guard self.sideVC == nil else { return }
        
        guard  let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") else { return }
        
        self.sideVC = vc
        
        self.addChild(vc) // 읽어온 사이드 바 컨트롤러 객체를 컨테이너 뷰 컨트롤러에 연결
        self.view.addSubview(vc.view)
        
        vc.didMove(toParent: self) //_프론트 컨트롤러에 부모 뷰 컨트롤러가 바뀌었음을 알려준다.
        
        self.view.bringSubviewToFront((self.contentVC?.view)!) // _프론트 컨트롤러 뷰를 제일 위로 올린다.
    }
    
    func setShadowEffect(shadow: Bool, offset: CGFloat) { // 콘텐츠뷰에 그림자를 준다.
        if shadow == true {
            self.contentVC?.view.layer.masksToBounds = false
            self.contentVC?.view.layer.cornerRadius = 10
            self.contentVC?.view.layer.shadowOpacity = 0.8
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset)
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    func openSideBar(_ complete: ( () -> Void)? ) { // 사이드 바를 연다
        self.getSideView() // 사이드 바 뷰를 읽어온다.
        self.setShadowEffect(shadow: true, offset: -2) //그림자 효과를 준다
        
        //천천히 열리는 애니메이션 옵션
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])//애플문서 참조
        //curveEaseInOut : 구간별 속도 옵션! 처음과 끝은 느리게 중간엔 빠르게
        //beginFromCurrentState 현재 다른 애니메이션이 진행 중일지라도 지금 상태에서 바로 진행 하라는 의미
        
        //천천히 열리는 애니메이션 실행
        UIView.animate(withDuration: TimeInterval(self.SLIDE_TIME), delay: TimeInterval(0), options: options, animations: {
                        self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        },
        completion: {
            if $0 == true {
                self.isSideBarShowing = true //열림 상태로 플래그 변경
                complete?()
            }
        })
    }
    
    func closeSideBar(_ complete: ( () -> Void)? ) { //사이드 바를 닫는다.
        //애니메이션 옵션 정의
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        
        //애니메이션 실행
        UIView.animate(withDuration: TimeInterval(self.SLIDE_TIME), delay: TimeInterval(0), options: options, animations:{
            self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
        completion: {
            if $0 == true {
                //사이드 바 뷰 제거
                self.sideVC?.view.removeFromSuperview()
                self.sideVC = nil
                
                self.isSideBarShowing = false // 플래그 변경
                self.setShadowEffect(shadow: false, offset: 0) // 그림자 효과 제거
                // 인자값으로 입력받은 완료 함수를 실행한다.
                complete?()
            }
        })
    }
    
}
