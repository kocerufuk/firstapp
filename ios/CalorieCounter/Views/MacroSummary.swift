import SwiftUI

struct MacroSummary: View {
    let protein: Double
    let carbs: Double
    let fat: Double

    var body: some View {
        HStack {
            macro("Protein", protein, .blue)
            macro("Karbonhidrat", carbs, .orange)
            macro("Yağ", fat, .pink)
        }
    }

    private func macro(_ title: String, _ value: Double, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(value, specifier: "%.0f") g")
                .font(.headline)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
