import Foundation
import SnapKit
import TIUIKitCore
import UIKit

private extension UICollectionView {
    static let elementKindSectionBackground: String = "UICollectionViewElementKindSectionBackground"
}

final class DecorationItemsLayoutViewController: BaseInitializeableViewController {
    private enum Section: Int {
        case scrolling
        case list
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cellClass: CollectionCell.self)
        collectionView.collectionViewLayout.register(SimpleBackgroundView.self,
                                                     forDecorationViewOfKind: UICollectionView.elementKindSectionBackground)

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

        title = "Decoration items"
    }

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.scrolling, .list])
        snapshot.appendItems(Array(0 ... 10), toSection: .scrolling)
        snapshot.appendItems(Array(11 ... 30), toSection: .list)

        dataSource.apply(snapshot)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: CollectionCell.self, for: indexPath)
            cell?.configure(with: "\(itemIdentifier)")
            return cell
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)

        return dataSource
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .init { [weak self] sectionIndex, _ in
            let section = Section(rawValue: sectionIndex)

            switch section {
            case .scrolling:
                return self?.createScrollingSection()

            case .list:
                return self?.createListSection()

            case .none:
                return nil
            }
        }
    }

    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)

        section.contentInsets = .init(top: .largeInset, leading: .largeInset, bottom: .largeInset, trailing: .largeInset)

        let background = NSCollectionLayoutDecorationItem.background(elementKind: UICollectionView.elementKindSectionBackground)
        background.contentInsets = .init(top: .defaultInset, leading: .defaultInset, bottom: .defaultInset, trailing: .defaultInset)
        section.decorationItems = [background]

        return section
    }

    private func createScrollingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(.defaultInset)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .largeInset, leading: .largeInset, bottom: .largeInset, trailing: .largeInset)
        section.orthogonalScrollingBehavior = .continuous

        let background = NSCollectionLayoutDecorationItem.background(elementKind: UICollectionView.elementKindSectionBackground)
        background.contentInsets = .init(top: .defaultInset, leading: .defaultInset, bottom: .defaultInset, trailing: .defaultInset)
        section.decorationItems = [background]

        return section
    }
}
