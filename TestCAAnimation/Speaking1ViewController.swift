//
//  Speaking1ViewController.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/9.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

class Speaking1ViewController: BaseViewController {

    lazy var img = UIImageView(image: UIImage(named: "ai"))

    lazy var play = UIButton(type: .system)
    lazy var pause = UIButton(type: .system)

    var waveLayer: SpeakWaveLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.gray

        view.addSubview(img)
        img.frame = CGRect(x: 100, y: 100, width: 32, height: 32)

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
        waveLayer = SpeakWaveLayer()
        img.layer.addSublayer(waveLayer!)
    }
    @objc
    func pauseTapped(_ button: UIButton) {
        waveLayer?.removeFromSuperlayer()
        waveLayer = nil
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

class SpeakWaveLayer: CALayer {

    //  圆形麦克风的大小
    let layerWidth = 32.0
    let layerHeight = 32.0

    let innerWidth: Double
    let innerHeight: Double

    //  内部波纹的大小
    let waveWidth = 2.0
    var waveHeight = 16.0
    //  内部波纹的数量
    let waveCount = 5.0
    let leftPadding: Double
    let rightPadding: Double
    //  内部波纹的间隔区域数量
    let wavePaddingCount: Double
    //  内部波纹的间隔区域宽度
    let wavePaddingWidth: Double

    //  左边波纹的起始X
    var originX: Double
    let originY: Double
    //  右边波纹的起始X
    var lastOriginX: Double

    lazy var bgLayer: CALayer = {
        let layer = CALayer()

        layer.backgroundColor = UIColor.colorHex(0x2999fa).cgColor

        return layer

    }()

    override init() {
        innerWidth = layerWidth - 2
        innerHeight = layerHeight - 2

        leftPadding = innerWidth * 0.2
        rightPadding = leftPadding

        wavePaddingCount = waveCount - 1
        wavePaddingWidth = (innerWidth - (waveWidth * waveCount) - leftPadding - rightPadding) / wavePaddingCount

        originX = leftPadding
        originY = innerHeight / 2 - waveHeight / 2

        lastOriginX = innerWidth - rightPadding - waveWidth

        super.init()

        initUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
        let bgLayer = CALayer()
        bgLayer.frame = CGRect(x: (layerWidth - innerWidth) / 2, y: (layerHeight - innerHeight) / 2, width: innerWidth, height: innerHeight)
        bgLayer.backgroundColor = UIColor.colorHex(0x2999fa).cgColor
        bgLayer.corner(with: CGFloat(innerWidth / 2))

        let loopCount = Int(ceil(waveCount / 2))
        //  两边的动画时间一样，所以一起创建
        let waveHeightInterval = waveHeight / Double(loopCount)
        waveHeight = waveHeightInterval
        for i in 0 ..< loopCount {
            let waveLayer = CALayer()
            waveLayer.frame = CGRect(x: originX, y: (innerHeight - waveHeight) / 2, width: waveWidth, height: waveHeight)
            waveLayer.backgroundColor = UIColor.white.cgColor
            let ani = getSpringWave()
            ani.beginTime = CACurrentMediaTime() + Double(i) * 0.1

            waveLayer.add(ani, forKey: nil)
            bgLayer.addSublayer(waveLayer)

            print("\(i)---\((i + 1) * 2)")
            if i == loopCount - 1, (i + 1) * 2 > Int(waveCount) {
                break
            }
            let waveLayer2 = CALayer()
            waveLayer2.frame = CGRect(x: lastOriginX, y: (innerHeight - waveHeight) / 2, width: waveWidth, height: waveHeight)
            waveLayer2.backgroundColor = UIColor.white.cgColor

            waveLayer2.add(ani, forKey: nil)
            bgLayer.addSublayer(waveLayer2)

            waveHeight += waveHeightInterval
            originX = originX + waveWidth + wavePaddingWidth
            lastOriginX = lastOriginX - waveWidth - wavePaddingWidth
        }

        self.addSublayer(bgLayer)
    }

    func getSpringWave() -> CASpringAnimation {
        let ani = CASpringAnimation(keyPath: "bounds.size.height")
        ani.fromValue = waveHeight
        ani.toValue = waveHeight * 0.7
        ani.duration = 0.5
        ani.damping = 5
        ani.autoreverses = true
        ani.repeatCount = HUGE
        return ani
    }
}
