import Foundation
import RxSwift
import RxCocoa

struct KittenProvider {
    static let observer = PublishRelay<Kitten?>()
    
    static func update(_ kitten: Kitten?) {
        self.observer.accept(kitten)
    }
}
