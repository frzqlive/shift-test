import Foundation

final class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    private let interactor: MainInteractorProtocol

    init(interactor: MainInteractorProtocol) {
        self.interactor = interactor
    }

    func viewDidLoad() {
        view?.setLoading(true)
        interactor.loadBooks { [weak self] result in
            self?.view?.setLoading(false)
            switch result {
            case .success(let items): self?.view?.show(items: items)
            case .failure(let error): self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func didTapGreet() {
        let name = interactor.storedName ?? "пользователь"
        view?.showGreeting("Здравствуйте, \(name)!")
    }
}
