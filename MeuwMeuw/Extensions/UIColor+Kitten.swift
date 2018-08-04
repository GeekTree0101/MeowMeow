import Foundation
import UIKit

extension UIColor {
    
    static func title(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: 34 / 255, green: 51 / 255, blue: 66 / 255, alpha: alpha)
    }
    
    static func content(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: 55 / 255, green: 56 / 255, blue: 58 / 255, alpha: alpha)
    }
    
    static func moreSee(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: 89 / 255, green: 106 / 255, blue: 135 / 255, alpha: alpha)
    }
    
    static func username(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: 72 / 255, green: 76 / 255, blue: 84 / 255, alpha: alpha)
    }
    
    static func paw(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red: 1, green: 152 / 255, blue: 0, alpha: alpha)
    }
}
