import SwiftUI

struct ResultView: View {
    let analysis: FoodAnalysis

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Toplam")
                    .font(.headline)
                Spacer()
                Text("\(analysis.totalCalories) kcal")
                    .font(.title2.bold())
            }

            ForEach(analysis.items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.name).font(.subheadline.bold())
                        Spacer()
                        Text("\(item.calories) kcal")
                    }
                    Text(item.portion)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("P \(item.proteinG, specifier: "%.0f")g · K \(item.carbsG, specifier: "%.0f")g · Y \(item.fatG, specifier: "%.0f")g")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
                Divider()
            }

            if !analysis.notes.isEmpty {
                Text(analysis.notes)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.gray.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
    }
}
