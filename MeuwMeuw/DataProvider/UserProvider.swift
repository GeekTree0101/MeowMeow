import Foundation
import RxCocoa
import RxSwift

struct UserProvider {
    static let observer = PublishRelay<User?>()
    
    static func update(_ user: User?) {
        self.observer.accept(user)
    }
}
