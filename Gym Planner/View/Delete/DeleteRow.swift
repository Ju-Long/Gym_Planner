import SwiftUI

struct DeleteRow: View {
    @State var showingActionSheet = false
    @Binding var user: SelectedUser
    var data: UserHasExerciseData
    static let mainDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        return formatter
    }()
    var body: some View {
        HStack {
            Image("\(data.exercise_image)")
                .resizable()
                .frame(width: 30, height: 30)
            Spacer()
            Text("\(data.sets) Sets, \(data.reps) Reps")
                .foregroundColor(Color(.orange))
            Spacer()
            VStack {
                Text("\(data.date, formatter: Self.mainDateFormat)")
                    .foregroundColor(.gray)
                    .bold()
                    .font(.subheadline)
                Spacer()
                Button(action: {
                    showingActionSheet.toggle()
                }, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                })
                .actionSheet(isPresented: $showingActionSheet, content: {
                    ActionSheet(title: Text("Remove Exercise?"), buttons: [
                        .destructive(Text("Remove")) {
                            removeExercise()
                        },
                        .cancel()
                    ])
                })
            }
        }
        .frame(height: 40)
    }
    
    func removeExercise() {
        let url = URL(string: "https://babasama.com/delete_user_has_exercise_data?username=\(user.username)&user_password=\(user.user_password)&data_id=\(data.data_id)&date=\(Int(data.date.timeIntervalSince1970 * 1000))")
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
