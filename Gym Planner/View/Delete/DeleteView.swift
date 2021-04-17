import SwiftUI

struct DeleteView: View {
    @State var userHasExerciseData = [UserHasExerciseData]()
    @State var unconfirmedData = SelectedUserHasExercise()
    @State private var showingActionSheet = false
    @Binding var showMenu: Bool
    @Binding var user_id: Int
    @Binding var username: String
    @Binding var user_password: String
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
                        HStack {
                            Image("\(userhasexercisedata.exercise_image)")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Spacer()
                            Text("\(userhasexercisedata.sets) Sets, \(userhasexercisedata.reps) Reps")
                                .foregroundColor(Color(.orange))
                            Spacer()
                            VStack {
                                Text("\(userhasexercisedata.date, formatter: Self.mainDateFormat)")
                                    .foregroundColor(.gray)
                                    .bold()
                                    .font(.subheadline)
                                Spacer()
                                Button(action: {
                                    unconfirmedData.user_has_exercise_id = userhasexercisedata.user_has_exercise_id
                                    unconfirmedData.date = userhasexercisedata.date
                                    self.showingActionSheet = true
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
        guard let url = URL(string: "https://babasama.com/user_has_exercise_data?user_id=\(user_id)&user_password=\(user_password)") else {
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
    
    func removeExercise() {
        let url = URL(string: "https://babasama.com/delete_user_has_exercise_data?username=\(username)&user_password=\(user_password)&user_has_exercise_id=\(unconfirmedData.user_has_exercise_id)&date=\(Int(unconfirmedData.date.timeIntervalSince1970 * 1000))")
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
