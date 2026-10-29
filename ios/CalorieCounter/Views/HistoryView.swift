import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \MealEntry.date, order: .reverse) private var meals: [MealEntry]

    private var days: [(day: Date, meals: [MealEntry])] {
        Dictionary(grouping: meals) { Calendar.current.startOfDay(for: $0.date) }
            .map { (day: $0.key, meals: $0.value) }
            .sorted { $0.day > $1.day }
    }

    var body: some View {
        NavigationStack {
            List {
                if meals.isEmpty {
                    ContentUnavailableView("Kayıt yok",
                                           systemImage: "fork.knife",
                                           description: Text("Eklediğin öğünler burada görünecek."))
                }
                ForEach(days, id: \.day) { group in
                    Section {
                        ForEach(group.meals) { meal in
                            NavigationLink(value: meal) {
                                MealRow(meal: meal)
                            }
                        }
                        .onDelete { offsets in
                            offsets.map { group.meals[$0] }.forEach { modelContext.delete($0) }
                        }
                    } header: {
                        HStack {
                            Text(group.day.formatted(date: .complete, time: .omitted))
                            Spacer()
                            Text("\(group.meals.totalCalories) kcal")
                        }
                    }
                }
            }
            .navigationTitle("Geçmiş")
            .navigationDestination(for: MealEntry.self) { MealDetailView(meal: $0) }
        }
    }
}
