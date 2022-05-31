import TIUIKitCore
import UIKit

class BaseCollectionReusableView: UICollectionReusableView, InitializableViewProtocol {
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        initializeView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initializeView()
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        self.layer.zPosition = CGFloat(layoutAttributes.zIndex)
    }

    // MARK: - InitializableView

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
