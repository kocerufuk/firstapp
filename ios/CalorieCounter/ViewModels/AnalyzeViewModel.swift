import SwiftData
import SwiftUI

@MainActor
final class AnalyzeViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var result: FoodAnalysis?
    @Published var mealType: MealType = .suggested()
    @Published var isLoading = false
    @Published var errorMessage: String?

    func setImage(_ image: UIImage) {
        self.image = image
        result = nil
        errorMessage = nil
    }

    func analyze() async {
        guard let image else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            result = try await APIClient.shared.analyze(image: image)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func save(in context: ModelContext) {
        guard let result else { return }
        context.insert(MealEntry(analysis: result, mealType: mealType, image: image))
        reset()
    }

    func reset() {
        image = nil
        result = nil
        errorMessage = nil
        mealType = .suggested()
    }
}
