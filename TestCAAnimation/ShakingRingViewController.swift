//
//  ShakingRingViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/8.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

let bellShakingAnimation = "bellShakingAnimation"

class BellShakeAnimation: CABasicAnimation {
    func setup() {
        fromValue = NSNumber(value: -0.2)
        toValue = NSNumber(value: 0.2)
        duration = 0.2
        repeatCount = HUGE
        autoreverses = true
        isRemovedOnCompletion = true
    }
}

extension UIView {
    func startShaking() {
        let shakeAnimation = BellShakeAnimation(keyPath: "transform.rotation.z")
        shakeAnimation.setup()
        layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        layer.add(shakeAnimation, forKey: bellShakingAnimation)
    }

    func stopShaking() {
        layer.removeAllAnimations()
    }
}


class ShakingRingViewController: BaseViewController {

    lazy var bell = UIImageView(image: UIImage(named: "bell"))

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(bell)
        bell.frame = CGRect(x: 50, y: 100, width: 64, height: 78)
        bell.startShaking()
    }

}
