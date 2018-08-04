import Foundation
import RxSwift
import RxCocoa

class KittenWelcomCellViewModel {
    var userList = BehaviorRelay<[UserViewModel]>(value: [])
    var titleRelay = BehaviorRelay<String>(value: "환영합니다!\n코코집사님")
    
    func loadUserList() {
        let users = KittenMock.users()
        self.userList.accept(users.map { UserViewModel($0) })
    }
}
