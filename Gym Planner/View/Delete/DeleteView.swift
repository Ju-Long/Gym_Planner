import SwiftUI

struct DeleteView: View {
    @State var userHasExerciseData = [UserHasExerciseData]()
    @State var data = SelectedExercise()
    @State private var showingActionSheet = false
    @Binding var showMenu: Bool
    @Binding var user: SelectedUser
    static let mainDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        return formatter
    }()
    static let subDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    var body: some View {
        NavigationView {
            VStack {
                VStack (alignment: .center, spacing: 5){
                    Text("\(Date(), formatter: Self.mainDateFormat)")
                        .font(.largeTitle)
                    Text("\(Date(), formatter: Self.subDateFormat)")
                        .font(.subheadline)
                        .foregroundColor(Color(.gray))
                }
                Text("Upcoming Exercises")
                    .foregroundColor(Color(.orange))
                    .frame(width: maxWidth*0.95, height: 30, alignment: .trailing)
                    .padding(.top, 30)
                if userHasExerciseData.count > 0 {
                    List (userHasExerciseData) { userhasexercisedata in
                        DeleteRow(user: $user, data: userhasexercisedata)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("There is no upcoming exercises")
                        .frame(height: maxHeight * 0.75)
                }
            }
            .navigationBarItems(leading: (Button(action: {
                showMenu.toggle()
            }, label: {
                Image(self.showMenu ? "clear" : "menu-icon")
                    .resizable()
                    .frame(width: 30, height: 30)
            })))
            .onAppear(perform: loadExerciseData)
        }
    }
    
    func loadExerciseData() {
        guard let url = URL(string: "https://babasama.com/user_has_exercise_data?user_id=\(user.user_id)&user_password=\(user.user_password)") else {
            print("Your API end point is invalid")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([UserHasExerciseData].self, from: data) {
                    DispatchQueue.main.async {
                        self.userHasExerciseData = response
                    }
                    return
                }
            }
        }.resume()
    }
}
