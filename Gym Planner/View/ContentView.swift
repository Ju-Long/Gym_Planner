import SwiftUI

var maxWidth = UIScreen.main.bounds.size.width
var maxHeight = UIScreen.main.bounds.size.height

struct ContentView: View {
    @State var user_id: Int = 0
    @State var username: String = ""
    @State var user_password: String = ""
    @State var exercise = SelectedExercise()
    
    @State var showLogin = true
    @State var showMenu = false
    @State var showMain = false
    @State var showAdd = false
    @State var showDelete = false
    @State var showEdit = false
    
    var body: some View {
        let drag = DragGesture()
            .onChanged {
                if $0.translation.width > 100 {
                    withAnimation {
                        self.showMenu = true
                    }
                }
            }
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        ZStack(alignment: .leading) {
            if self.showLogin {
                LoginView(user_id: $user_id, username: $username, user_password: $user_password, showLogin: $showLogin, showMain: $showMain) 
            }
            if self.showMain {
                MainView(exercise: $exercise,showEdit: $showEdit,showMenu: $showMenu, showMain: $showMain, user_id: $user_id, username: $username, user_password: $user_password)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            } else if self.showAdd {
                AddExerciseView(showMenu: $showMenu, user_id: $user_id, username: $username, user_password: $user_password)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            } else if self.showDelete {
                DeleteView(showMenu: $showMenu, user_id: $user_id, username: $username, user_password: $user_password)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            } else if self.showEdit {
                EditExerciseView(showEdit: $showEdit, showMenu: $showMenu, user_id: $user_id, username: $username, user_password: $user_password, exercise: $exercise).offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            }

            if self.showMenu {
                MenuView(showMenu: $showMenu, showMain: $showMain, showAdd: $showAdd, showDelete: $showDelete)
                    .frame(width: maxWidth*0.7)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.5))
            }
        }
        .gesture(drag)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
