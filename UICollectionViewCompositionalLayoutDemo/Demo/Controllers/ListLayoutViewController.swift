import Foundation
import SnapKit
import TIUIKitCore
import UIKit

final class ListLayoutViewController: BaseInitializeableViewController {
    private enum Section {
        case main
    }

    private enum Layout: String, CaseIterable {
        case estimatedHeight = "EstimatedHeightLayoutViewController"
        case grid = "GridLayoutViewController"
        case nestedGroups = "NestedGroupsLayoutViewController"
        case sections = "SectionsLayoutViewController"
        case boundarySupplementary = "BoundarySupplementaryItemsLayoutViewController"
        case supplementary = "SupplementaryItemsLayoutViewController"
        case decoration = "DecorationItemsLayoutViewController"

        var fullClassName: String {
            "UICollectionViewCompositionalLayoutDemo.\(rawValue)"
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Layout>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Layout>

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private lazy var dataSource = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cellClass: TableCell.self)
        collectionView.delegate = self

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

        title = "List"
    }

    // MARK: - Private methods

    private func applySnapshot() {
        var snapshot = Snapshot()

        snapshot.appendSections([.main])
        snapshot.appendItems(Layout.allCases, toSection: .main)

        dataSource.apply(snapshot)
    }

    private func createDataSource() -> DataSource {
        let cellProvider: DataSource.CellProvider = { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            let cell = collectionView.dequeue(cellClass: TableCell.self, for: indexPath)
            cell?.configure(with: itemIdentifier.rawValue)
            return cell
        }

        return DataSource(collectionView: collectionView, cellProvider: cellProvider)
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        .list(using: .init(appearance: .plain))
    }
}

extension ListLayoutViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath),
              let controllerClass = Bundle.main.classNamed(itemIdentifier.fullClassName) as? UIViewController.Type
        else {
            return
        }

        let controller = controllerClass.init()
        navigationController?.pushViewController(controller, animated: true)
    }
}
