//
//  ViewController.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    @IBOutlet weak var menuButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func refreshAction() {
        print("perform refresh action")
    }
    
    @IBAction func menuAction() {
        print("perform menu action")
    }
}

