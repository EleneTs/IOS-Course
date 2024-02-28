//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Elene Tsiramua on 4.02.22.
//

import UIKit

class ErrorView: UIView {

    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var reloadButton: UIButton!

    var retryAction: (()->())?


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupReloadButton() {
        reloadButton.addTarget(self, action:#selector(reloadData), for: .touchUpInside)
    }

    @objc private func reloadData(sender: UIButton){
        retryAction?()
    }

}
