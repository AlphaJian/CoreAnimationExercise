
//
//  Speak2ViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/9.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class Speaking2ViewController: BaseViewController {

    lazy var img = UIImageView(image: UIImage(named: "mic"))

    lazy var play = UIButton(type: .system)
    lazy var pause = UIButton(type: .system)

    var waveLayer: NormalSpeakWaveLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        waveLayer = NormalSpeakWaveLayer(width: 100, height: 100, bgImg: UIImage(named: "voice_default")!)
        waveLayer?.frame = img.layer.bounds
        img.layer.addSublayer(waveLayer!)
    }
    @objc
    func pauseTapped(_ button: UIButton) {
        waveLayer?.removeFromSuperlayer()
        waveLayer = nil
    }

    func getSpringAnimation(waveHeight: Double) -> CASpringAnimation {
        let ani = CASpringAnimation(keyPath: "bounds.size.height")
        ani.fromValue = waveHeight
        ani.toValue = waveHeight * 0.3
        ani.duration = 1
        ani.repeatCount = HUGE

        return ani
    }

    func getKeyFrameAnimation(waveHeight: Double) -> CAKeyframeAnimation {
        let ani = CAKeyframeAnimation(keyPath: "bounds.size.height")
        ani.values = [waveHeight * 0.8, waveHeight * 0.6, waveHeight * 0.4]
        ani.keyTimes = [0.3, 0.6, 0.9]
        ani.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        ani.duration = 1
        ani.repeatCount = HUGE
        return ani
    }

}

class NormalSpeakWaveLayer: CALayer {
    //  圆形麦克风的大小
    let layerWidth: Double
    let layerHeight: Double

    let innerWidth: Double
    let innerHeight: Double

    let maskTop: Double
    let maskWidth: Double
    let maskHeight: Double

    let assWidth: Double
    let assHeight: Double

    let waveWidth: Double
    let waveHeight: Double

    let bgImg: UIImage

    init(width: Double, height: Double, bgImg: UIImage) {
        layerWidth = width
        layerHeight = height
        self.bgImg = bgImg

        innerWidth = layerWidth
        innerHeight = layerHeight

        maskTop = innerHeight * 0.16
        maskWidth = innerWidth * 0.25
        maskHeight = innerHeight * 0.4

        assWidth = maskWidth
        assHeight = maskHeight / 2

        waveWidth = maskWidth
        waveHeight = maskHeight * 0.6

        super.init()

        initUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        backgroundColor = UIColor.white.cgColor

        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: (layerWidth - innerWidth) / 2, y: (layerHeight - innerHeight) / 2, width: innerWidth, height: innerHeight)
        bgLayer.contents = bgImg.cgImage
        bgLayer.corner(with: CGFloat(innerWidth / 2))

        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: innerWidth / 2 - maskWidth / 2, y: maskTop, width: maskWidth, height: maskHeight)
        maskLayer.backgroundColor = UIColor.colorHex(0xa9d6fd).cgColor
        maskLayer.cornerRadius = CGFloat(maskWidth / 2)
        bgLayer.addSublayer(maskLayer)

        let assLayer =  SemiLayer(isSemiAbove: true, rect: CGRect(x: 0, y: maskHeight - assHeight, width: assWidth, height: assHeight))
        assLayer.fillColor = UIColor.white.cgColor
        maskLayer.addSublayer(assLayer)

        let waveLayer = CALayer()
        waveLayer.frame = CGRect(x: 0, y: maskHeight - assHeight, width: waveWidth, height: waveHeight)
        waveLayer.backgroundColor = UIColor.white.cgColor
        waveLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        waveLayer.add(getSpringAnimation(waveHeight: waveHeight), forKey: nil)
        maskLayer.addSublayer(waveLayer)

        addSublayer(bgLayer)
    }

    func getSpringAnimation(waveHeight: Double) -> CASpringAnimation {
        let ani = CASpringAnimation(keyPath: "bounds.size.height")
        ani.fromValue = waveHeight * 0.9
        ani.toValue = waveHeight * 0.3
        ani.duration = 1
        ani.repeatCount = HUGE
        ani.damping = 5
        return ani
    }
}
