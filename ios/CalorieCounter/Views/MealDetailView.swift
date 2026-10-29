import SwiftUI

struct MealDetailView: View {
    @Bindable var meal: MealEntry

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let image = meal.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }

                Picker("Öğün", selection: $meal.mealType) {
                    ForEach(MealType.allCases) { type in
                        Text(type.title).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                DatePicker("Zaman", selection: $meal.date)

                MacroSummary(protein: meal.proteinG, carbs: meal.carbsG, fat: meal.fatG)

                ResultView(analysis: FoodAnalysis(items: meal.items,
                                                  totalCalories: meal.totalCalories,
                                                  confidence: 1,
                                                  notes: meal.notes))
            }
            .padding()
        }
        .navigationTitle(meal.mealType.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
