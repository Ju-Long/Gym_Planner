//
//  EditExerciseView.swift
//  Gym Planner
//
//  Created by Ju Long on 17/4/21.
//

import SwiftUI

struct EditExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var showSet = false
    @State private var showRep = false
    @State private var showWeight = false
    @State private var showChoose = false
    @State private var showConfirmation = false
    @State private var showComplete = false
    @State private var message = ""
    @Binding var showEdit: Bool
    @Binding var user: SelectedUser
    @Binding var exercise: SelectedExercise
    
    static let mainDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y"
        return formatter
    }()
    static let subDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    var body: some View {
        NavigationView {
            VStack (spacing: 15){
                VStack (alignment: .center, spacing: 5){
                    Text("\(Date(), formatter: Self.mainDateFormat)")
                        .font(.largeTitle)
                    Text("\(Date(), formatter: Self.subDateFormat)")
                        .font(.subheadline)
                        .foregroundColor(Color(.gray))
                }.padding(.top, -15)
                DatePicker (
                    "",
                    selection: $exercise.date,
                    in: Date()...Date(),
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .colorInvert()
                .colorMultiply(Color(.orange))
                List {
                    HStack {
                        Text("Your Exercise")
                            .font(.headline)
                        Spacer()
                        Text("\(exercise.name)")
                            .foregroundColor(Color(.orange))
                            .font(.headline)
                    }.frame(height: 40)
                    
                    HStack {
                        Text("Choose The Amount of Sets")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            showSet.toggle()
                            showRep = false
                            showWeight = false
                        }, label: {
                            HStack {
                                Text("\(exercise.sets)")
                                    .foregroundColor(Color(.orange))
                                    .font(.headline)
                                Text(self.showSet ? "⌄" : ">")
                                    .foregroundColor(.gray)
                            }})
                    }.frame(height: 40)
                    
                    if showSet {
                        HStack {
                            Spacer()
                            Picker("", selection: $exercise.sets) {
                                ForEach(0..<31) { index in
                                    Text("\(index)").tag(index)
                                }}}}
                    
                    HStack {
                        Text("Choose The Amount of Reps")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            showRep.toggle()
                            showSet = false
                            showWeight = false
                        }, label: {
                            HStack {
                                Text("\(exercise.reps)")
                                    .foregroundColor(Color(.orange))
                                    .font(.headline)
                                Text(self.showRep ? "⌄" : ">")
                                    .foregroundColor(.gray)
                            }})
                    }.frame(height: 40)
                    
                    if showRep {
                        HStack {
                            Spacer()
                            Picker("", selection: $exercise.reps) {
                                ForEach(0..<31) { index in
                                    Text("\(index)").tag(index)
                                }}}}
                    
                    HStack {
                        Text("Choose The Weight (optional)")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            showWeight.toggle()
                            showSet = false
                            showRep = false
                        }, label: {
                            HStack {
                                Text("\(exercise.weight, specifier: "%.1f")")
                                    .foregroundColor(Color(.orange))
                                    .font(.headline)
                                Text(self.showWeight ? "⌄" : ">")
                                    .foregroundColor(.gray)
                            }})
                        .alert(isPresented: $showComplete, content: {
                            Alert(title: Text(message), dismissButton: .default(Text("Ok"), action: {
                                showComplete = false
                                presentationMode.wrappedValue.dismiss()
                            }))})
                    }.frame(height: 40)
                    
                    if showWeight {
                        HStack {
                            Spacer()
                            Picker("", selection: $exercise.weight) {
                                ForEach(Array(stride(from: 0, to: 500, by: 2.5)), id:\.self) { index in
                                    Text("\(index, specifier: "%.1f")").tag(index)}}}}
                }
                .listStyle(PlainListStyle())
                Button(action: {
                    showAlert.toggle()
                }, label: {
                    Text("Update")
                        .foregroundColor(.white)
                })
                .frame(width: maxWidth*0.4, height: 70, alignment: .center)
                .background(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20).fill(Color(.orange)))
                .alert(isPresented: $showAlert, content: {
                    if (exercise.name == "Please Select" || exercise.sets == 0 || exercise.reps == 0) {
                        return Alert(title: Text("Please choose at least an exercise and more than 0 sets and reps"), dismissButton: .default(Text("Ok")))
                    } else  {
                        return Alert(title: Text(exercise.date, formatter: Self.mainDateFormat), message: Text("\(exercise.name) \n\(exercise.sets) Sets, \(exercise.reps) Reps, \(exercise.weight, specifier: "%.2f") Kg"), primaryButton: .cancel(), secondaryButton: .default(Text("Update"), action: {
                            editExercise()
                        }))
                    }
                })
            }
            .navigationBarItems(leading: (Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("< Back to Home Page")
            })))
        }
    }
    
    func editExercise() {
        let url = URL(string: "https://babasama.com/gym_planner/add_edit_exercise_data?username=\(user.username)&password=\(user.user_password)&user_has_exercise_id=\(exercise.user_has_exercise_id)&sets=\(exercise.sets)&reps=\(exercise.reps)&weight=\(exercise.weight)&date=\(Int(exercise.date.timeIntervalSince1970) - 1956614400)")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode([dataOutput].self, from: data) {
                showComplete.toggle()
                message = decoded[0].output
            }
        }.resume()
    }
}

