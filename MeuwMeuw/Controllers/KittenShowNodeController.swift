import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture
import Hero

class KittenShowNodeController: ASViewController<ASDisplayNode> {
    
    struct Const {
        static let contentInsets: UIEdgeInsets =
            .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
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
        node.backgroundColor = .white
        node.isOpaque = true
        node.style.flexGrow = 1.0
        node.style.flexShrink = 1.0
        return node
    }()
    
    let imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = .scaleAspectFill
        node.backgroundColor = .lightGray
        node.style.flexGrow = 0.0
        node.style.flexShrink = 1.0
        return node
    }()
    
    let favoriteNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setImage(#imageLiteral(resourceName: "star"), for: .selected)
        node.setImage(#imageLiteral(resourceName: "star").applyNewColor(with: .lightGray), for: .normal)
        node.imageNode.style.preferredSize = .init(width: 30.0, height: 30.0)
        node.style.preferredSize = .init(width: 60.0, height: 60.0)
        node.imageNode.contentMode = .scaleAspectFit
        node.cornerRadius = 10.0
        return node
    }()
    
    let disposeBag = DisposeBag()
    
    let viewModel: KittenViewModel
    
    let edgeScreenGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.edges = [.left]
        return gesture
    }()

    required init(_ viewModel: KittenViewModel) {
        self.viewModel = viewModel
        super.init(node: ASDisplayNode())
        self.hero.isEnabled = true
        self.node.automaticallyManagesSubnodes = true
        self.node.backgroundColor = .white
        self.node.layoutSpecBlock = { [weak self] (_, sizeRagne) -> ASLayoutSpec in
            return self?.layoutSpecThatFits(sizeRagne) ?? ASLayoutSpec()
        }
        self.node.onDidLoad({ [weak self] _ in
            self?.didLoad()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.image
            .bind(to: imageNode.rx.image,
                  setNeedsLayout: self.node)
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: titleNode.rx.text(KittenCellNode.titleAttr),
                  setNeedsLayout: self.node)
            .disposed(by: disposeBag)
        
        viewModel.content
            .bind(to: contentNode.rx.text(KittenCellNode.contentAttr),
                  setNeedsLayout: self.node)
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
        
        favoriteNode.rx.tap
            .throttle(0.5, scheduler: MainScheduler.asyncInstance)
            .bind(to: viewModel.didTapFavorite)
            .disposed(by: disposeBag)
        
        self.view.addGestureRecognizer(edgeScreenGesture)
        self.view.isUserInteractionEnabled = true
        edgeScreenGesture.addTarget(self, action: #selector(dismissPreview(gestureRecognizer:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.transparente()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillDisappear(animated)
    }
    
    @objc func dismissPreview(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            self.navigationController?.popViewController(animated: true)
        case .changed:
            let translation = gestureRecognizer.translation(in: nil)
            let progress = translation.x / view.bounds.width
            Hero.shared.update(progress)
        default:
            Hero.shared.finish()
        }
    }
}

extension KittenShowNodeController {
    func didLoad() {
        self.imageNode.applyHero(.catImage(viewModel.id), modifier: nil)
        self.titleNode.applyHero(.title(viewModel.id), modifier: nil)
    }
    
    func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        let imageRatioLayout = ASRatioLayoutSpec(ratio: 0.5, child: imageNode)
        let titleInsetLayout = ASInsetLayoutSpec(insets: Const.contentInsets, child: titleNode)
        let contentInsetLayout = ASInsetLayoutSpec(insets: Const.contentInsets, child: contentNode)
        let favoriteCenterLayout = ASCenterLayoutSpec(centeringOptions: .XY,
                                                      sizingOptions: [],
                                                      child: favoriteNode)
        
        imageRatioLayout.style.spacingAfter = 20.0
        titleInsetLayout.style.spacingAfter = 15.0
        contentInsetLayout.style.spacingAfter = 60.0
        
        let elements: [ASLayoutElement] = [imageRatioLayout,
                                           titleInsetLayout,
                                           contentInsetLayout,
                                           favoriteCenterLayout]
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 0.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: elements)
        var insets: UIEdgeInsets = .zero
        insets.bottom = .infinity
        return ASInsetLayoutSpec(insets: insets, child: stackLayout)
    }
}
