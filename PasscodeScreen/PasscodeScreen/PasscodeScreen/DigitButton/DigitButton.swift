//
//  DigitButton.swift
//  PasscodeScreen
//
//  Created by Elene Tsiramua on 30.11.21.
//

import UIKit

class DigitButton: UIButton {

    enum ButtonState {
        case normal
        case highlighted
    }

    @IBOutlet var contentButton: UIButton!
    @IBOutlet var value: UILabel!
    @IBOutlet var chars: UILabel!

    var digit: Int = 0 {
        didSet {
            value.text = ("\(digit)")
            contentButton.tag = digit
        }
    }

    var buttonState: ButtonState = .normal {
        didSet {
            switch buttonState {
            case .normal:
                contentButton.backgroundColor = .clear
            case .highlighted:
                contentButton.backgroundColor = .white.withAlphaComponent(0.5)
            }
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentButton.layer.borderWidth = 1
        contentButton.layer.borderColor = UIColor.white.cgColor
        contentButton.layer.cornerRadius = contentButton.frame.width / 2
        contentButton.clipsToBounds = true
    }

    //  Do custom initialization here
    private func customInit(){
        Bundle.main.loadNibNamed("DigitButton", owner: self, options: nil)

        addSubview(contentButton)
        contentButton.frame = bounds
        contentButton.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        contentButton.heightAnchor.constraint(equalTo: contentButton.widthAnchor, multiplier: 1.0/1.0).isActive = true


        setTitle("", for: .normal)
        backgroundColor = .clear
        chars.textColor = .white


        var configuration = contentButton.configuration
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 0, bottom: 20, trailing: 0)
        contentButton.configuration = configuration
        contentButton.backgroundColor = .clear
        contentButton.titleLabel?.textColor = .white


    }


    func setDigitValue(_ digitValue: Int) {
        digit = digitValue
    }

    func setChars(_ value: String) {
        chars.text = value
    }

    func getDigitValue() -> Int{
        return digit
    }


}
