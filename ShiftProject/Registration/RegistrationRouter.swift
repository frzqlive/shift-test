import UIKit

final class RegistrationRouter: RegistrationRouterProtocol {
    weak var viewController: UIViewController?
    func toMain() {
        let main = MainModuleBuilder.build()
        viewController?.navigationController?.setViewControllers([main], animated: true)
    }
}
