import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift

class UserInfoNode: ASDisplayNode {
    
    lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.style.preferredSize = self.type.profileSize
        node.cornerRadius = self.type.profileSize.height / 2.0
        node.borderWidth = 1.0
        node.borderColor = UIColor.paw(alpha: 0.5).cgColor
        return node
    }()
    
    let nameNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        return node
    }()
    
    enum ScreenType {
        case compact
        case profile
        
        var profileSize: CGSize {
            switch self {
            case .compact:
                return .init(width: 50.0, height: 50.0)
            case .profile:
                return .init(width: 80.0, height: 80.0)
            }
        }
        
        var usernameAttr: [NSAttributedStringKey: Any] {
            switch self {
            case .compact:
                return [.font: UIFont.systemFont(ofSize: 15.0),
                        .foregroundColor: UIColor.username()]
            case .profile:
                return [.font: UIFont.systemFont(ofSize: 20.0),
                        .foregroundColor: UIColor.username()]
            }
        }
    }
    
    let disposeBag = DisposeBag()
    let type: ScreenType
    
    init(_ type: ScreenType) {
        self.type = type
        super.init()
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        self.isOpaque = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1, animations: {
            self.imageNode.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
            self.imageNode.alpha = 0.8
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.resetTransform(0.1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?,
                                   with event: UIEvent?) {
        self.resetTransform(0.1)
    }
    
    private func resetTransform(_ duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.imageNode.transform = CATransform3DIdentity
            self.imageNode.alpha = 1.0
        }, completion: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        switch type {
        case .compact:
            return ASStackLayoutSpec(direction: .vertical,
                                     spacing: 6.0,
                                     justifyContent: .start,
                                     alignItems: .center,
                                     children: [imageNode, nameNode])
        default:
            return ASLayoutSpec()
        }
    }
}
