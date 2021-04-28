import SwiftUI

struct MainView: View {
    @State private var userhasexercisedata = [UserHasExerciseData]()
    @State private var currentdata = SelectedExercise()
    @State private var loading = false
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
    var id: Int = 0;
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 5){
                Text("\(Date(), formatter: Self.mainDateFormat)")
                    .font(.largeTitle)
                Text("\(Date(), formatter: Self.subDateFormat)")
                    .font(.subheadline)
                    .foregroundColor(Color(.gray))
                ScrollView {
                    if userhasexercisedata.count > 0 {
                        ForEach (userhasexercisedata){ data in
                            CardViewRow(userHasExercise: data, user: $user, loading: $loading)
                        }
                        .listStyle(PlainListStyle())
                        .frame(alignment: .center)
                        .padding(.bottom, 5)
                    } else {
                        Text("There is no Exercise today")
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
            }}}
    
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
                        self.userhasexercisedata = response
                        loading = false
                    }
                    return
                }
            }
        }.resume()
    }
}

