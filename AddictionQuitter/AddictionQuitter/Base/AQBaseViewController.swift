//
//  AQBaseViewController.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 09/12/23.
//

import UIKit

class AQBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    
    func configNavBar(title: String){
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
