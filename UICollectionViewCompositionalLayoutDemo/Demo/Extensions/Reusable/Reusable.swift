protocol Reusable {}

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
