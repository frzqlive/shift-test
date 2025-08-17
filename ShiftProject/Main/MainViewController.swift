import UIKit

final class MainViewController: UIViewController, MainViewProtocol {
    private let presenter: MainPresenter
    private let tableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let greetButton = UIButton(type: .system)
    private var books: [Book] = []

    init(presenter: MainPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Главный экран"
        view.backgroundColor = .systemBackground
        setupUI()
        presenter.viewDidLoad()
    }
}

private extension MainViewController {
    func setupUI() {
        greetButton.setTitle("Привет", for: .normal)
        greetButton.addTarget(self, action: #selector(didTapGreet), for: .touchUpInside)
        greetButton.translatesAutoresizingMaskIntoConstraints = false

        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()

        spinner.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(greetButton)
        view.addSubview(spinner)

        NSLayoutConstraint.activate([
            greetButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            greetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: greetButton.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func didTapGreet() {
        presenter.didTapGreet()
    }
}

extension MainViewController {
    func show(items: [Book]) {
        books = items
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

    func setLoading(_ loading: Bool) {
        loading ? spinner.startAnimating() : spinner.stopAnimating()
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func showGreeting(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let identifier = "cell_subtitle"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: identifier)

        cell.textLabel?.text = book.title
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)

        cell.detailTextLabel?.text = book.author
        cell.detailTextLabel?.textColor = .secondaryLabel
        cell.detailTextLabel?.numberOfLines = 1

        return cell
    }
}
