import Foundation

enum ValidationError: LocalizedError {
    case firstShort
    case lastShort
    case noBirth
    case underAge
    case weakPass
    case mismatch

    var errorDescription: String? {
        switch self {
        case .firstShort: return "Имя должно быть не короче 2 символов"
        case .lastShort: return "Фамилия должна быть не короче 2 символов"
        case .noBirth: return "Выберите дату рождения"
        case .underAge: return "Минимальный возраст — 16 лет"
        case .weakPass: return "Пароль: ≥8 символов, цифра и заглавная буква"
        case .mismatch: return "Пароли не совпадают"
        }
    }
}
