import Foundation

struct FoodItem: Codable, Identifiable, Hashable {
    var id: String { name + portion }
    let name: String
    let portion: String
    let calories: Int
    let proteinG: Double
    let carbsG: Double
    let fatG: Double
}

struct FoodAnalysis: Codable, Hashable {
    let items: [FoodItem]
    let totalCalories: Int
    let confidence: Double
    let notes: String
}
