import Foundation
import UIKit

extension String {
    
    func attrText(_ attr: [NSAttributedStringKey: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attr)
    }
}
