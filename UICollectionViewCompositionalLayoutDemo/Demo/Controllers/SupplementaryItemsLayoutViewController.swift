import Foundation
import SnapKit
import TIUIKitCore
import UIKit

private extension UICollectionView {
    static let elementKindGroupBadge: String = "UICollectionViewElementKindGroupBadge"
}

final class SupplementaryItemsLayoutViewController: BaseInitializeableViewController {
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
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .itemBadge)
        collectionView.register(supplementaryViewClass: SimpleSupplementaryView.self, ofKind: .custom(UICollectionView.elementKindGroupBadge))

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

        title = "Supplementary items"
    }

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0 ..< 100), toSection: .main)

        dataSource.apply(snapshot)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: CollectionCell.self, for: indexPath)
            cell?.configure(with: "\(itemIdentifier)")
            return cell
        }

        let supplementaryViewProvider: DataSource.SupplementaryViewProvider = { collectionView, elementKind, indexPath in
            let view = collectionView.dequeue(supplementaryViewClass: SimpleSupplementaryView.self,
                                              ofKind: .custom(elementKind),
                                              for: indexPath)

            switch elementKind {
            case UICollectionView.elementKindItemBadge:
                view?.configure(with: .init(text: "X", backgroundColor: .systemPink))

            case UICollectionView.elementKindGroupBadge:
                view?.configure(with: .init(text: "GROUP BADGE", backgroundColor: .systemMint))

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
        let badgeSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(30))

        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: UICollectionView.elementKindItemBadge,
                                                        containerAnchor: .init(edges: [.top, .trailing],
                                                                               fractionalOffset: .init(x: 0.5, y: -0.5)))

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = .init(top: .smallInset, leading: .smallInset, bottom: .smallInset, trailing: .smallInset)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let groupBadge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                             elementKind: UICollectionView.elementKindGroupBadge,
                                                             containerAnchor: .init(edges: [.bottom],
                                                                                    fractionalOffset: .init(x: .zero, y: -0.4)))
        group.supplementaryItems = [groupBadge]

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: .largeInset, leading: .largeInset, bottom: .largeInset, trailing: .largeInset)

        return .init(section: section)
    }
}
