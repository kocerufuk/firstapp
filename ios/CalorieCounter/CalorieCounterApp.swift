import SwiftData
import SwiftUI

@main
struct CalorieCounterApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: MealEntry.self)
    }
}
