import SwiftUI

var maxWidth = UIScreen.main.bounds.size.width
var maxHeight = UIScreen.main.bounds.size.height

struct ContentView: View {
    @State var user = SelectedUser()
    
    @State var showLogin = true
    @State var showMenu = false
    @State var showMain = false
    @State var showAdd = false
    @State var showDelete = false
    
    var body: some View {
        if self.showLogin {
            LoginView(user: $user, showLogin: $showLogin, showMain: $showMain)
        }
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
            if self.showMain {
                MainView(showMenu: $showMenu, showMain: $showMain, user: $user)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            } else if self.showAdd {
                AddExerciseView(showMenu: $showMenu, user: $user, showMain: $showMain, showAdd: $showAdd)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
                    .disabled(self.showMenu ? true : false)
                    .transition(.move(edge: .leading))
                    .animation(.easeInOut(duration: 0.3))
            } else if self.showDelete {
                DeleteView(showMenu: $showMenu, user: $user)
                    .offset(x: self.showMenu ? maxWidth*0.7 : 0)
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
