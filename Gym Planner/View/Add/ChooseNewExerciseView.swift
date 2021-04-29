import SwiftUI

struct ChooseNewExerciseView: View {
    @State var userhasexercise = [UserHasExercise]()
    @State private var showAddExercise = false
    @Binding var unconfirmed: SelectedExercise
    @Binding var showChoose: Bool
    @Binding var user: SelectedUser
    var body: some View {
        NavigationView {
            VStack {
                if userhasexercise.count > 0 {
                    List(userhasexercise) { userhasexercise in
                        HStack {
                            Image(userhasexercise.exercise_image)
                                .resizable()
                                .frame(width:50, height: 50)
                            Spacer()
                            Button(action: {
                                unconfirmed.user_has_exercise_id = userhasexercise.user_has_exercise_id
                                unconfirmed.name = userhasexercise.exercise_name
                                showChoose = false
                            }, label: {
                                Text(userhasexercise.exercise_name)
                                    .font(.headline)
                            })
                        }
                    }
                } else {
                    Text("There is no exercise binded to you")
                }
            }
            .navigationBarTitle("Choose an Exercise")
            .navigationBarItems(trailing: (Button(action: { showAddExercise.toggle() }, label: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
            })))
            .onAppear(perform: loadExercise)
            .sheet(isPresented: $showAddExercise, content: {
                AddNewExerciseView(user: $user, showAddExercise: $showAddExercise)
            })
        }
    }
    
    func loadExercise() {
        guard let url = URL(string: "https://babasama.com/user_has_exercise?user_id=\(user.user_id)&user_password=\(user.user_password)") else {
            print("Your API end point is invalid")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([UserHasExercise].self, from: data) {
                    DispatchQueue.main.async {
                        self.userhasexercise = response
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            loadExercise()
                        }
                    }
                    return
                }
            }
        }.resume()
    }
}
