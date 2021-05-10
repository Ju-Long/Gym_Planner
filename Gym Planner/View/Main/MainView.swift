import SwiftUI

struct MainView: View {
    @State private var userhasexercisedata = [UserHasExerciseData]()
    @State private var currentdata = SelectedExercise()
    @State private var message: Date = Date()
    @State private var showEdit = false
    @State private var textColor = Color(.orange)
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
                    Spacer()
                    Button(action: {
                        message = Date()
                        textColor = Color(.orange)
                        loadExerciseData()
                    }, label: {
                        Text("Today")
                            .foregroundColor(textColor)
                    })
                    Button {
                        textColor = Color(.gray)
                        loadExerciseData()
                    } label: {
                        DatePicker (
                            "",
                            selection: $message,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(CompactDatePickerStyle())
                    }

                }
                .frame(width: maxWidth * 0.9,alignment: .trailing)
                .padding(.vertical, 15)
                ScrollView {
                    if userhasexercisedata.count > 0 {
                        ForEach (userhasexercisedata){ data in
                            CardViewRow(showEdit: $showEdit, userHasExercise: data, user: $user)
                        }
                        .listStyle(PlainListStyle())
                        .frame(alignment: .center)
                        .padding(.bottom, 5)
                    } else {
                        Text("There is no Exercise \(message, formatter: Self.mainDateFormat)")
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
        guard let url = URL(string: "https://babasama.com/gym_planner/get_user_exercise_data?username=\(user.username)&password=\(user.user_password)&date=\(Int(message.timeIntervalSince1970))") else {
            print("Your API end point is invalid")
            return
        }
        print(url)
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
