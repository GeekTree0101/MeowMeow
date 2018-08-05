import Foundation
import UIKit

class User {
    var profileImage: UIImage
    var username: String
    var bio: String
    
    init(_ name: String, image: UIImage, bio: String) {
        self.username = name
        self.profileImage = image
        self.bio = bio
    }
}
