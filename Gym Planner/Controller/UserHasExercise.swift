import Foundation
struct UserHasExercise: Codable, Identifiable {
    let id = UUID()
    let user_has_exercise_id: Int
    let exercise_name: String
    let exercise_image: String
}
