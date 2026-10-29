import SwiftUI

struct MealRow: View {
    let meal: MealEntry

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let image = meal.image {
                    Image(uiImage: image).resizable().scaledToFill()
                } else {
                    Image(systemName: meal.mealType.icon)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 52, height: 52)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(meal.title)
                    .font(.subheadline.bold())
                    .lineLimit(1)
                Text("\(meal.mealType.title) · \(meal.date.formatted(date: .omitted, time: .shortened))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(meal.totalCalories) kcal")
                .font(.subheadline.monospacedDigit())
        }
    }
}
