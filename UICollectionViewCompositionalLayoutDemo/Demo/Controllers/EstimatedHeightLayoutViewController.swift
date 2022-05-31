import Foundation
import SnapKit
import TIUIKitCore
import UIKit

final class EstimatedHeightLayoutViewController: BaseInitializeableViewController {
    private enum Section {
        case main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cellClass: CollectionCell.self)

        applySnapshot()
    }

    override func addViews() {
        super.addViews()

        view.addSubview(collectionView)
    }

    override func configureLayout() {
        super.configureLayout()

        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func localize() {
        super.localize()

        title = "Estimated height"
    }

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0 ... 100), toSection: .main)

        dataSource.apply(snapshot)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: CollectionCell.self, for: indexPath)
            let string = Array(repeating: "\(itemIdentifier) ", count: (itemIdentifier + 1) * 20).joined()
            cell?.configure(with: string)
            return cell
        }

        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))

        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        return .init(section: section)
    }
}
