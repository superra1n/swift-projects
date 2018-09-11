//
//  ViewController.swift
//  Project 18b
//
//  Created by LiangTzu Chun on 3/17/16.
//  Copyright © 2016 Jim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for i in 1 ... 100 {
            print("Got a number \(i)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

