import Foundation
import UIKit

struct KittenMock {
    static func me() -> User {
        return User.init("Geektree0101",
                         image: #imageLiteral(resourceName: "Geektree0101"),
                         bio: "코코 집사입니다.\niOS Developer")
    }
    
    static func users() -> [User] {
        let images: [UIImage] = [#imageLiteral(resourceName: "eunha"), #imageLiteral(resourceName: "yuju"), #imageLiteral(resourceName: "sowon"), #imageLiteral(resourceName: "shinB"), #imageLiteral(resourceName: "EJ"), #imageLiteral(resourceName: "yerin"), #imageLiteral(resourceName: "IU"), #imageLiteral(resourceName: "sana")]
        let username: [String] = ["은하집사님",
                                  "유주집사님",
                                  "소원집사님",
                                  "신비집사님",
                                  "엄지집사님",
                                  "예린집사님",
                                  "IU집사님",
                                  "사나집사님"]
        let bio: [String] = ["고양이가 너무 좋아~",
                             "냥냥? 냥냥??!",
                             "고양이 사진만 좋아합니다.",
                             "고양이야 나야?",
                             "야옹~",
                             "흐헤헤헿",
                             "나는요~ 고양이가~ 좋은걸!",
                             "전 고양이보다 이누가 더 좋아요 ㅠㅠ"]
        return (0 ..< images.count).map { index -> User in
            return User(username[index],
                        image: images[index],
                        bio: bio[index])
        }
    }
    
    static func images() -> [UIImage] {
        return [#imageLiteral(resourceName: "coco1"), #imageLiteral(resourceName: "coco2"), #imageLiteral(resourceName: "coco3"), #imageLiteral(resourceName: "coco4"), #imageLiteral(resourceName: "coco5"), #imageLiteral(resourceName: "coco6"), #imageLiteral(resourceName: "coco7"), #imageLiteral(resourceName: "coco8")]
    }
    
    static func generate() -> [Kitten] {
        let images: [UIImage] = [#imageLiteral(resourceName: "coco1"), #imageLiteral(resourceName: "coco2"), #imageLiteral(resourceName: "coco3"), #imageLiteral(resourceName: "coco4"), #imageLiteral(resourceName: "coco5"), #imageLiteral(resourceName: "coco6"), #imageLiteral(resourceName: "coco7"), #imageLiteral(resourceName: "coco8")]
        let titles: [String] = ["Cute coco",
                                "Coco too so cute",
                                "Lovely Coco",
                                "Naughty cat coco",
                                "Kitten coco",
                                "Cat with three colors, coco",
                                "I like cats so much.",
                                "Meow Meow Meow Meow"]
        let contents: [String] = ["The domestic cat (Felis silvestris catus or Felis catus)[1][5] is a small, typically furry, carnivorous mammal. They are often called house cats[6] when kept as indoor pets or simply cats when there is no need to distinguish them from other felids and felines. They are often valued by humans for companionship and for their ability to hunt vermin. There are more than seventy cat breeds recognized by various cat registries.", "Cats are similar in anatomy to the other felids, with a strong flexible body, quick reflexes, sharp retractable claws and teeth adapted to killing small prey. Cat senses fit a crepuscular and predatory ecological niche. Cats can hear sounds too faint or too high in frequency for human ears, such as those made by mice and other small animals. They can see in near darkness. Like most other mammals, cats have poorer color vision and a better sense of smell than humans. Cats, despite being solitary hunters, are a social species, and cat communication includes the use of a variety of vocalizations (mewing, purring, trilling, hissing, growling and grunting) as well as cat pheromones and types of cat-specific body language.[7]", "Cats have a high breeding rate.[8] Under controlled breeding, they can be bred and shown as registered pedigree pets, a hobby known as cat fancy. Failure to control the breeding of pet cats by spaying and neutering, as well as the abandonment of former household pets, has resulted in large numbers of feral cats worldwide, requiring population control.[9] In certain areas outside cats' native range, this has contributed, along with habitat destruction and other factors, to the extinction of many bird species. Cats have been known to extirpate a bird species within specific regions and may have contributed to the extinction of isolated island populations.[10] Cats are thought to be primarily responsible for the extinction of 87 species of birds,[11] and the presence of feral and free-ranging cats makes some otherwise suitable locations unsuitable for attempted species reintroduction.[12]", "Because cats were venerated in ancient Egypt, they were commonly believed to have been domesticated there,[13] but there may have been instances of domestication as early as the Neolithic from around 9,500 years ago (7500 BC).[14] A genetic study in 2007[15] concluded that all domestic cats are descended from Near Eastern wildcats, having diverged around 8000 BC in the Middle East.[13][16] A 2016 study found that leopard cats were undergoing domestication independently in China around 5500 BC, though this line of partially domesticated cats leaves no trace in the domesticated populations of today.[17][18] A 2017 study confirmed that domestic cats are descendants of those first domesticated by farmers in the Near East around 9,000 years ago.[19][20]", "The domestic cat is a member of the cat family, the felids, which are a rapidly evolving family of mammals that share a common ancestor only 10–15 million years ago[23] and include lions, tigers, cougars and many others. Within this family, domestic cats (Felis catus) are part of the genus Felis, which is a group of small cats containing about seven species (depending upon classification scheme).[1][24] Members of the genus are found worldwide and include the jungle cat (Felis chaus) of southeast Asia, European wildcat (F. silvestris silvestris), African wildcat (F. s. lybica), the Chinese mountain cat (F. bieti), and the Arabian sand cat (F. margarita), among others.[25]", "The domestic cat is believed to have evolved from the Near Eastern wildcat, whose range covers vast portions of the Middle East westward to the Atlantic coast of Africa.[26][27] Between 70,000 and 100,000 years ago the animal gave rise to the genetic lineage that eventually produced all domesticated cats,[28] having diverged from the Near Eastern wildcat around 8,000 BC in the Middle East.[13][16]", "The domestic cat was first classified as Felis catus by Carl Linnaeus in the 10th edition of his Systema Naturae published in 1758.[1][2] Because of modern phylogenetics, domestic cats are usually regarded as another subspecies of the wildcat, F. silvestris.[1][29][30] This has resulted in mixed usage of the terms, as the domestic cat can be called by its subspecies name, Felis silvestris catus.[1][29][30] Wildcats have also been referred to as various subspecies of F. catus,[30] but in 2003, the International Commission on Zoological Nomenclature fixed the name for wildcats as F. silvestris.[31] The most common name in use for the domestic cat remains F. catus. Sometimes, the domestic cat has been called Felis domesticus[32] as proposed by German naturalist J. C. P. Erxleben in 1777,[33] but these are not valid taxonomic names and have been used only rarely in scientific literature.[34] A population of Transcaucasian black feral cats was once classified as Felis daemon (Satunin 1904) but now this population is considered to be a part of the domestic cat.[35]", "All the cats in this genus share a common ancestor that is believed to have lived around 6–7 million years ago in the Near East (the Middle East).[36] The exact relationships within the Felidae are close but still uncertain,[37][38] e.g. the Chinese mountain cat is sometimes classified (under the name Felis silvestris bieti) as a subspecies of the wildcat, like the North African variety F. s. lybica.[29][37]"]
        
        let userList = self.users()
        
        return (0 ..< images.count).map { index -> Kitten in
            let identifier = "kitten-\(index)"
            return Kitten(identifier,
                          image: images[index],
                          title: titles[index],
                          content: contents[index],
                          user: userList[index])
        }
    }
}
