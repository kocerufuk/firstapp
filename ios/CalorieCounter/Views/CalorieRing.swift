import SwiftUI

struct CalorieRing: View {
    let consumed: Int
    let goal: Int

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(Double(consumed) / Double(goal), 1)
    }

    private var remaining: Int { goal - consumed }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.gray.opacity(0.15), lineWidth: 18)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(remaining >= 0 ? Color.green : Color.red,
                        style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            VStack(spacing: 4) {
                Text("\(consumed)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                Text("/ \(goal) kcal")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(remaining >= 0 ? "\(remaining) kcal kaldı" : "\(-remaining) kcal aşıldı")
                    .font(.caption.bold())
                    .foregroundStyle(remaining >= 0 ? Color.green : Color.red)
            }
        }
        .frame(width: 220, height: 220)
    }
}

#Preview {
    CalorieRing(consumed: 1450, goal: 2000)
}
