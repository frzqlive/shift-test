import Foundation

final class RegistrationPresenter: RegistrationPresenterProtocol {
    weak var view: RegistrationViewProtocol?
    private let interactor: RegistrationInteractorProtocol
    private let router: RegistrationRouterProtocol

    init(interactor: RegistrationInteractorProtocol, router: RegistrationRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        view?.setRegisterEnabled(false)
    }

    func didChangeFields(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?) {
        let filled = !(first ?? "").isEmpty && !(last ?? "").isEmpty && !(pass ?? "").isEmpty && !(confirm ?? "").isEmpty && birth != nil
        view?.setRegisterEnabled(filled)
    }

    func didTapRegister(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?) {
        switch interactor.validate(first: first, last: last, pass: pass, confirm: confirm, birth: birth) {
        case .success:
            interactor.save(firstName: first?.trimmingCharacters(in: .whitespaces) ?? "")
            router.toMain()
        case .failure(let err):
            view?.showError(message: err.localizedDescription)
        }
    }
}
