import UIKit.UIColor

struct SimpleSupplementaryViewModel {
    let text: String
    let backgroundColor: UIColor

    init(text: String, backgroundColor: UIColor = .clear) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
}
