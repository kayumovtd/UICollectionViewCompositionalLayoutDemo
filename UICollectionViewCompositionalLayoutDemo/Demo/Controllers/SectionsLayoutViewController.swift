import Foundation
import SnapKit
import TIUIKitCore
import UIKit

final class SectionsLayoutViewController: BaseInitializeableViewController {
    private enum Section: Int {
        case scrolling
        case paging
        case list

        var title: String {
            ["Nested with scrolling", "Paging", "Just list"][rawValue]
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cellClass: CollectionCell.self)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .sectionHeader)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .sectionFooter)

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

        title = "Sections"
    }

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.scrolling, .paging, .list])
        snapshot.appendItems(Array(0 ... 10), toSection: .scrolling)
        snapshot.appendItems(Array(11 ... 100), toSection: .paging)
        snapshot.appendItems(Array(101 ... 120), toSection: .list)

        dataSource.apply(snapshot)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: CollectionCell.self, for: indexPath)
            cell?.configure(with: "\(itemIdentifier)")
            return cell
        }

        let headersProvider: DataSource.SupplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section],
                  elementKind == UICollectionView.elementKindSectionHeader
            else {
                return nil
            }

            let view = collectionView.dequeue(supplementaryViewClass: SimpleSupplementaryView.self,
                                              ofKind: .sectionHeader,
                                              for: indexPath)
            view?.configure(with: .init(text: section.title))

            return view
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = headersProvider

        return dataSource
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = .mediumInset

        return .init(sectionProvider: { [weak self] sectionIndex, _ in
            let section = Section(rawValue: sectionIndex)

            switch section {
            case .scrolling:
                return self?.createScrollingSection()

            case .paging:
                return self?.createPagingSection()

            case .list:
                return self?.createListSection()

            case .none:
                return nil
            }
        }, configuration: configuration)
    }

    private func createScrollingSection() -> NSCollectionLayoutSection {
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)

        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)

        let smallGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let smallGroup = NSCollectionLayoutGroup.vertical(layoutSize: smallGroupSize, subitem: smallItem, count: 2)

        let resultGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: resultGroupSize, subitems: [largeItem, smallGroup])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)

        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createPagingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]

        return section
    }
}
