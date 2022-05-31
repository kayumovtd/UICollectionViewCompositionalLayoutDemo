import Foundation
import SnapKit
import TIUIKitCore
import UIKit

private extension UICollectionView {
    static let elementKindCustom: String = "CustomKind"
}

final class BoundarySupplementaryItemsLayoutViewController: BaseInitializeableViewController {
    private enum Section: Int {
        case first
        case second

        var header: String {
            ["First header", "Second header"][rawValue]
        }

        var footer: String {
            ["First footer", "Second footer"][rawValue]
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Int>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Int>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cellClass: CollectionCell.self)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .header)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .footer)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .sectionHeader)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .sectionFooter)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .custom(UICollectionView.elementKindCustom))

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

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.first, .second])
        snapshot.appendItems(Array(0 ..< 10), toSection: .first)
        snapshot.appendItems(Array(11 ... 40), toSection: .second)

        dataSource.apply(snapshot)
    }

    override func localize() {
        super.localize()

        title = "Boundary supplementary items"
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: CollectionCell.self, for: indexPath)
            cell?.configure(with: "\(itemIdentifier)")
            return cell
        }

        let supplementaryViewProvider: DataSource.SupplementaryViewProvider = { [weak self] collectionView, elementKind, indexPath in
            let view = collectionView.dequeue(supplementaryViewClass: SimpleSupplementaryView.self,
                                              ofKind: .custom(elementKind),
                                              for: indexPath)

            switch elementKind {
            case UICollectionView.elementKindSectionHeader:
                let text = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section].header ?? "Empty"
                view?.configure(with: .init(text: text, backgroundColor: .systemYellow))

            case UICollectionView.elementKindSectionFooter:
                let text = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section].footer ?? "Empty"
                view?.configure(with: .init(text: text, backgroundColor: .systemBrown))

            case UICollectionView.elementKindCustom:
                view?.configure(with: .init(text: "CUSTOM", backgroundColor: .systemMint))

            case UICollectionView.elementKindHeader:
                view?.configure(with: .init(text: "GLOBAL HEADER", backgroundColor: .systemRed))

            case UICollectionView.elementKindFooter:
                view?.configure(with: .init(text: "GLOBAL FOOTER", backgroundColor: .systemCyan))

            default:
                return nil
            }

            return view
        }

        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource.supplementaryViewProvider = supplementaryViewProvider

        return dataSource
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()

        let supplementaryItemSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(56))

        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementaryItemSize,
                                                                 elementKind: UICollectionView.elementKindHeader,
                                                                 alignment: .top)

        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: supplementaryItemSize,
                                                                 elementKind: UICollectionView.elementKindFooter,
                                                                 alignment: .bottom)

        configuration.boundarySupplementaryItems = [header, footer]

        return .init(section: createSection(), configuration: configuration)
    }

    private func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(56))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true

        let footerSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(56))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)

        let customSize = NSCollectionLayoutSize(widthDimension: .estimated(150), heightDimension: .estimated(56))
        let custom = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: customSize,
                                                                 elementKind: UICollectionView.elementKindCustom,
                                                                 alignment: .topTrailing)

        custom.zIndex = 2

        section.boundarySupplementaryItems = [header, footer, custom]

        return section
    }
}
