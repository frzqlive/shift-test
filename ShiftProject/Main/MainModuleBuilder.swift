import UIKit

enum MainModuleBuilder {
    static func build() -> UIViewController {
        let interactor = MainInteractor()
        let presenter = MainPresenter(interactor: interactor)
        let vc = MainViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
