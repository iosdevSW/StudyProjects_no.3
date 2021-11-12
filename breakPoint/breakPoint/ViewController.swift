//
//  ViewController.swift
//  breakPoint
//
//  Created by 신상우 on 2021/11/03.
//

import UIKit

class ViewController: UIViewController {

    var sum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var  count = 0
        for row in 5...10{
            count += 1 //break point 행 번호 클릭 ( 이 행이 실행 되기 직전에 멈춤. )
            self.sum += row
        }
        print("총 합은 \(self.sum), \(count)회 실행되었습니다.")
    }


}

