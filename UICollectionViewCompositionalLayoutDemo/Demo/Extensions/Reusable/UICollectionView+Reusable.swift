import UIKit

extension UICollectionReusableView: Reusable {}

extension UICollectionView {
    static let elementKindHeader: String = "UICollectionViewElementKindHeader"
    static let elementKindFooter: String = "UICollectionViewElementKindFooter"
    static let elementKindItemBadge: String = "UICollectionViewElementKindItemBadge"

    enum SupplementaryViewKind {
        case header
        case footer
        case itemBadge
        case sectionHeader
        case sectionFooter
        case custom(String)

        var rawValue: String {
            switch self {
            case .header:
                return UICollectionView.elementKindHeader

            case .footer:
                return UICollectionView.elementKindFooter

            case .itemBadge:
                return UICollectionView.elementKindItemBadge

            case .sectionHeader:
                return UICollectionView.elementKindSectionHeader

            case .sectionFooter:
                return UICollectionView.elementKindSectionFooter

            case let .custom(kind):
                return kind
            }
        }
    }

    func register<T: UICollectionViewCell>(cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(supplementaryViewClass: T.Type, ofKind kind: SupplementaryViewKind) {
        register(supplementaryViewClass,
                 forSupplementaryViewOfKind: kind.rawValue,
                 withReuseIdentifier: supplementaryViewClass.reuseIdentifier)
    }

    func dequeue<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }

    func dequeue<T: UICollectionReusableView>(supplementaryViewClass: T.Type,
                                              ofKind kind: SupplementaryViewKind,
                                              for indexPath: IndexPath) -> T? {
        dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                         withReuseIdentifier: supplementaryViewClass.reuseIdentifier,
                                         for: indexPath) as? T
    }
}
