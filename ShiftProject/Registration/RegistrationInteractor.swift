import Foundation

final class RegistrationInteractor: RegistrationInteractorProtocol {
    private let session: UserSessionServiceProtocol

    init(session: UserSessionServiceProtocol) {
        self.session = session
    }

    func validate(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?) -> Result<Void, ValidationError> {
        let firstName = (first ?? "").trimmingCharacters(in: .whitespaces)
        let lastName = (last ?? "").trimmingCharacters(in: .whitespaces)

        guard firstName.count >= 2 else { return .failure(.firstShort) }
        guard lastName.count >= 2 else { return .failure(.lastShort) }
        guard let birth = birth else { return .failure(.noBirth) }

        if let year = Calendar.current.dateComponents([.year], from: birth, to: Date()).year, year < 16 {
            return .failure(.underAge)
        }

        let password = pass ?? ""
        guard password.count >= 8,
              password.range(of: "[A-Z]", options: .regularExpression) != nil,
              password.range(of: "[0-9]", options: .regularExpression) != nil
        else { return .failure(.weakPass) }

        guard password == confirm else { return .failure(.mismatch) }

        return .success(())
    }

    func save(firstName: String) {
        session.save(firstName: firstName)
    }
}
