//
//  ViewController.swift
//  PasscodeScreen
//
//  Created by Elene Tsiramua on 30.11.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var buttonCollection: [DigitButton]!

    @IBOutlet private var circleViewCollection : [UIView]!

    @IBOutlet private var deleteButton : UIButton!

    @IBOutlet private var stackView : UIStackView!

    private let chars = ["","","ABC","DEF","GHI","JKL","MNO","PQRS","TUV","WXYZ"]

    private var passcode = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonValues()
        setCircleViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        setCircleViews()
        passcode.removeAll()
    }

    @objc func buttonClicked(_ sender: UIButton) {
        buttonCollection[sender.tag].buttonState = .normal

        let num = buttonCollection[sender.tag].getDigitValue()
        newDigit(value: num)
    }

    @objc private func touchDown(_ sender: UIButton) {
        buttonCollection[sender.tag].buttonState = .highlighted
    }

    @objc private func dragExit(_ sender: UIButton) {
        buttonCollection[sender.tag].buttonState = .normal

        let num = buttonCollection[sender.tag].getDigitValue()
        newDigit(value: num)
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        let ind = passcode.count - 1
        setCircleEmpty(index: ind)
    }


    private func setButtonValues() {
        buttonCollection.enumerated().forEach { (index, digitButton) in
            digitButton.setDigitValue(index)
            digitButton.setChars(chars[index])

            digitButton.contentButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            digitButton.contentButton.addTarget(self, action: #selector(touchDown), for: .touchDown)
            digitButton.contentButton.addTarget(self, action: #selector(dragExit), for: .touchDragExit)
        }

        deleteButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
    }

    private func setCircleViews() {
        circleViewCollection.forEach { (circleView) in
            circleView.layer.cornerRadius = circleView.frame.width / 2
            circleView.clipsToBounds = true
            circleView.layer.borderWidth = 1
            circleView.layer.borderColor = UIColor.white.cgColor
            circleView.layer.backgroundColor = UIColor.clear.cgColor
        }
    }

    private func setCircleFilled(index: Int) {
        circleViewCollection[index].layer.backgroundColor = UIColor.white.cgColor
    }
    private func setCircleEmpty(index: Int) {
        if index < 0 { return }
        circleViewCollection[index].layer.backgroundColor = UIColor.clear.cgColor
        passcode.remove(at: index)

    }

    private func newDigit(value: Int) {
        if passcode.count <= 3 {
            passcode.append(value)
            setCircleFilled(index: passcode.count - 1)
        }
        guard passcode.count == 4 else { return }
        guard isCorrect() else {
            shakeWhenIncorrect()
            return
        }
        performSegue(withIdentifier: "pushHomeViewController", sender: self)

    }

    private func isCorrect() -> Bool {
        for i in 0...3 {
            if passcode[i] != 1 { return false }
        }
        return true
    }


    private func shakeWhenIncorrect() {
        CATransaction.begin()
        CATransaction.setCompletionBlock({ [self] in
            self.setCircleViews()
            self.passcode.removeAll()
         })

        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: stackView.center.x - 10, y: stackView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: stackView.center.x + 10, y: stackView.center.y))

        stackView.layer.add(animation, forKey: "position")
        CATransaction.commit()
    }
}

