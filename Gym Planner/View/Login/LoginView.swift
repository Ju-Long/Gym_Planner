import SwiftUI

struct LoginView: View {
    @State var showSignup = false
    @State private var error = ""
    @Binding var user: SelectedUser
    @Binding var showLogin: Bool
    @Binding var showMain: Bool
    var body: some View {
        VStack {
            TextField("Username", text: $user.username)
                .padding(.horizontal, 15)
                .frame(width: maxWidth * 0.8, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2))
                .padding(.bottom, 10)
            TextField("Password", text: $user.user_password)
                .padding(.horizontal, 15)
                .frame(width: maxWidth * 0.8, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2))
                .padding(.bottom, 5)
            Text("\(error)")
                .foregroundColor(.red)
                .padding(.bottom, 10)
            
            Button(action: {
                login()
            }, label: {
                Text("Login")
                    .frame(width: maxWidth * 0.6, height: 50, alignment: .center)
                    .foregroundColor(.white)
            })
            .background(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 10)
                    .fill(Color(.orange)))
            .padding(.bottom, 20)
            
            Button(action: {
                showSignup.toggle()
            }, label: {
                Text("Sign up an account")
                    .foregroundColor(Color(.blue))
            })
            .sheet(isPresented: $showSignup, content: {
                SignupView(user: $user, showLogin: $showLogin, showMain: $showMain, showSignup: $showSignup)
            })
            
        }
        .frame(width: maxWidth, height: maxHeight, alignment: .center)
        .background(
            Image("loginpage")
                        .resizable())
    }
    
    func login() {
        let url = URL(string: "https://babasama.com/user?username=\(user.username)&user_password=\(user.user_password)")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                showLogin = false
                showMain = true
                user.user_id = decoded[0].user_id
            } else {
                user.user_password = ""
                self.error = "Username or Password entered wrongly"
            }
        }.resume()
    }
}
