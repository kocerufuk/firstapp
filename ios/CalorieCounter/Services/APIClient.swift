import Foundation
import UIKit

enum APIError: LocalizedError {
    case imageEncodingFailed
    case server(status: Int, message: String)

    var errorDescription: String? {
        switch self {
        case .imageEncodingFailed: return "Fotoğraf işlenemedi."
        case .server(let status, let message): return "Sunucu hatası (\(status)): \(message)"
        }
    }
}

final class APIClient {
    static let shared = APIClient()

    private let session: URLSession
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func analyze(image: UIImage) async throws -> FoodAnalysis {
        guard let jpeg = image.resized(maxDimension: 1024).jpegData(compressionQuality: 0.7) else {
            throw APIError.imageEncodingFailed
        }

        let boundary = UUID().uuidString
        var request = URLRequest(url: Config.apiBaseURL.appendingPathComponent("analyze"))
        request.httpMethod = "POST"
        request.timeoutInterval = 60
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"food.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(jpeg)
        body.append("\r\n--\(boundary)--\r\n")

        let (data, response) = try await session.upload(for: request, from: body)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            throw APIError.server(status: status, message: String(decoding: data, as: UTF8.self))
        }
        return try decoder.decode(FoodAnalysis.self, from: data)
    }
}

private extension Data {
    mutating func append(_ string: String) {
        append(Data(string.utf8))
    }
}

extension UIImage {
    func resized(maxDimension: CGFloat) -> UIImage {
        let largest = max(size.width, size.height)
        guard largest > maxDimension else { return self }
        let scale = maxDimension / largest
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
