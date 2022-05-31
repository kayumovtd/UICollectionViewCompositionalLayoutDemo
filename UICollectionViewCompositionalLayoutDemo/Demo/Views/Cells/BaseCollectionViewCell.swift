import TIUIKitCore
import UIKit

class BaseCollectionViewCell: UICollectionViewCell, InitializableViewProtocol {
    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        // override
    }

    func configureLayout() {
        // override
    }

    func bindViews() {
        // override
    }

    func configureAppearance() {
        // override
    }

    func localize() {
        // override
    }
}
