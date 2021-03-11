//
//  SubViewController.swift
//  TabDemo
//
//  Created by Vikram Jagad on 09/03/21.
//

import UIKit

class SubViewController: UIViewController {
    //MARK:- Interface Builder
    //UILabel
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = title
    }
}
