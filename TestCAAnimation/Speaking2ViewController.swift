
//
//  Speak2ViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/9.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class Speaking2ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layerWidth = 200.0
        let layerHeight = 200.0

        let maskTop = layerHeight * 0.2
        let maskWidth = layerWidth * 0.22
        let maskHeight = layerHeight * 0.4

        let assWidth = maskWidth
        let assHeight = maskHeight / 2

        let waveWidth = maskWidth
        let waveHeight = maskHeight * 0.6

        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 100, y: 100, width: layerWidth, height: layerHeight)
        bgLayer.contents = UIImage(named: "voice_default")?.cgImage
        bgLayer.corner(with: CGFloat(layerWidth / 2))

        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: layerWidth / 2 - maskWidth / 2, y: maskTop, width: maskWidth, height: maskHeight)
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


        view.layer.addSublayer(bgLayer)
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
