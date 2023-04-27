//
//  CustomColors.swift
//  Notes
//
//  Created by Jayasurya on 16/04/23.
//

import UIKit

class CustomColors: UIView {

    static let shared = CustomColors()
    
    var systemBackground: UIColor {
        get{
            return isLightTheme() ? UIColor.secondarySystemBackground : UIColor.systemBackground
        }
    }
    
    private func isLightTheme() -> Bool{
        
        switch self.traitCollection.userInterfaceStyle{
        case .dark:
            return false
        case .light:
            return true
        case .unspecified:
            return false
        @unknown default:
            return false
        }
    }
}
