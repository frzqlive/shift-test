import UIKit

final class RegistrationViewController: UIViewController, RegistrationViewProtocol {
    private let presenter: RegistrationPresenter
    private let scrollView = UIScrollView()
    private let content = UIStackView()
    private let firstNameField = UITextField()
    private let lastNameField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    private let birthDateField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()
    private var chosenDate: Date?

    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Регистрация"
        view.backgroundColor = .systemBackground
        setupUI()
        presenter.viewDidLoad()
    }
}

private extension RegistrationViewController {
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        content.axis = .vertical
        content.spacing = 12
        scrollView.addSubview(content)
        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])

        [firstNameField, lastNameField, birthDateField, passwordField, confirmPasswordField, registerButton].forEach { content.addArrangedSubview($0) }

        [firstNameField, lastNameField, birthDateField, passwordField, confirmPasswordField].forEach { tf in
            tf.borderStyle = .roundedRect
            tf.heightAnchor.constraint(equalToConstant: 44).isActive = true
            tf.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
        }
        firstNameField.placeholder = "Имя"
        lastNameField.placeholder = "Фамилия"
        birthDateField.placeholder = "Дата рождения"
        passwordField.placeholder = "Пароль"
        confirmPasswordField.placeholder = "Подтверждение пароля"
        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .none
        confirmPasswordField.textContentType = .none
        confirmPasswordField.isSecureTextEntry = true

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())
        datePicker.addTarget(self, action: #selector(onPickDate), for: .valueChanged)
        birthDateField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(onBirthDone))
        toolbar.items = [UIBarButtonItem.flexibleSpace(), done]
        birthDateField.inputAccessoryView = toolbar

        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.configuration = .filled()
        registerButton.isEnabled = false
        registerButton.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
    }
}

private extension RegistrationViewController {
    @objc func onEditingChanged() {
        presenter.didChangeFields(
            first: firstNameField.text,
            last: lastNameField.text,
            pass: passwordField.text,
            confirm: confirmPasswordField.text,
            birth: chosenDate
        )
    }

    @objc func onPickDate() {
        chosenDate = datePicker.date
        updateBirthField()
    }

    @objc func onBirthDone() {
        let maxDate = Calendar.current.date(byAdding: .year, value: -16, to: Date())!
        chosenDate = datePicker.date > maxDate ? maxDate : datePicker.date
        updateBirthField()
        birthDateField.resignFirstResponder()
    }

    @objc func onRegister() {
        presenter.didTapRegister(
            first: firstNameField.text,
            last: lastNameField.text,
            pass: passwordField.text,
            confirm: confirmPasswordField.text,
            birth: chosenDate
        )
    }

    func updateBirthField() {
        guard let date = chosenDate else { return }
        birthDateField.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        onEditingChanged()
    }
}

extension RegistrationViewController {
    func setRegisterEnabled(_ enabled: Bool) { registerButton.isEnabled = enabled }
    func showError(message: String) {
        let a = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
    func updateBirthTitle(_ text: String) {}
}
