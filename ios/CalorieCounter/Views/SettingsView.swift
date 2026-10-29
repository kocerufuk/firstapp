import SwiftUI

struct SettingsView: View {
    @AppStorage("dailyCalorieGoal") private var dailyGoal = 2000

    var body: some View {
        NavigationStack {
            Form {
                Section("Günlük Hedef") {
                    Stepper(value: $dailyGoal, in: 1000...5000, step: 50) {
                        HStack {
                            Text("Kalori hedefi")
                            Spacer()
                            Text("\(dailyGoal) kcal")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                }

                Section("Sunucu") {
                    LabeledContent("Backend", value: Config.apiBaseURL.absoluteString)
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}
