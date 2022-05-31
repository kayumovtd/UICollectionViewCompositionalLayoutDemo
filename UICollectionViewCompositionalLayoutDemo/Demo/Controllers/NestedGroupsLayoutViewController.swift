import Foundation
import SnapKit
import TIUIKitCore
import UIKit

final class NestedGroupsLayoutViewController: BaseInitializeableViewController {
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

        title = "Nested groups"
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
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)

        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)

        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let smallGroup = NSCollectionLayoutGroup.vertical(layoutSize: smallGroupSize, subitem: smallItem, count: 2)

        let topGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.7))
        let topGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topGroupSize, subitems: [largeItem, smallGroup])

        let bottomItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let bottomItem = NSCollectionLayoutItem(layoutSize: bottomItemSize)

        let bottomGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: bottomGroupSize, subitem: bottomItem, count: 5)

        let resultGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let resultGroup = NSCollectionLayoutGroup.vertical(layoutSize: resultGroupSize, subitems: [topGroup, bottomGroup])

        let section = NSCollectionLayoutSection(group: resultGroup)

        return .init(section: section)
    }
}
