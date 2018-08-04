import Foundation
import AsyncDisplayKit

class KittenShowNodeController: ASViewController<ASDisplayNode> {
    
    required init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
