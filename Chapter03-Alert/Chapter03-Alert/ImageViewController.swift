//
//  ImageViewController.swift
//  Chapter03-Alert
//
//  Created by 신상우 on 2021/11/13.
//

import UIKit

class ImageViewController: UIViewController{
    override func viewDidLoad() {
        let icon = UIImage(named: "rating5")
        let iconV = UIImageView(image: icon)
        
        iconV.frame = CGRect(x: 0, y: 0, width: (icon?.size.width)!, height: (icon?.size.height)!+10)
        
        self.view.addSubview(iconV)
        
        //외부에서 참조할 뷰 컨트롤러 사이즈를 이미지 크기와 동일하게 설정.
        self.preferredContentSize = CGSize(width: (icon?.size.width)!, height: (icon?.size.height)!+10)
        
    }
}

