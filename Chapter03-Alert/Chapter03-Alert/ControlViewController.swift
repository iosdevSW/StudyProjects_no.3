//
//  ControlViewController.swift
//  Chapter03-Alert
//
//  Created by 신상우 on 2021/11/13.
//

import UIKit

class ControlViewController: UIViewController{
    let slider = UISlider()
    var sliderValue: Float {
        return self.slider.value
    }
    
    override func viewDidLoad() {
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)
        
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height+10)
    }
}
