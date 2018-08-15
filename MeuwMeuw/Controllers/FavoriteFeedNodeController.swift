import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class FavoriteFeedNodeController: ASViewController<ASDisplayNode> {
    var viewModels: [KittenViewModel] = []
    
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
        self.hero.isEnabled = true
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
        return ASInsetLayoutSpec(insets: .zero, child: self.tableNode)
    }
    
    func didLoad() {
        tableNode.view.separatorStyle = .none
        tableNode.view.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewWillAppear(animated)
    }
    
    func applyViewModels(_ list: [KittenViewModel]) {
        self.viewModels = list
        self.tableNode.reloadData()
    }
}

extension FavoriteFeedNodeController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section.init(rawValue: indexPath.section) else { return }
        switch section {
        case .feed:
            guard indexPath.row < self.viewModels.count else { return }
            let viewModel = self.viewModels[indexPath.row]
            self.openCatShow(viewModel)
        case .welcome:
            break
        }
    }
    
    func openCatShow(_ kittenViewModel: KittenViewModel) {
        let viewController = KittenShowNodeController(kittenViewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension FavoriteFeedNodeController: ASTableDataSource {
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
                return KittenWelcomeCellNode(screenType: .favoriteList)
            case .feed:
                guard indexPath.row < self.viewModels.count else { return ASCellNode() }
                let viewModel = self.viewModels[indexPath.row]
                return KittenCellNode(viewModel)
            }
        }
    }
}
