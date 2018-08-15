import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxCocoa_Texture

class KittenViewModel {
    var image = BehaviorRelay<UIImage?>(value: nil)
    var title = BehaviorRelay<String?>(value: nil)
    var content = BehaviorRelay<String?>(value: nil)
    var isFavorite = BehaviorRelay<Bool>(value: false)
    var didTapFavorite = PublishRelay<Void>()
    
    let ratio: CGFloat
    let id: String
    let disposeBag = DisposeBag()
    
    init(_ kitten: Kitten) {
        self.id = kitten.id
        KittenProvider.update(kitten)
        
        ratio = kitten.image.size.height / kitten.image.size.width
        
        let observable = KittenProvider.observer
            .startWith(kitten)
            .filter { $0?.id == kitten.id }
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        observable.map { $0?.image }
            .bind(to: image)
            .disposed(by: disposeBag)
        
        observable.map { $0?.title }
            .bind(to: title)
            .disposed(by: disposeBag)
        
        observable.map { $0?.content }
            .bind(to: content)
            .disposed(by: disposeBag)
        
        observable.map { $0?.isFavorite ?? false }
            .bind(to: isFavorite)
            .disposed(by: disposeBag)
        
        didTapFavorite.withLatestFrom(observable)
            .subscribe(onNext: { kitten in
                kitten?.isFavorite = !(kitten?.isFavorite ?? false)
                KittenProvider.update(kitten)
            }).disposed(by: disposeBag)
    }
}
