//
//  AnsweringViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/8.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class AnsweringViewController: BaseViewController {

    lazy var answerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        view.addSubview(answerView)
        answerView.frame = CGRect(x: 150, y: 150, width: 100, height: 100)

        for i in 0 ... 2 {
            let group = CAAnimationGroup()
            group.animations = [getScaleAnimation(), getColorAnimation()]
            group.duration = 1
            group.repeatCount = HUGE
            group.beginTime = CACurrentMediaTime() + Double(i + 1) * 0.3
            group.timingFunction = CAMediaTimingFunction(name: .easeOut)
            let scaleLayer = CALayer()
            scaleLayer.backgroundColor = UIColor(red: 255 / 255.0, green: 216 / 255.0, blue: 87 / 255.0, alpha: 1).cgColor
            scaleLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            scaleLayer.cornerRadius = 25
            scaleLayer.add(group, forKey: "\(i)")
            answerView.layer.addSublayer(scaleLayer)

        }
        let bgLayer = CALayer()
        bgLayer.contents = UIImage(named: "answer")?.cgImage
        bgLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        answerView.layer.addSublayer(bgLayer)

        let waveLayer = CALayer()
        waveLayer.backgroundColor = UIColor.white.cgColor
        waveLayer.frame = CGRect(x: 50 - 12 , y: 46, width: 25, height: 40)
        waveLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        waveLayer.corner(with: 12)
                waveLayer.add(getSpringAnimation(), forKey: "getSpringAnimation")
        answerView.layer.addSublayer(waveLayer)
    }

    func getScaleAnimation() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 2
        scale.repeatCount = HUGE
        return scale
    }

    func getColorAnimation() -> CAKeyframeAnimation {
        let key = CAKeyframeAnimation(keyPath: "backgroundColor")
        key.values = [UIColor(red: 255 / 255.0, green: 216 / 255.0, blue: 87 / 255.0, alpha: 0.5).cgColor,
                      UIColor(red: 255 / 255.0, green: 231 / 255.0, blue: 152 / 255.0, alpha: 0.5).cgColor,
                      UIColor(red: 255 / 255.0, green: 241 / 255.0, blue: 197 / 255.0, alpha: 0.5).cgColor,
                      UIColor(red: 255 / 255.0, green: 241 / 255.0, blue: 197 / 255.0, alpha: 0).cgColor]
        key.keyTimes = [0.3, 0.6, 0.9, 1]

        return key
    }

    func getSpringAnimation() -> CASpringAnimation {
        let spring = CASpringAnimation(keyPath: "bounds.size.height")
        spring.fromValue = 30
        spring.toValue = 20
        spring.damping = 5
        spring.initialVelocity = 10
        spring.repeatCount = HUGE
        spring.stiffness = 50
        spring.duration = 3

        return spring
    }
}
