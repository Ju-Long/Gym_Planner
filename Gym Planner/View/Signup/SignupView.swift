import SwiftUI

struct SignupView: View {
    @State var error = ""
    @State var user_email = ""
    @Binding var user_id: Int
    @Binding var username: String
    @Binding var user_password: String
    @Binding var showLogin: Bool
    @Binding var showMain: Bool
    @Binding var showSignup: Bool
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding(.horizontal, 15)
                .frame(width: maxWidth * 0.8, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2))
                .padding(.bottom, 10)
            TextField("Email", text: $user_email)
                .padding(.horizontal, 15)
                .frame(width: maxWidth * 0.8, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 7)
                            .stroke(Color.black, lineWidth: 2))
                .padding(.bottom, 10)
            TextField("Password", text: $user_password)
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
        let url = URL(string: "https://babasama.com/new_user?username=\(username)&user_email=\(user_email)&user_password=\(user_password)")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([User].self, from: data) {
                user_id = decoded[0].user_id
                showSignup = false
                showLogin = false
                showMain = true
            } else {
                username = ""
                user_email = ""
                user_password = ""
                self.error = "User Already Exist"
            }
        }.resume()
    }
}
