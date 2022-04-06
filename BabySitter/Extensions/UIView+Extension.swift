//
//  UIView+Extension.swift
//  BabySitter
//
//  Created by 2022M3 on 27/03/22.
//

import Foundation


protocol ViewStyle { }

extension UIView: ViewStyle { }

extension ViewStyle where Self: UIView {
    
    @discardableResult func setRound() -> Self {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.clipsToBounds = true
        return self
    }
    
    @discardableResult func cornerRadius(cornerRadius: CGFloat,clips: Bool = true) -> Self {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = clips
        return self
    }
    
    
    @discardableResult func borderColor(color: UIColor, borderWidth: CGFloat = 1.0) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        return self
    }
    
    @discardableResult func shadow(color: UIColor = UIColor.black, shadowOffset : CGSize = CGSize(width: 1.0, height: 1.0) , shadowOpacity : Float = 0.5) -> Self {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
        return self
    }
    
    @discardableResult func backGroundColor(color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
}
