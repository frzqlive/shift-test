import Foundation

final class MainInteractor: MainInteractorProtocol {
    var storedName: String? { UserDefaults.standard.string(forKey: "first_name") }

    func loadBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        guard let url = URL(string: "https://fakerapi.it/api/v1/books?_quantity=20") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.success([])) }
                return
            }
            do {
                let wrapper = try JSONDecoder().decode(BookWrapper.self, from: data)
                DispatchQueue.main.async { completion(.success(wrapper.data)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    private struct BookWrapper: Decodable {
        let data: [Book]
    }
}
