import Foundation
import AsyncDisplayKit
import RxCocoa
import RxSwift
import RxCocoa_Texture
import RxOptional
import Hero

class KittenCellNode: ASCellNode {
    
    let titleNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.backgroundColor = .white
        node.isOpaque = true
        node.placeholderColor = .lightGray
        node.style.flexGrow = 1.0
        node.style.flexShrink = 1.0
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
        node.style.flexGrow = 1.0
        node.style.flexShrink = 1.0
        return node
    }()
    
    let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFill
        node.cornerRadius = 10.0
        node.backgroundColor = .lightGray
        node.style.flexGrow = 0.0
        node.style.flexShrink = 1.0
        return node
    }()
    
    let favoriteNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "star"), for: .selected)
        node.setImage(#imageLiteral(resourceName: "star").applyNewColor(with: .white), for: .normal)
        node.imageNode.style.preferredSize = .init(width: 30.0, height: 30.0)
        node.style.preferredSize = .init(width: 60.0, height: 60.0)
        node.imageNode.contentMode = .scaleAspectFit
        node.cornerRadius = 10.0
        return node
    }()
    
    let disposeBag = DisposeBag()
    private let imageRatio: CGFloat
    private let id: String
    init(_ viewModel: KittenViewModel) {
        imageRatio = viewModel.ratio
        self.id = viewModel.id
        super.init()
        self.selectionStyle = .none
        self.automaticallyManagesSubnodes = true
        self.backgroundColor = .white
        self.isOpaque = true
        self.bindViewModel(viewModel)
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
        
        viewModel.isFavorite
            .distinctUntilChanged({ [weak self] prev, present -> Bool in
                if !prev, present {
                    self?.favoriteNode.transform = CATransform3DMakeScale(1.5, 1.5, 1.0)
                    UIView.animate(withDuration: 0.5,
                                   delay: 0.0,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 4.0,
                                   options: .curveEaseIn,
                                   animations: {
                        self?.favoriteNode.transform = CATransform3DIdentity
                    }, completion: nil)
                }
                return false
            })
            .bind(to: favoriteNode.rx.isSelected)
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
        
        favoriteNode.rx.tap
            .throttle(0.5, scheduler: MainScheduler.asyncInstance)
            .bind(to: viewModel.didTapFavorite)
            .disposed(by: disposeBag)
    }
    
    override func didLoad() {
        super.didLoad()
        self.imageNode.applyHero(.catImage(id), modifier: nil)
        self.titleNode.applyHero(.title(id), modifier: nil)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let imageRatioLayout = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        let favoriteLayout = ASRelativeLayoutSpec(horizontalPosition: .end,
                                                  verticalPosition: .start,
                                                  sizingOption: [],
                                                  child: favoriteNode)
        let favriteOverlayedImageLayout =
            ASOverlayLayoutSpec(child: imageRatioLayout,
                                overlay: favoriteLayout)
        
        var elements: [ASLayoutElement] = [favriteOverlayedImageLayout]
        
        if titleNode.attributedText?.string.count ?? 0 > 0 {
            elements.append(titleNode)
        }
        
        if contentNode.attributedText?.string.count ?? 0 > 0 {
            elements.append(contentNode)
        }
        
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
