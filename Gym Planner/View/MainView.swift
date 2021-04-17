import SwiftUI

struct MainView: View {
    @State var user = User.self
    @State private var userhasexercisedata = [UserHasExerciseData]()
    @Binding var exercise: SelectedExercise
    @Binding var showEdit: Bool
    @Binding var showMenu: Bool
    @Binding var showMain: Bool
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
                        ForEach (userhasexercisedata){ userhasexercisedata in
                            VStack(spacing: 5) {
                                Text("\(userhasexercisedata.exercise_name)")
                                    .frame(width: maxWidth*0.95, height: 30, alignment: .center)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                    .background(RoundedCorners(tl: 30, tr: 30, bl: 0, br: 0).fill(Color(.orange)))
                                HStack {
                                    Text("")
                                        .frame(width: (maxWidth*0.95/3))
                                    Image("\(userhasexercisedata.exercise_image)")
                                        .resizable()
                                        .padding(5)
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                    Button(action: {
                                        exercise.user_has_exercise_id = userhasexercisedata.user_has_exercise_id
                                        exercise.date = userhasexercisedata.date
                                        exercise.name = userhasexercisedata.exercise_name
                                        exercise.sets = userhasexercisedata.sets
                                        exercise.reps = userhasexercisedata.reps
                                        exercise.weight = userhasexercisedata.weight
                                        exercise.sets_done = userhasexercisedata.sets_done
                                        showMain.toggle()
                                        showEdit.toggle()
                                    }, label: {
                                        Text("Edit Set")
                                            .foregroundColor(Color(.orange))
                                            .font(.title3)
                                    })
                                    .frame(width: (maxWidth*0.95/3),alignment: .trailing)
                                    .padding(.bottom, 30)
                                }
                                .frame(width: maxWidth*0.95)
                                Text("\(userhasexercisedata.sets) Sets, \(userhasexercisedata.reps) Reps")
                                    .font(.title)
                                Text("\(userhasexercisedata.sets_done) Sets Done")
                                    .font(.title3)
                                    .foregroundColor(Color(.gray))
                                if (userhasexercisedata.weight > 0) {
                                    Text("\(userhasexercisedata.weight) Kg")
                                        .font(.title3)
                                        .foregroundColor(Color(.gray))
                                }
                                Button(action: {}, label: {
                                    Text("")
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                                })
                            }
                            .padding(.bottom, 10.0)
                        }
                        .listStyle(PlainListStyle())
                        .frame(alignment: .center)
                        .padding(.bottom, 5)
                    } else {
                        Text("There is no Exercise today")
                    }
                    
                }
                .padding(.top, 50)
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
                        self.userhasexercisedata = response
                    }
                    return
                }
            }
        }.resume()
    }
}
