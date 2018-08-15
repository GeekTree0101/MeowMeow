import Foundation
import AsyncDisplayKit
import Hero

extension ASDisplayNode {
    
    enum Identifier {
        case catImage(String)
        case title(String)
        case content(String)
        case star(String)
        case profile(String)
        
        var id: String {
            switch self {
            case .catImage(let id):
                return "catImage-\(id)"
            case .title(let id):
                return "title-\(id)"
            case .content(let id):
                return "content-\(id)"
            case .star(let id):
                return "star-\(id)"
            case .profile(let username):
                return "userprofile-\(username)"
            }
        }
    }
    
    func applyHero(_ identifier: Identifier, modifier: [HeroModifier]?) {
        self.applyHero(identifier.id, modifier: modifier)
    }
    
    func applyHero(_ id: String, modifier: [HeroModifier]?) {
        self.view.hero.id = id
        self.view.hero.modifiers = modifier
    }
}

extension UINavigationController {
    @discardableResult func applyHero(present: HeroDefaultAnimationType,
                                      dismiss: HeroDefaultAnimationType) -> UINavigationController {
        self.hero.isEnabled = true
        self.hero.modalAnimationType =
            .selectBy(presenting: present,
                      dismissing: dismiss)
        return self
    }
    
}
