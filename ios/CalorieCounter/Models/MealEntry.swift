import Foundation
import SwiftData
import UIKit

@Model
final class MealEntry {
    var date: Date
    var mealTypeRaw: String
    var totalCalories: Int
    var proteinG: Double
    var carbsG: Double
    var fatG: Double
    var notes: String
    /// [FoodItem] JSON olarak saklanır
    var itemsData: Data
    @Attribute(.externalStorage) var imageData: Data?

    init(analysis: FoodAnalysis, mealType: MealType, image: UIImage?, date: Date = .now) {
        self.date = date
        self.mealTypeRaw = mealType.rawValue
        self.totalCalories = analysis.totalCalories
        self.proteinG = analysis.items.reduce(0) { $0 + $1.proteinG }
        self.carbsG = analysis.items.reduce(0) { $0 + $1.carbsG }
        self.fatG = analysis.items.reduce(0) { $0 + $1.fatG }
        self.notes = analysis.notes
        self.itemsData = (try? JSONEncoder().encode(analysis.items)) ?? Data()
        self.imageData = image?.resized(maxDimension: 512).jpegData(compressionQuality: 0.6)
    }

    var mealType: MealType {
        get { MealType(rawValue: mealTypeRaw) ?? .snack }
        set { mealTypeRaw = newValue.rawValue }
    }

    var items: [FoodItem] {
        (try? JSONDecoder().decode([FoodItem].self, from: itemsData)) ?? []
    }

    var image: UIImage? {
        imageData.flatMap(UIImage.init(data:))
    }

    var title: String {
        let names = items.map(\.name)
        return names.isEmpty ? mealType.title : names.joined(separator: ", ")
    }
}

extension Array where Element == MealEntry {
    var totalCalories: Int { reduce(0) { $0 + $1.totalCalories } }
    var totalProtein: Double { reduce(0) { $0 + $1.proteinG } }
    var totalCarbs: Double { reduce(0) { $0 + $1.carbsG } }
    var totalFat: Double { reduce(0) { $0 + $1.fatG } }
}
