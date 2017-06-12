//
//  ViewController.swift
//  CMTextField
//
//  Created by CM on 2017/6/6.
//  Copyright © 2017年 CM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldMy: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let view = CMExchangeComputer.getInstance(327, textObj: textFieldMy)
        textFieldMy.inputView = view
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}


