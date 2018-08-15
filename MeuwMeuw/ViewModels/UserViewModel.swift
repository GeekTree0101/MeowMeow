import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxCocoa_Texture

class UserViewModel {
    var image = BehaviorRelay<UIImage?>(value: nil)
    var name = BehaviorRelay<String?>(value: nil)
    var bio = BehaviorRelay<String?>(value: nil)
    
    let id: String
    let disposeBag = DisposeBag()
    
    init(_ user: User) {
        id = user.username
        UserProvider.update(user)
        let observable = UserProvider.observer
            .startWith(user)
            .filter { $0?.username == user.username }
            .share(replay: 1, scope: .whileConnected)
        
        observable.map { $0?.profileImage }
            .bind(to: image)
            .disposed(by: disposeBag)
        observable.map { $0?.username }
            .bind(to: name)
            .disposed(by: disposeBag)
        observable.map { $0?.bio }
            .bind(to: bio)
            .disposed(by: disposeBag)
    }
}
