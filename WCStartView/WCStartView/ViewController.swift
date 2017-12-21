//
//  ViewController.swift
//  WCStartView
//
//  Created by 工作 on 2017/12/19.
//  Copyright © 2017年 工作. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statView = WCStarView(frame: CGRect(x: 10, y: 70, width: 200, height: 50), startNum: 5, rateStyle: .IncompleteStar, isAnimate: true) { (startView, score) in
            
        };
        statView.delegate = self
        self.view.addSubview(statView)
    }

}

extension ViewController:WCStarRateViewDelegate
{
    func wcstartViewDelegate(startView: WCStarView, currentScore: Float) {
        
    }
}

