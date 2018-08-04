import Foundation
import RxSwift
import RxCocoa
import RxOptional

class KittenViewModel {
    var image: Observable<UIImage>
    var title: Observable<String>
    var content: Observable<String>
    let ratio: CGFloat
    
    init(_ kitten: Kitten) {
        ratio = kitten.image.size.height / kitten.image.size.width
        let observable = KittenProvider.observer
            .filterNil()
            .startWith(kitten)
            .filter { $0.id == kitten.id }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        image = observable.map { $0.image }
        title = observable.map { $0.title }
        content = observable.map { $0.content }
        
        KittenProvider.update(kitten)
    }
}
