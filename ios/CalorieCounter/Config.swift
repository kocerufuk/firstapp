import Foundation

enum Config {
    /// Simülatörde localhost çalışır. Gerçek cihazda Mac'in yerel IP'sini yaz (ör. http://192.168.1.20:8000).
    static let apiBaseURL = URL(string: "http://localhost:8000")!
}
