import SwiftUI

struct MainView: View {
    @State private var userhasexercisedata = [UserHasExerciseData]()
    @State private var currentdata = SelectedExercise()
    @State private var message = "today"
    @State private var showEdit = false
    @Binding var showMenu: Bool
    @Binding var showMain: Bool
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
            VStack (alignment: .center, spacing: 5){
                Text("\(Date(), formatter: Self.mainDateFormat)")
                    .font(.largeTitle)
                Text("\(Date(), formatter: Self.subDateFormat)")
                    .font(.subheadline)
                    .foregroundColor(Color(.gray))
                HStack{
                    Button(action: {
                        message = "today"
                        loadExerciseData()
                    }, label: {
                        if message == "today" {
                            Text("Today")
                                .foregroundColor(Color(.orange))
                        } else {
                            Text("Today")
                                .foregroundColor(.gray)
                        }
                    })
                    Button(action: {
                        message = "tomorrow"
                        loadExerciseData()
                    }, label: {
                        if message == "tomorrow" {
                            Text("Tomorrow")
                                .foregroundColor(Color(.orange))
                        } else {
                            Text("Tomorrow")
                                .foregroundColor(.gray)
                        }
                    })
                    Button(action: {
                        message = "everyday"
                        loadExerciseData()
                    }, label: {
                        if message == "everyday" {
                            Text("Everyday")
                                .foregroundColor(Color(.orange))
                        } else {
                            Text("Everyday")
                                .foregroundColor(.gray)
                        }
                    })
                }
                .frame(width: maxWidth * 0.9,alignment: .trailing)
                .padding(.vertical, 15)
                ScrollView {
                    if userhasexercisedata.count > 0 {
                        ForEach (userhasexercisedata){ data in
                            CardViewRow(showEdit: $showEdit, userHasExercise: data, user: $user, message: $message)
                        }
                        .listStyle(PlainListStyle())
                        .frame(alignment: .center)
                        .padding(.bottom, 5)
                    } else {
                        Text("There is no Exercise \(message)")
                            .padding(.top, 50)
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
        }}
    
    func loadExerciseData() {
        guard let url = URL(string: "https://babasama.com/user_has_exercise_data?user_id=\(user.user_id)&user_password=\(user.user_password)&day=\(message)") else {
            print("Your API end point is invalid")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([UserHasExerciseData].self, from: data) {
                    DispatchQueue.main.async {
                        self.userhasexercisedata = response
                        if (!showEdit) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                loadExerciseData()
                            }
                        }
                    }
                    return
                }
            }
        }.resume()
    }
}

