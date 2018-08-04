import Foundation
import AsyncDisplayKit

class HomeFeedNodeController: ASViewController<ASDisplayNode> {
    
    var viewModels: [KittenViewModel] = []
    lazy var pawNode = PawNode()
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode.init(style: .plain)
        node.dataSource = self
        node.delegate = self
        node.backgroundColor = .white
        node.isOpaque = true
        return node
    }()
    
    enum Section: Int {
        case welcome
        case feed
        
        static var numberOfSection: Int {
            return 2
        }
    }
    
    required init() {
        super.init(node: ASDisplayNode())
        self.node.backgroundColor = .white
        self.node.isOpaque = true
        self.node.automaticallyManagesSubnodes = true
        
        self.node.layoutSpecBlock = { [weak self] (_, sizeRange) -> ASLayoutSpec in
            return self?.layoutSpecThatFits(sizeRange) ?? ASLayoutSpec()
        }
        self.node.onDidLoad({ [weak self] _ in
            self?.didLoad()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutSpecThatFits(_ constraintedSize: ASSizeRange) -> ASLayoutSpec {
        let tableInsetLayout = ASInsetLayoutSpec(insets: .zero, child: self.tableNode)
        let pawInsets: UIEdgeInsets = .init(top: .infinity,
                                            left: .infinity,
                                            bottom: 20.0,
                                            right: 20.0)
        let pawInsetLayout = ASInsetLayoutSpec(insets: pawInsets,
                                               child: pawNode)
        return ASOverlayLayoutSpec(child: tableInsetLayout,
                                   overlay: pawInsetLayout)
    }
    
    func didLoad() {
        tableNode.view.separatorStyle = .none
        tableNode.view.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModels = KittenMock.generate().map { KittenViewModel.init($0) }
    }
}

extension HomeFeedNodeController: ASTableDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pawNode.hide()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pawNode.show()
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HomeFeedNodeController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return Section.numberOfSection
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        guard let `section` = Section.init(rawValue: section) else { return 0 }
        switch section {
        case .welcome:
            return 1
        case .feed:
            return viewModels.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard let `section` = Section(rawValue: indexPath.section) else { return ASCellNode() }
            
            switch section {
            case .welcome:
                return KittenWelcomeCellNode()
            case .feed:
                guard indexPath.row < self.viewModels.count else { return ASCellNode() }
                let viewModel = self.viewModels[indexPath.row]
                return KittenCellNode(viewModel)
            }
        }
    }
}
