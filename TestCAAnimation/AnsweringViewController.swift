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

    lazy var img = UIImageView(image: UIImage(named: "mic"))

    lazy var play = UIButton(type: .system)
    lazy var pause = UIButton(type: .system)

    var waveLayer: AnswerAnimation?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        view.addSubview(img)
        img.frame = CGRect(x: 100, y: 100, width: 100, height: 100)

        view.addSubview(play)
        view.addSubview(pause)

        play.addTarget(self, action: #selector(playTapped(_:)), for: .touchUpInside)
        play.setTitle("play", for: .normal)
        play.frame = CGRect(x: 100, y: 200, width: 50, height: 30)
        pause.addTarget(self, action: #selector(pauseTapped(_:)), for: .touchUpInside)
        pause.setTitle("pause", for: .normal)
        pause.frame = CGRect(x: 200, y: 200, width: 50, height: 30)

    }

    @objc
    func playTapped(_ button: UIButton) {
        waveLayer = AnswerAnimation(width: 100, height: 100)
        waveLayer?.frame = img.layer.bounds
        img.layer.addSublayer(waveLayer!)
    }
    @objc
    func pauseTapped(_ button: UIButton) {
        waveLayer?.removeFromSuperlayer()
        waveLayer = nil
    }


}

class AnswerAnimation: CALayer {
    let layerWidth: Double
    let layerHeight: Double

    let loopCount = 2

    let speakLayer: NormalSpeakWaveLayer

    let intervalCount = 3

    init(width: Double, height: Double) {
        layerWidth = width
        layerHeight = height

        speakLayer = NormalSpeakWaveLayer(width: width, height: height, bgImg: UIImage(named: "voice_answering") ?? UIImage())
        super.init()

        initUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        for i in 0 ... loopCount {
            let group = CAAnimationGroup()
            group.animations = [getScaleAnimation(), getColorAnimation()]
            group.duration = 1
            group.repeatCount = HUGE
            group.beginTime = CACurrentMediaTime() + Double(i) * 0.5
            group.timingFunction = CAMediaTimingFunction(name: .easeOut)
            let scaleLayer = CALayer()
            scaleLayer.backgroundColor = UIColor(red: 255 / 255.0, green: 216 / 255.0, blue: 87 / 255.0, alpha: 1).cgColor
            scaleLayer.frame = CGRect(x: 0, y: 0, width: layerWidth, height: layerWidth)
            scaleLayer.cornerRadius = CGFloat(layerWidth / 2)
            scaleLayer.add(group, forKey: "\(i)")
            addSublayer(scaleLayer)
        }

        addSublayer(speakLayer)
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
        key.values = [UIColor.colorHexAlpha(0x00E6FD, alpha: 0.5).cgColor,
                      UIColor.colorHexAlpha(0x00E6FD, alpha: 0.3).cgColor,
                      UIColor.colorHexAlpha(0x00E6FD, alpha: 0).cgColor]
        key.keyTimes = [0.3, 0.6, 1]

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
