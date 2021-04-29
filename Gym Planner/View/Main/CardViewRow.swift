import SwiftUI

struct CardViewRow: View {
    @State var selectedExercise = SelectedExercise()
    @State var showMessage = ""
    @State var color = Color(.orange)
    @Binding var showEdit: Bool
    var userHasExercise: UserHasExerciseData
    @Binding var user: SelectedUser
    @Binding var message: String
    static let mainDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        return formatter
    }()
    var colors = [Color(.orange), Color(.blue), Color(.green)]
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                
                Text("\(userHasExercise.exercise_name)")
                    .frame(alignment: .center)
                    .font(.title3)
                    .foregroundColor(.white)
                if message == "everyday" {
                    Text(userHasExercise.date, formatter: Self.mainDateFormat)
                        .frame(alignment: .trailing)
                        .font(.title3)
                        .foregroundColor(Color(.gray))
                }
            }
                .frame(width: maxWidth*0.95, height: 30)
            .background(RoundedCorners(tl: 30, tr: 30, bl: 0, br: 0).fill(color))
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
                new_set()
            }, label: {
                Text(showMessage)
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
            })
        }
        .onAppear(perform: {
            color = colors[Int.random(in: 0...2)]
        })
    }
    
    func new_set() {
        let url = URL(string: "https://babasama.com/new_set_done?data_id=\(userHasExercise.data_id)&sets_done=\(userHasExercise.sets_done + 1)&date=\(Int(userHasExercise.date.timeIntervalSince1970 * 1000))&username=\(user.username)&user_password=\(user.user_password)")
        print(url!)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([dataOutput].self, from: data) {
                print(decoded)
                showMessage = "👍"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    showMessage = ""
                }
            }
        }.resume()
    }
}
