//
//  GExtension+UIFont.swift
//
//

import UIKit

extension UIFont {
    
    enum FontType: String {
        case regular                 = "SFProDisplay-Regular"
        case medium                  = "SFProDisplay-Medium"
        case bold                    = "Roboto-Bold"
        case semiBold                = "SFProDisplay-Semibold"
        case PoppinsSemiBold         = "Poppins-SemiBold"
    }
    
    /// Set custom font
    /// - Parameters:
    ///   - type: Font type.
    ///   - size: Size of font.
    ///   - isRatio: Whether set font size ratio or not. Default true.
    /// - Returns: Return font.
    class func customFont(ofType type: FontType, withSize size: CGFloat, enableAspectRatio isRatio: Bool = true) -> UIFont {
        return UIFont(name: type.rawValue, size: isRatio ? size * ScreenSize.fontAspectRatio : size) ?? UIFont.systemFont(ofSize: size)
    }
}

