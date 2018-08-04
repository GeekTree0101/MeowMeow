import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift
import RxCocoa_Texture

class KittenCellNode: ASCellNode {
    
    let titleNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.backgroundColor = .white
        node.isOpaque = true
        node.placeholderColor = .lightGray
        return node
    }()
    
    let contentNode: ASTextNode = {
        let node = ASTextNode()
        node.placeholderColor = .lightGray
        node.isUserInteractionEnabled = true
        node.maximumNumberOfLines = 3
        node.backgroundColor = .white
        node.isOpaque = true
        node.truncationAttributedText =
            NSAttributedString(string: " ...More",
                               attributes: KittenCellNode.moreSeeAttr)
        return node
    }()
    
    let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFill
        node.cornerRadius = 10.0
        node.backgroundColor = .lightGray
        return node
    }()
    
    let disposeBag = DisposeBag()
    private let imageRatio: CGFloat
    
    init(_ viewModel: KittenViewModel) {
        imageRatio = viewModel.ratio
        super.init()
        self.selectionStyle = .none
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        self.isOpaque = true
        self.bindViewModel(viewModel)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        imageNode.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3.0,
                       options: .curveEaseInOut,
                       animations: {
                        self.imageNode.transform = CATransform3DIdentity
        }, completion: nil)
    }
    
    func bindViewModel(_ viewModel: KittenViewModel) {
        viewModel.image
            .bind(to: imageNode.rx.image,
                  setNeedsLayout: self)
            .disposed(by: disposeBag)
        viewModel.title
            .bind(to: titleNode.rx.text(KittenCellNode.titleAttr),
                  setNeedsLayout: self)
            .disposed(by: disposeBag)
        viewModel.content
            .bind(to: contentNode.rx.text(KittenCellNode.contentAttr),
                  setNeedsLayout: self)
            .disposed(by: disposeBag)
        
        contentNode.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                if self.contentNode.maximumNumberOfLines == 0 {
                    self.contentNode.maximumNumberOfLines = 3
                } else {
                    self.contentNode.maximumNumberOfLines = 0
                }
                self.setNeedsLayout()
            }).disposed(by: disposeBag)
        
        imageNode.rx.tap
            .throttle(0.5, scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                self?.transitionLayout(withAnimation: true,
                                       shouldMeasureAsync: true,
                                       measurementCompletion: nil)
            }).disposed(by: disposeBag)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageRatioLayout = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        let elements: [ASLayoutElement] = [imageRatioLayout,
                                           titleNode,
                                           contentNode]
        titleNode.style.spacingBefore = 10.0
        contentNode.style.spacingBefore = 5.0
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 0.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: elements)
        
        let insets = UIEdgeInsets(top: 25.0, left: 15.0, bottom: 20.0, right: 15.0)
        return ASInsetLayoutSpec(insets: insets, child: stackLayout)
    }
}

extension KittenCellNode {
    static var titleAttr: [NSAttributedStringKey: Any] {
        return [.font: UIFont.systemFont(ofSize: 20.0, weight: .bold),
                .foregroundColor: UIColor.title()]
    }
    
    static var contentAttr: [NSAttributedStringKey: Any] {
        return [.font: UIFont.systemFont(ofSize: 15.0),
                .foregroundColor: UIColor.content()]
    }
    
    static var moreSeeAttr: [NSAttributedStringKey: Any] {
        return [.font: UIFont.systemFont(ofSize: 15.0, weight: .medium),
                .foregroundColor: UIColor.moreSee()]
    }
}
