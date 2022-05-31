import TIUIKitCore
import UIKit

final class SimpleSupplementaryView: BaseCollectionReusableView, ConfigurableView {
    private let titleLabel = UILabel()

    override func addViews() {
        super.addViews()

        addSubview(titleLabel)
    }

    override func configureLayout() {
        super.configureLayout()

        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(CGFloat.smallInset)
        }
    }

    override func configureAppearance() {
        super.configureAppearance()

        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)

        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
    }

    func configure(with viewModel: SimpleSupplementaryViewModel) {
        titleLabel.text = viewModel.text
        backgroundColor = viewModel.backgroundColor
    }
}
