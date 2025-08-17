import UIKit

protocol MainViewProtocol: AnyObject {
    func show(items: [Book])
    func setLoading(_ loading: Bool)
    func showError(_ message: String)
    func showGreeting(_ text: String)
}

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapGreet()
}

protocol MainInteractorProtocol: AnyObject {
    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void)
    var storedName: String? { get }
}
