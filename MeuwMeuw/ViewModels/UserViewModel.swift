import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxCocoa_Texture

class UserViewModel {
    var image: Observable<UIImage>
    var name: Observable<String>
    var bio: Observable<String>
    
    let id: String
    
    init(_ user: User) {
        id = user.username
        ASModelSyncronizer.update(user)
        
        let observable = ASModelSyncronizer
            .observable(type: User.self, model: user)
            .startWith(user)
            .share(replay: 1, scope: .whileConnected)
        
        image = observable.map { $0.profileImage}
        name = observable.map { $0.username }
        bio = observable.map { $0.bio }
    }
}
