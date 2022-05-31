import TIUIKitCore
import UIKit

final class TableCell: BaseCollectionViewCell, ConfigurableView {
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

    func configure(with text: String) {
        titleLabel.text = text
    }
}
