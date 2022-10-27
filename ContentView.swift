//
//  ContentView.swift
//  FormUI
//
//  Created by Fauzan Nugraha on 27/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var passwordField = ""
    @State private var confPassword = ""
    @State private var birthDate = Date()
    @State private var sendNewsletter = false
    @State private var numberofLike = 1
    
    var body: some View {
        NavigationView {
            Form{
                Section(header: Text("Personal Information"))
                {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    SecureField("Enter Password", text: $passwordField)
                    SecureField("Confirm Password", text: $confPassword)
                    DatePicker("Birthdate", selection: $birthDate, displayedComponents: .date)
                }
                
                Section(header: Text("Action")){
                    Toggle("Send Newsletter", isOn: $sendNewsletter)
                    Stepper("Number of Likes", value: $numberofLike, in: 1...100)
                    Text("Count to \(numberofLike)")
                    Link("Watch some Video", destination: URL(string: "https://youtube.com")!)
                }
                
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                   Button("Save", action: saveUser )
                }
            }
        }
    }
    
    func saveUser() {
        print("Saved!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
