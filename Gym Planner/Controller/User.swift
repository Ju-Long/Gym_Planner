import Foundation
struct User: Codable, Identifiable {
    let id = UUID()
    let user_id: Int
    let username: String
    let user_email: String
    let user_password: String
}
