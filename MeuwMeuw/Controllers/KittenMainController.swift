import Foundation
import AsyncDisplayKit
import RxOptional

class KittenMainController: UITabBarController {
    
    enum TabBarType: Int {
        case home
        case profile
        case favorite
        
        private var title: String {
            switch self {
            case .home:
                return "홈"
            case .favorite:
                return "즐겨찾기"
            case .profile:
                return "프로필"
            }
        }
        
        private func image(_ isSelected: Bool) -> UIImage? {
            let targetImage: UIImage
            switch self {
            case .home:
                targetImage = #imageLiteral(resourceName: "home")
            case .favorite:
                targetImage = #imageLiteral(resourceName: "star")
            case .profile:
                targetImage = #imageLiteral(resourceName: "profile")
            }
            
            return targetImage.resizeImage(newWidth: 30.0)?
                .applyNewColor(with: isSelected ? .paw(): .gray)
                .withRenderingMode(.alwaysOriginal)
        }
        
        private func attribute(_ isSelected: Bool) -> [NSAttributedStringKey: Any] {
            return [.font: UIFont.systemFont(ofSize: 12.0, weight: .light),
                    .foregroundColor: isSelected ? UIColor.paw(): UIColor.gray]
        }
        
        func setup(_ item: UITabBarItem) {
            item.image = self.image(false)
            item.selectedImage = self.image(true)
            item.title = self.title
            item.setTitleTextAttributes(self.attribute(false), for: .normal)
            item.setTitleTextAttributes(self.attribute(true), for: .selected)
        }
    }
    
    struct Const {
        static let tabBarHeight: CGFloat = 80.0
    }
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let homeVC = HomeFeedNodeController.init()
        let profileViewModel = UserViewModel.init(KittenMock.me())
        let profileVC = ProfileNodeController.init(profileViewModel)
        let favoriteVC = FavoriteFeedNodeController.init()
        
        self.setViewControllers([homeVC, profileVC, favoriteVC], animated: false)
        self.tabBar.items?.enumerated().forEach({ index, item in
            TabBarType(rawValue: index)?.setup(item)
        })
        self.tabBar.setAppearence()
    }
}

extension KittenMainController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        switch viewController {
        case let viewController as FavoriteFeedNodeController:
            guard let homeVC = self.viewControllers?.first as? HomeFeedNodeController else { return false }
            viewController.applyViewModels(homeVC.viewModels.filter { $0.isFavorite.value })
        default:
            return true
        }
        return true
    }
}
