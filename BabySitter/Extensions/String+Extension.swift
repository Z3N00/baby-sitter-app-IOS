//
//  UIStoryBoard+Extension.swift


import Foundation
import UIKit



extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
