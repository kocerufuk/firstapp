import Foundation

enum MealType: String, CaseIterable, Identifiable, Codable {
    case breakfast, lunch, dinner, snack

    var id: String { rawValue }

    var title: String {
        switch self {
        case .breakfast: return "Kahvaltı"
        case .lunch: return "Öğle"
        case .dinner: return "Akşam"
        case .snack: return "Ara Öğün"
        }
    }

    var icon: String {
        switch self {
        case .breakfast: return "sunrise"
        case .lunch: return "sun.max"
        case .dinner: return "moon"
        case .snack: return "carrot"
        }
    }

    /// Saate göre varsayılan öğün
    static func suggested(for date: Date = .now) -> MealType {
        switch Calendar.current.component(.hour, from: date) {
        case 5..<11: return .breakfast
        case 11..<16: return .lunch
        case 17..<22: return .dinner
        default: return .snack
        }
    }
}
