import UIKit

enum RegistrationModuleBuilder {
    static func build(session: UserSessionServiceProtocol = UserSessionService()) -> UIViewController {
        let interactor = RegistrationInteractor(session: session)
        let router = RegistrationRouter()
        let presenter = RegistrationPresenter(interactor: interactor, router: router)
        let vc = RegistrationViewController(presenter: presenter)
        router.viewController = vc
        return vc
    }
}
