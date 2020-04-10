//
//  Speaking1ViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/9.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class Speaking1ViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let layerWidth = 32.0
        let layerHeight = 32.0

        let waveWidth = 2.0
        let waveHeight = 20.0
        let waveCount = 5.0
        let wavePaddingCount = waveCount + 1
        let wavePaddingWidth = (layerWidth - (waveWidth * waveCount)) / wavePaddingCount

        var originX = wavePaddingWidth
        let originY = layerHeight / 2 - waveHeight / 2

        var lastOriginX = layerWidth - wavePaddingWidth - waveWidth

        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: 100, y: 100, width: layerWidth, height: layerHeight)
        bgLayer.backgroundColor = UIColor.colorHex(0x2999fa).cgColor
        bgLayer.beginTime = 1
        bgLayer.corner(with: 16)

        let loopCount = Int(ceil(waveCount / 2))

        for i in 0 ..< loopCount {
            let waveLayer = CALayer()
            waveLayer.frame = CGRect(x: originX, y: originY, width: waveWidth, height: waveHeight)
            waveLayer.backgroundColor = UIColor.white.cgColor
            let ani = getSpringAnimation()
            ani.beginTime = CACurrentMediaTime() + Double(i) * 0.1

            waveLayer.add(ani, forKey: nil)
            bgLayer.addSublayer(waveLayer)

            if i == loopCount - 1, (i + 1) * 2 < Int(waveCount) {
                return
            }
            let waveLayer2 = CALayer()
            waveLayer2.frame = CGRect(x: lastOriginX, y: originY, width: waveWidth, height: waveHeight)
            waveLayer2.backgroundColor = UIColor.white.cgColor

            waveLayer2.add(ani, forKey: nil)
            bgLayer.addSublayer(waveLayer2)

            originX = originX + waveWidth + wavePaddingWidth
            lastOriginX = lastOriginX - waveWidth - wavePaddingWidth
        }

        view.layer.addSublayer(bgLayer)
    }

    func getSpringAnimation() -> CASpringAnimation {
        let ani = CASpringAnimation(keyPath: "bounds.size.height")
        ani.fromValue = 20
        ani.toValue = 10
        ani.duration = 0.5
        ani.damping = 5
        ani.autoreverses = true
        ani.repeatCount = HUGE
        return ani
    }

}
