import SwiftUI

struct SignupView: View {
    @State var error = ""
    @Binding var user: SelectedUser
    @Binding var showLogin: Bool
    @Binding var showMain: Bool
    @Binding var showSignup: Bool
    var body: some View {
        VStack {
            TextField("Username", text: $user.username)
                .padding(.horizontal, 15)
                .frame(width: maxWidth * 0.8, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2))
                .padding(.bottom, 10)
            TextField("Email", text: $user.user_email)
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
                .background(Color.white)
                .padding(.bottom, 10)
            
            Text(error)
                .foregroundColor(Color(.red))
                .padding(.bottom, 10)
            
            Button(action: {
                signup()
            }, label: {
                Text("Signup")
                    .frame(width: maxWidth * 0.6, height: 50, alignment: .center)
                    .foregroundColor(.white)
            })
            .background(RoundedCorners(tl: 10, tr: 10, bl: 10, br: 10)
                    .fill(Color(.orange)))
            .padding(.bottom, 20)
        }
        .frame(width: maxWidth, height: maxHeight, alignment: .center)
        .background(
            Image("loginpage")
                .resizable()
        )
    }
    
    func signup() {
        if user.username.isEmpty || user.user_email.isEmpty || user.user_password.isEmpty {
            self.error = "Username or Email or Password field is empty"
        } else {
            if isValidEmail(user.user_email) {
                let url = URL(string: "https://babasama.com/gym_planner/signup?username=\(user.username)&password=\(user.user_password)&email=\(user.user_email)")
                let request = URLRequest(url: url!)
                URLSession.shared.dataTask(with: request) { data, response, error  in
                    guard let data = data else {
                        print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                        user.user_id = decoded[0].user_id
                        showSignup = false
                        showLogin = false
                        showMain = true
                    } else {
                        user.username = ""
                        user.user_email = ""
                        user.user_password = ""
                        self.error = "User Already Exist"
                    }
                }.resume()
            } else {
                self.error = "Invalid Email Format"
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
