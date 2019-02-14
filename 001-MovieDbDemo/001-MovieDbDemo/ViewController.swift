//
//  ViewController.swift
//  001-MovieDbDemo
//
//  Created by 雲端開發部-江世豪 on 2019/2/14.
//  Copyright © 2019 com.mitake. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let view = UIView(frame: CGRect(x: 30, y: 40, width: 111, height: 222))
        view.backgroundColor = .green
        self.view.addSubview(view)
    }


}

