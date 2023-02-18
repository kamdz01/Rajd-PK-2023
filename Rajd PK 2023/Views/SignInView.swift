//
//  SignInView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @AppStorage("loggedIn") var loggedIn = false
    @AppStorage("email") var email = ""
    @AppStorage("password") var password = ""
    
    @State var signOutProcessing = false
    @State var signInProcessing = false
    @State var signInErrorMessage = ""
    
    var body: some View {
        
        if loggedIn{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                VStack{
                    Text("Zalogowano jako: \n\(email)")
                        .font(.title2)
                    Button(action: {
                        signOutUser()
                    }) {
                        if #available(iOS 15.0, *) {
                            Text("Wyloguj")
                                .bold()
                                .frame(width: 360, height: 50)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        } else {
                            Text("Wyloguj")
                                .bold()
                                .padding()
                                .frame(width: 360, height: 50)
                                .background(Color("FieldColor"))
                                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .navigationTitle("Logowanie")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        else{
            ZStack {
                LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
                VStack(spacing: 15) {
                    Text("Uwaga! Opcja logowania dostępna jest tylko dla Kadry Rajdu. Jeżeli jesteś uczestnikiem, nie musisz się logować.")
                        .padding()
                    SignInCredentialFields(email: $email, password: $password)
                    Button(action: {
                        hideKeyboard()
                        signInUser(userEmail: email, userPassword: password)
                    }) {
                        if #available(iOS 15.0, *) {
                            Text("Zaloguj")
                                .bold()
                                .frame(width: 360, height: 50)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        } else {
                            Text("Zaloguj")
                                .bold()
                                .padding()
                                .frame(width: 360, height: 50)
                                .background(Color("FieldColor"))
                                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                .disabled(email.isEmpty || password.isEmpty || signInProcessing)
                        }
                    }
                    .disabled(email.isEmpty || password.isEmpty || signInProcessing)
                    if signInProcessing {
                        ProgressView()
                    }
                    if !signInErrorMessage.isEmpty {
                        Text("Failed signing in: \(signInErrorMessage)")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .navigationTitle("Logowanie")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button{
                            hideKeyboard()
                        }
                    label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                    }
                }
            }
            .gesture(DragGesture().onChanged{_ in hideKeyboard()})
        }
    }
    
    func signInUser(userEmail: String, userPassword: String) {
        
        signInProcessing = true
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard error == nil else {
                signInProcessing = false
                signInErrorMessage = error!.localizedDescription
                return
            }
            switch authResult {
            case .none:
                print("Could not sign in user.")
                signInProcessing = false
            case .some(_):
                print("User signed in")
                signInProcessing = false
                signInErrorMessage = ""
                loggedIn = true
            }
            
        }
        print("LoggedIn: \(loggedIn)")
    }
    
    func signOutUser() {
        signOutProcessing = true
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            signOutProcessing = false
        }
        loggedIn = false
        email = ""
        password = ""
        print("LoggedIn: \(loggedIn), Email: \(email), Password: \(password)")
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        //        SignInView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("samplepassw"))
        //        SignInView(loggedIn: .constant(false), email: .constant("sample@email.com"), password: .constant("samplepassw"))
        SignInView()
    }
}

struct SignInCredentialFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        Group {
            if #available(iOS 15.0, *) {
                TextField("Email", text: $email)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)
                SecureField("Hasło", text: $password)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .padding(.bottom, 30)
            } else {
                TextField("Email", text: $email)
                    .padding()
                    .cornerRadius(10)
                    .background(Color("FieldColor"))
                    .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                    .opacity(0.4)
                SecureField("Hasło", text: $password)
                    .padding()
                    .cornerRadius(10)
                    .background(Color("FieldColor"))
                    .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                    .opacity(0.4)
            }
        }
    }
}
