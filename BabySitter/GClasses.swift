//
//  GClasses.swift
//  BabySitter
//
//  Created by 2021M05 on 18/03/22.
//

import UIKit

class BlueThemeButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor().hexStringToUIColor(hex: "#6043F5")
        self.tintColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16.0
    }
}


class GradientLabel: UILabel {
    var gradientColors: [CGColor] = []

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


class SelfSizedTableView: UITableView {
    
    @IBInspectable var maxHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    
    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.isScrollEnabled = maxHeight < contentSize.height
        }
    }
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        let height = min(contentSize.height + contentInset.top + contentInset.bottom, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
