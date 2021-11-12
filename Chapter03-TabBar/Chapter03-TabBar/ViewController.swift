//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by 신상우 on 2021/11/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UILabel(frame: CGRect(x: 0, y: 100, width: 100, height: 30))
        title.text = "첫 번째 탭"
        title.textColor = .red
        title.textAlignment = .center
        title.font = .boldSystemFont(ofSize: 14)
        title.sizeToFit() // 콘텐츠 내용에 맞게 레이블 크기 변경
        title.center.x = self.view.frame.width / 2 // 레이블을 화면 x축 중앙애 오게 설정
        self.view.addSubview(title)
        
    }
    //UIViewController에 상위 클래스인 UIResponder에 있는 화면 터치가 끝났을 때 호출되는 메소드
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //애니메이션 이용 탭할 때 마다 서서히 사라지고 나타나는 탭바 만들기.
        let tabBar = self.tabBarController?.tabBar
//        tabBar?.isHidden = (tabBar?.isHidden == true) ? false : true
        UIView.animate(withDuration: TimeInterval(0.15)){
            //withDuration의 인자값은 초 단위이다.
            //w
            //투명도를 0이면 1로 1이면 0으로
            tabBar?.alpha = ( tabBar?.alpha == 0 ? 1 : 0)
        }
    }


}

