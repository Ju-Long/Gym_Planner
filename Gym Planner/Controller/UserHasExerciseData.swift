import Foundation
struct UserHasExerciseData: Codable, Identifiable, Hashable {
    let id = UUID()
    let user_has_exercise_id: Int
    let exercise_name: String
    let exercise_image: String
    let sets: Int
    let reps: Int
    let sets_done: Int
    let weight: Double
    let date: Date
}
