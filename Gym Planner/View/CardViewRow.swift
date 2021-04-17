import SwiftUI

struct CardViewRow: View {
    @Binding var userHasExercise: UserHasExercise
    var body: some View {
        VStack(spacing: 5) {
            Text("Squat")
                .frame(width: maxWidth*0.95, height: 30, alignment: .center)
                .font(.title3)
                .foregroundColor(.white)
                .background(RoundedCorners(tl: 30, tr: 30, bl: 0, br: 0).fill(Color(.orange)))
            HStack {
                Text("")
                    .frame(width: (maxWidth*0.95/3))
                Image("squat-icon")
                    .resizable()
                    .padding(5)
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                Button(action: {}, label: {
                    Text("Edit Set")
                        .foregroundColor(Color(.orange))
                        .font(.title3)
                })
                .frame(width: (maxWidth*0.95/3),alignment: .trailing)
                .padding(.bottom, 30)
            }
            .frame(width: maxWidth*0.95)
            Text("5 Sets, 5 Reps")
                .font(.title)
            Text("0 Sets Done")
                .font(.title3)
                .foregroundColor(Color(.gray))
            Button(action: {}, label: {
                Text("")
                    .frame(width: 50, height: 50, alignment: .center)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
            })
        }
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}
