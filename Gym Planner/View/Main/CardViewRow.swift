import SwiftUI

struct CardViewRow: View {
    @State var showEdit = false
    @State var selectedExercise = SelectedExercise()
    var userHasExercise: UserHasExerciseData
    @Binding var user: SelectedUser
    var body: some View {
        VStack(spacing: 5) {
            Text("\(userHasExercise.exercise_name)")
                .frame(width: maxWidth*0.95, height: 30, alignment: .center)
                .font(.title3)
                .foregroundColor(.white)
                .background(RoundedCorners(tl: 30, tr: 30, bl: 0, br: 0).fill(Color(.orange)))
            HStack {
                Text("")
                    .frame(width: (maxWidth*0.95/3))
                Image("\(userHasExercise.exercise_image)")
                    .resizable()
                    .padding(5)
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                Button(action: {
                    showEdit.toggle()
                    selectedExercise.data_id = userHasExercise.data_id
                    selectedExercise.date = userHasExercise.date
                    selectedExercise.name = userHasExercise.exercise_name
                    selectedExercise.sets = userHasExercise.sets
                    selectedExercise.reps = userHasExercise.reps
                    selectedExercise.weight = userHasExercise.weight
                }, label: {
                    Text("Edit Set")
                        .foregroundColor(Color(.orange))
                        .font(.title3)
                })
                .frame(width: (maxWidth*0.95/3),alignment: .trailing)
                .padding(.bottom, 30)
                .fullScreenCover(isPresented: $showEdit) {
                    EditExerciseView(showEdit: $showEdit, user: $user, exercise: $selectedExercise)
                }
            }
            .frame(width: maxWidth*0.95)
            Text("\(userHasExercise.sets) Sets, \(userHasExercise.reps) Reps")
                .font(.title)
            Text("\(userHasExercise.sets_done) Sets Done")
                .font(.title3)
                .foregroundColor(Color(.gray))
            if (userHasExercise.weight > 0) {
                Text("\(userHasExercise.weight, specifier: "%.2f") Kg")
                    .font(.title3)
                    .foregroundColor(Color(.gray))
            }
            Button(action: {
                selectedExercise.data_id = userHasExercise.data_id
                selectedExercise.weight = userHasExercise.weight
            }, label: {
                Text("")
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
            })
        }
    }
    
    func new_set() {
        let url = URL(string: "")
        print(url!)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([dataOutput].self, from: data) {
                print(decoded)
            }
        }.resume()
    }
}
