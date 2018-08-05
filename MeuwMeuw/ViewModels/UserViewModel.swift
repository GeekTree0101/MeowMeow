import Foundation
import RxSwift
import RxCocoa
import RxOptional

class UserViewModel {
    var image: Observable<UIImage>
    var name: Observable<String>
    var bio: Observable<String>
    
    init(_ user: User) {
        UserProvider.update(user)
        
        let observable = UserProvider.observer
            .filterNil()
            .startWith(user)
            .filter { $0.username == user.username }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        image = observable.map { $0.profileImage}
        name = observable.map { $0.username }
        bio = observable.map { $0.bio }
    }
}
