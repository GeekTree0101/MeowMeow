import Foundation
import AsyncDisplayKit

class PawNode: ASButtonNode {
    let size: CGSize = .init(width: 80.0, height: 80.0)
    static let didTapPawName: Notification.Name =
        .init(rawValue: "PawNode.didTapPawNotification")
    
    override init() {
        super.init()
        self.setImage(#imageLiteral(resourceName: "paw").applyNewColor(with: .white), for: .normal)
        self.backgroundColor = UIColor.paw()
        self.style.preferredSize = size
        self.imageNode.contentMode = .scaleAspectFit
        self.imageNode.transform = CATransform3DMakeScale(0.5, 0.5, 1.0)
        self.cornerRadius = size.height / 2.0
        self.isUserInteractionEnabled = true
    }
    
    override func didLoad() {
        super.didLoad()
        self.borderColor =  UIColor.clear.cgColor
        self.borderWidth = 1.0
        self.shadowColor = UIColor.black.cgColor
        self.shadowOpacity = 0.5
        self.shadowOffset = .init(width: 3.0, height: 3.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
            self.alpha = 0.8
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.resetTransform(0.2)
        NotificationCenter.default.post(name: PawNode.didTapPawName,
                                        object: nil)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?,
                                   with event: UIEvent?) {
        self.resetTransform(0.2)
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CATransform3DMakeTranslation(1.0, 100.0, 1.0)
            self.alpha = 0.0
        }, completion: { _ in
            self.isHidden = true
        })
    }
    
    func show() {
        self.resetTransform(0.5)
    }
    
    private func resetTransform(_ duration: TimeInterval) {
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.transform = CATransform3DIdentity
            self.alpha = 1.0
        }, completion: nil)
    }
}
