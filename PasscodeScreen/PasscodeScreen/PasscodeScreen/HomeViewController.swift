//
//  HomeViewController.swift
//  PasscodeScreen
//
//  Created by Elene Tsiramua on 04.12.21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var goBackButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        goBackButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }


    @objc private func buttonClicked() {
        navigationController?.popViewController(animated: true)
    }
}

