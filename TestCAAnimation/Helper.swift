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
