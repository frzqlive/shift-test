import Foundation

protocol UserSessionServiceProtocol {
    var isAuthorized: Bool { get }
    var firstName: String? { get }
    func save(firstName: String)
}

final class UserSessionService: UserSessionServiceProtocol {
    private let key = "first_name"

    var isAuthorized: Bool {
        guard let name = firstName else { return false }
        return !name.isEmpty
    }

    var firstName: String? {
        UserDefaults.standard.string(forKey: key)
    }

    func save(firstName: String) {
        UserDefaults.standard.set(firstName, forKey: key)
    }
}
