import SwiftUI

struct DeleteRow: View {
    var body: some View {
        HStack {
            Image("squat-icon")
                .resizable()
                .frame(width: 30, height: 30)
            Spacer()
            Text("5 Sets, 5 Reps")
                .foregroundColor(Color(.orange))
            Spacer()
            VStack {
                Text("17.02.2021")
                    .foregroundColor(.gray)
                    .bold()
                    .font(.subheadline)
                Spacer()
                Button(action: {}, label: {
                    Text("Delete")
                        .foregroundColor(.red)
                })
            }
        }
        .frame(height: 40)
    }
}
