import TIUIKitCore
import UIKit

final class CollectionCell: BaseCollectionViewCell, ConfigurableView {
    private let titleLabel = UILabel()

    override func addViews() {
        super.addViews()

        contentView.addSubview(titleLabel)
    }

    override func configureLayout() {
        super.configureLayout()

        titleLabel.snp.makeConstraints {
            $0.horizontal.equalToSuperview().inset(CGFloat.mediumInset)
            $0.vertical.equalToSuperview().inset(CGFloat.shortInset)
        }
    }

    override func configureAppearance() {
        super.configureAppearance()

        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        contentView.backgroundColor = .systemBlue
        layer.borderColor = UIColor.systemCyan.cgColor
        layer.borderWidth = 1
    }

    func configure(with text: String) {
        titleLabel.text = text
    }
}
