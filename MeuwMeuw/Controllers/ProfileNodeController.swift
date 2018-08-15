import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxCocoa_Texture
import Hero

class ProfileNodeController: ASViewController<ASDisplayNode> {
    typealias UserConst = UserInfoNode.ScreenType
    
    struct Const {
        static let contentInsets: UIEdgeInsets =
            .init(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    let userInfoNode = UserInfoNode(.profile)
    let disposeBag = DisposeBag()
    
    let viewModel: UserViewModel
    
    let edgeScreenGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.edges = [.left]
        return gesture
    }()
    
    required init(_ viewModel: UserViewModel) {
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
        viewModel.name
            .bind(to: userInfoNode.nameNode.rx.text(UserConst.profile.usernameAttr),
                  directlyBind: true,
                  setNeedsLayout: self.node)
            .disposed(by: disposeBag)
        
        viewModel.image
            .bind(to: userInfoNode.imageNode.rx.image,
                  directlyBind: true)
            .disposed(by: disposeBag)
        
        viewModel.bio
            .bind(to: userInfoNode.bioNode.rx.text(UserConst.profile.bioAttr),
                  directlyBind: true,
                  setNeedsLayout: self.node)
            .disposed(by: disposeBag)
        
        self.view.addGestureRecognizer(edgeScreenGesture)
        self.view.isUserInteractionEnabled = true
        edgeScreenGesture.addTarget(self, action: #selector(dismissPreview(gestureRecognizer:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.transparente(buttonColor: .paw())
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

extension ProfileNodeController {
    func didLoad() {
        self.userInfoNode.imageNode
            .applyHero(.profile(viewModel.id), modifier: [.scale()])
    }
    
    func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        var insets: UIEdgeInsets = .zero
        insets.top = 100.0
        insets.bottom = .infinity
        return ASInsetLayoutSpec(insets: insets, child: userInfoNode)
    }
}
