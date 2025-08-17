import UIKit

protocol RegistrationViewProtocol: AnyObject {
    func setRegisterEnabled(_ enabled: Bool)
    func showError(message: String)
}

protocol RegistrationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didChangeFields(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?)
    func didTapRegister(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?)
}

protocol RegistrationInteractorProtocol: AnyObject {
    func validate(first: String?, last: String?, pass: String?, confirm: String?, birth: Date?) -> Result<Void, ValidationError>
    func save(firstName: String)
}

protocol RegistrationRouterProtocol: AnyObject {
    func toMain()
}
