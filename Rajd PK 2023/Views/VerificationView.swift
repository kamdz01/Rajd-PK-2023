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
                .onTapGesture {
                    hideKeyboard()
                }
            VStack(spacing: 15){
                Text("W celu weryfikacji podaj e-mail, na który został zakupiony bilet.")
                    .font(.title2)
                TextField("Email", text: $verificationEmail)
                    .MainTextField()
                Button(action: {
                    hideKeyboard()
                    findEmail(email: verificationEmail)
                }) {
                    Text("Zaloguj")
                        .MainButtonBold()
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
        ContentView()
    }
}
