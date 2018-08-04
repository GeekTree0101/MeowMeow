import Foundation
import UIKit

struct Kitten {
    let id: String
    var image: UIImage
    var title: String
    var content: String
    var user: User?
    
    init(_ id: String,
         image: UIImage,
         title: String,
         content: String,
         user: User?) {
        self.id = id
        self.image = image
        self.title = title
        self.content = content
        self.user = user
    }
}
