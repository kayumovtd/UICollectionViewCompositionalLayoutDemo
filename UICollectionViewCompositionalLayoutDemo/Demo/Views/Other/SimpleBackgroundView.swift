import UIKit

final class SimpleBackgroundView: BaseCollectionReusableView {
    override func configureAppearance() {
        super.configureAppearance()

        backgroundColor = .systemRed

        layer.borderColor = UIColor.systemMint.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 16
    }
}
