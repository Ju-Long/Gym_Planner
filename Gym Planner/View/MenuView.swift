import SwiftUI

struct MenuView: View {
    @Binding var showMenu: Bool
    @Binding var showMain: Bool
    @Binding var showAdd: Bool
    @Binding var showDelete: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 30) {
                Button(action: {
                    showMain = true
                    showAdd = false
                    showMenu = false
                    showDelete = false
                }, label: {
                    HStack{
                        Image("home-icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Home")
                            .font(.title)
                            .bold()
                            .frame(alignment: .center)
                            .foregroundColor(.black)
                    }
                })
                Button(action: {
                    showMain = false
                    showAdd = true
                    showMenu = false
                    showDelete = false
                }, label: {
                    HStack {
                        Image("add-icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Add a new exercise")
                            .font(.title)
                            .bold()
                            .frame(width: 150)
                            .foregroundColor(.black)
                    }
                })
                Button(action: {
                    showMain = false
                    showAdd = false
                    showMenu = false
                    showDelete = true
                }, label: {
                    HStack {
                        Image("delete-icon")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("Remove a upcoming exercise")
                            .font(.title)
                            .bold()
                            .frame(width: 150)
                            .foregroundColor(.black)
                    }
                })
            }
            .padding(.bottom, 200)
            .navigationBarItems(leading: (Button(action: {
                showMenu.toggle()
            }, label: {
                Image("menu-active-icon")
                    .resizable()
                    .frame(width: 30, height: 30)
            })))
        }
    }
}

