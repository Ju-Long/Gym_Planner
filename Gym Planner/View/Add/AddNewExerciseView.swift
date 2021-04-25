import SwiftUI

struct AddNewExerciseView: View {
    @State var exercise_name = ""
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @Binding var user: SelectedUser
    @Binding var showAddExercise: Bool
    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    showingImagePicker.toggle()
                }, label: {
                    if (inputImage == nil) {
                        ZStack {
                            Text("no image")
                                .foregroundColor(.black)
                                .frame(width: 100, height: 100, alignment: .center)
                                .zIndex(1)
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                            Image("add-image-icon")
                                .resizable()
                                .zIndex(2)
                                .frame(width: 25, height: 25)
                                .padding(.top, 70)
                                .padding(.leading, 80)
                        }
                    } else {
                        Image(uiImage: inputImage!)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 2).shadow(radius: 7))
                    }
                })
                .padding(.bottom, 20)
                
                TextField("Name of exercise", text: $exercise_name)
                    .foregroundColor(Color(.gray))
                    .padding(.horizontal, maxWidth * 0.05)
                Divider()
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .background(Color.black)
            }
            .frame(width: maxWidth, height: maxHeight/2, alignment: .top)
            .navigationTitle("Add an new exercise")
            .navigationBarItems(trailing: Button(action: {
                let success = saveImage(image: inputImage!)
                if let image = getSavedImage(named: "\(exercise_name)") {
                    print(image)
                    addExercise()
                    showAddExercise.toggle()
                }
            }, label: { Text("Add") }))
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage, content: {
                ImagePicker(image: self.$inputImage)
            })
        }
    }
    
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(exercise_name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            print(dir.absoluteURL)
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func addExercise() {
        let url = URL(string: "https://babasama.com/new_exercise?exercise_name=\(exercise_name)&exercise_image=\(exercise_name)&user_id=\(user.user_id)&username=\(user.username)&user_password=\(user.user_password)")
        print(url!)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([dataOutput].self, from: data) {
                print(decoded)
            }
        }.resume()
    }
}
