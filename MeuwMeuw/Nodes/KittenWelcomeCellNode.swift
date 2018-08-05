import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift
import RxCocoa_Texture

class KittenWelcomeCellNode: ASCellNode {
    typealias Node = KittenWelcomeCellNode
    
    let titleNode = ASTextNode()
    
    lazy var scrollNode: ASScrollNode = {
        let node = ASScrollNode()
        node.automaticallyManagesContentSize = true
        node.automaticallyManagesSubnodes = true
        node.scrollableDirections = [.left, .right]
        node.layoutSpecBlock = { [weak self] (_ , _) -> ASLayoutSpec in
            return self?.scrollAreaLayoutSpec() ?? ASLayoutSpec()
        }
        return node
    }()
    
    lazy var viewModel = KittenWelcomCellViewModel()
    let disposeBag = DisposeBag()
    var userNodes: [UserInfoNode] = []
    
    enum Status {
        case welcome
        case showUserList
    }
    
    var status: Status = .welcome
    
    override init() {
        super.init()
        self.automaticallyManagesSubnodes = true
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.isOpaque = true
        self.bindViewModel()
    }
    
    func bindViewModel() {
        viewModel.titleRelay
            .bind(to: titleNode.rx.text(Node.titleAttr),
                  setNeedsLayout: self)
            .disposed(by: disposeBag)
        
        viewModel.userList.filterEmpty()
            .subscribe(onNext: { [weak self] users in
                self?.userNodes = users
                    .map { userViewModel -> UserInfoNode in
                        let node = UserInfoNode(.compact)
                        userViewModel.image
                            .bind(to: node.imageNode.rx.image,
                                  setNeedsLayout: self?.scrollNode)
                            .disposed(by: node.disposeBag)
                        userViewModel.name
                            .bind(to: node.nameNode.rx.text(node.type.usernameAttr),
                                  setNeedsLayout: self?.scrollNode)
                            .disposed(by: node.disposeBag)
                        return node
                }
                self?.viewModel.titleRelay.accept("최근에 소통하신\n집사님들입니다.")
                self?.status = .showUserList
                self?.transitionLayout(withAnimation: true,
                                       shouldMeasureAsync: true,
                                       measurementCompletion: nil)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(PawNode.didTapPawName)
            .subscribe(onNext: { [weak self] _ in
                guard self?.isVisible ?? false else { return }
                self?.viewModel.loadUserList()
            }).disposed(by: disposeBag)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var insets: UIEdgeInsets = .init(top: 25.0, left: 15.0, bottom: 80.0, right: 0.0)
        
        switch status {
        case .welcome:
            return ASInsetLayoutSpec(insets: insets, child: titleNode)
        case .showUserList:
            insets.bottom = 0.0
        }
        
        let titleInsetLayout =
            ASInsetLayoutSpec(insets: insets, child: titleNode)
        let scrollNodeInsetLayout =
            ASInsetLayoutSpec(insets: .init(top: 0.0,
                                            left: 0.0,
                                            bottom: 30.0,
                                            right: 0.0),
                              child: scrollNode)
        
        return ASStackLayoutSpec(direction: .vertical,
                                            spacing: 25.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [titleInsetLayout,
                                                       scrollNodeInsetLayout])
    }
    
    func scrollAreaLayoutSpec() -> ASLayoutSpec {
        self.userNodes.first?.style.spacingBefore = 15.0
        self.userNodes.last?.style.spacingAfter = 15.0
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 15.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: self.userNodes)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        UIView.animate(withDuration: 0.2, animations: {
            self.titleNode.alpha = 0.5
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.titleNode.alpha = 1.0
            }, completion: { _ in
                self.titleNode.alpha = 1.0
            })
        })
    }
    
    override func didLoad() {
        super.didLoad()
        self.scrollNode.view.showsVerticalScrollIndicator = false
        self.scrollNode.view.showsHorizontalScrollIndicator = false
    }
}

extension KittenWelcomeCellNode {
    static var titleAttr: [NSAttributedStringKey: Any] {
        return [.font: UIFont.systemFont(ofSize: 40.0, weight: .medium),
                .foregroundColor: UIColor.title()]
    }
}
