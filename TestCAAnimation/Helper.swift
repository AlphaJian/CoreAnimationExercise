//
//  Helper.swift
//  TestCAAnimation
//
//  Created by ken.zhang on 2020/4/8.
//  Copyright © 2020 ken.zhang. All rights reserved.
//

import UIKit

protocol Cornerable {
    func corner(with radius: CGFloat?, byRoundingCorners corners: UIRectCorner, bounds: CGRect?)
}

extension Cornerable where Self: UIView {
    func corner(with radius: CGFloat? = nil, byRoundingCorners corners: UIRectCorner = .allCorners, bounds rect: CGRect? = nil) {
        let customBounds = rect ?? bounds
        layer.rasterizationScale = UIScreen.screenScale

        if corners == .allCorners {
            layer.masksToBounds = true
            layer.cornerRadius = radius ?? customBounds.size.height / 2
        } else {
            let r = radius ?? min(customBounds.width / 2, customBounds.height / 2)
            let maskPath = UIBezierPath(roundedRect: customBounds, byRoundingCorners: corners, cornerRadii: CGSize(width: r, height: r))

            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = customBounds
            shapeLayer.path = maskPath.cgPath

            layer.mask = shapeLayer
        }
    }
}

extension CALayer {
    func corner(with radius: CGFloat? = nil, byRoundingCorners corners: UIRectCorner = .allCorners, bounds rect: CGRect? = nil) {
        let customBounds = rect ?? bounds
        rasterizationScale = UIScreen.screenScale

        if corners == .allCorners {
            masksToBounds = true
            cornerRadius = radius ?? customBounds.size.height / 2
        } else {
            let r = radius ?? min(customBounds.width / 2, customBounds.height / 2)
            let maskPath = UIBezierPath(roundedRect: customBounds, byRoundingCorners: corners, cornerRadii: CGSize(width: r, height: r))

            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = customBounds
            shapeLayer.path = maskPath.cgPath

            mask = shapeLayer
        }
    }

    func semiCycle() -> CAShapeLayer {
        rasterizationScale = UIScreen.screenScale
        let center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let radius = bounds.size.width / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat.pi * 2, endAngle: CGFloat.pi, clockwise: true)
        let semiLayer = CAShapeLayer()
        semiLayer.frame = CGRect(x: 0, y: -bounds.size.width, width: bounds.size.width, height: bounds.size.height)
        semiLayer.path = path.cgPath
        addSublayer(semiLayer)

        return semiLayer
    }
}

extension UIView: Cornerable { }

extension UIScreen {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var screenScale: CGFloat {
        return UIScreen.main.scale
    }

    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }

    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }

    static func screenAdapt(_ value: CGFloat) -> CGFloat {
        return value / UIScreen.screenScale
    }
}

extension UIColor {

    class func colorHex(_ rgbHex: Int) -> UIColor {
        return UIColor.colorHexAlpha(rgbHex, alpha: CGFloat(1.0))
    }

    class func colorHexAlpha(_ rgbHex: Int, alpha: CGFloat) -> UIColor {
        let red = CGFloat((rgbHex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((rgbHex & 0xff00) >> 8) / 255.0
        let blue = CGFloat((rgbHex & 0xff) >> 0) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    class func hexColor(with name: String)-> UIColor?{
        let strippedString = name.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: strippedString)
        var hexNum :UInt32 = 0
        if !(scanner.scanHexInt32(&hexNum)) {
            return nil
        }
        return UIColor.colorHex(Int(hexNum))
    }
}

class SemiLayer: CAShapeLayer {
    init(isSemiAbove: Bool, rect: CGRect) {
        super.init()
        let center = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        let radius = rect.size.width / 2
        let bpath = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: isSemiAbove ? CGFloat.pi * 2 : CGFloat.pi ,
                                endAngle: isSemiAbove ? CGFloat.pi : CGFloat.pi * 2 ,
                                clockwise: true)
        frame = rect
        path = bpath.cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpecialLayer: CAShapeLayer {
    init(frame: CGRect) {
        super.init()

        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radius = frame.size.width / 2

        let bPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        self.frame = frame
        path = bPath.cgPath

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
