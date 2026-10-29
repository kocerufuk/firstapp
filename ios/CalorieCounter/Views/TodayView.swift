import SwiftData
import SwiftUI

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("dailyCalorieGoal") private var dailyGoal = 2000
    @Query(sort: \MealEntry.date, order: .reverse) private var allMeals: [MealEntry]

    private var todayMeals: [MealEntry] {
        allMeals.filter { Calendar.current.isDateInToday($0.date) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 20) {
                        CalorieRing(consumed: todayMeals.totalCalories, goal: dailyGoal)
                        MacroSummary(protein: todayMeals.totalProtein,
                                     carbs: todayMeals.totalCarbs,
                                     fat: todayMeals.totalFat)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }

                Section("Bugünkü Öğünler") {
                    if todayMeals.isEmpty {
                        Text("Henüz öğün eklemedin.")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(todayMeals) { meal in
                        NavigationLink(value: meal) {
                            MealRow(meal: meal)
                        }
                    }
                    .onDelete { offsets in
                        offsets.map { todayMeals[$0] }.forEach { modelContext.delete($0) }
                    }
                }
            }
            .navigationTitle("Bugün")
            .navigationDestination(for: MealEntry.self) { MealDetailView(meal: $0) }
        }
    }
}
