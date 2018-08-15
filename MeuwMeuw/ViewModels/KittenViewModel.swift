import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxCocoa_Texture

class KittenViewModel {
    var image: Observable<UIImage>
    var title: Observable<String>
    var content: Observable<String>
    var isFavorite = BehaviorRelay<Bool>(value: false)
    var didTapFavorite = PublishRelay<Void>()
    
    let ratio: CGFloat
    let id: String
    let disposeBag = DisposeBag()
    
    init(_ kitten: Kitten) {
        self.id = kitten.id
        ASModelSyncronizer.update(kitten)
        
        ratio = kitten.image.size.height / kitten.image.size.width
        
        let observable = ASModelSyncronizer
            .observable(type: Kitten.self, model: kitten)
            .startWith(kitten)
            .share(replay: 1, scope: .whileConnected)
        
        image = observable.map { $0.image }
        title = observable.map { $0.title }
        content = observable.map { $0.content }
        observable.map { $0.isFavorite }
            .bind(to: isFavorite)
            .disposed(by: disposeBag)
        
        didTapFavorite.withLatestFrom(observable)
            .subscribe(onNext: { kitten in
                kitten.isFavorite = !kitten.isFavorite
                ASModelSyncronizer.update(kitten)
            }).disposed(by: disposeBag)
    }
}
