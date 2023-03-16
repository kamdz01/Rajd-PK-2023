//
//  VerificationView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 16/03/2023.
//

import SwiftUI

struct VerificationView: View {
    
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State var verificationEmail = ""
    @State var errorMessage = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            VStack{
                Text("W celu weryfikacji podaj e-mail, na który został zakupiony bilet.")
                    .font(.title2)
                if #available(iOS 15.0, *) {
                    TextField("Email", text: $verificationEmail)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                } else {
                    TextField("Email", text: $verificationEmail)
                        .padding()
                        .cornerRadius(10)
                        .background(Color("FieldColor"))
                        .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                        .opacity(0.4)
                        .disableAutocorrection(true)
                }
                Button(action: {
                    hideKeyboard()
                    findEmail(email: verificationEmail)
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
                    }
                }
                if !errorMessage.isEmpty {
                    Text("Błąd: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }
    }
    
    func findEmail(email: String){
        @AppStorage("verificated") var verificated = false
        viewModel.db.collection("Emails").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    errorMessage = "Error getting email: \(err)"
                    print("Error getting documents: \(err)")
                } else {
                    if (!querySnapshot!.isEmpty){
                        withAnimation() {
                            verificated = true
                        }
                        errorMessage = ""
                    }
                    else{
                        withAnimation() {
                            verificated = false
                        }
                        errorMessage = "Takiego e-maila nie ma w bazie danych"
                    }
                }
        }
    }
    
}

struct VerificationView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        VerificationView()
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
