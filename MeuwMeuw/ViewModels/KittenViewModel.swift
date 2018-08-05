import Foundation
import RxSwift
import RxCocoa
import RxOptional

class KittenViewModel {
    var image: Observable<UIImage>
    var title: Observable<String>
    var content: Observable<String>
    var isFavorite: Observable<Bool>
    var didTapFavorite = PublishRelay<Void>()
    
    let ratio: CGFloat
    
    let disposeBag = DisposeBag()
    
    init(_ kitten: Kitten) {
        KittenProvider.update(kitten)
        
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
        isFavorite = observable.map { $0.isFavorite }
        
        didTapFavorite.withLatestFrom(observable)
            .subscribe(onNext: { kitten in
                kitten.isFavorite = !kitten.isFavorite
                KittenProvider.update(kitten)
            }).disposed(by: disposeBag)
    }
}
