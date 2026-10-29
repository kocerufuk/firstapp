import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Bugün", systemImage: "chart.pie") }
            AddMealView()
                .tabItem { Label("Ekle", systemImage: "plus.circle") }
            HistoryView()
                .tabItem { Label("Geçmiş", systemImage: "calendar") }
            SettingsView()
                .tabItem { Label("Ayarlar", systemImage: "gearshape") }
        }
    }
}
