import Foundation
import SnapKit
import TIUIKitCore
import UIKit

final class GridLayoutViewController: BaseInitializeableViewController {
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

        title = "Grid"
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
            cell?.configure(with: "\(itemIdentifier)")
            return cell
        }

        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init { _, layoutEnvironment in
            let columns = layoutEnvironment.traitCollection.verticalSizeClass == .regular ? 2 : 4

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)

            let section = NSCollectionLayoutSection(group: group)

            return section
        }
    }
}
