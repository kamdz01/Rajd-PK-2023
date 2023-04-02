//
//  EnrollmentForm.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 13/02/2023.
//

import SwiftUI

struct EnrollmentForm: View {
    @State private var showSheet = false
    @State var showingAdvancedOptions = false
    @State var title: String = ""
    @State var content: String = ""
    @State var link: String = ""
    @State var sendNotification: Bool = true
    @Binding var ifAdding: Bool
    @State var urlOK = true
    @AppStorage("loggedIn") var loggedIn = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            Form {
                Group{
                    Section(header: Text("Zapisy:")){
                        FloatingTextField(title: "Tytuł", text: $title)
                        FloatingTextField(title: "Treść", text: $content)
                        FloatingTextField(title: "Link", text: $link)
                            .onChange(of: link){link in
                                urlOK = validateURL(url: link)
                            }
                        if(!urlOK){
                            Text("Błędny adres strony internetowej")
                                .foregroundColor(.red)
                        }
                        Toggle("Wyślij z powiadomieniem", isOn: $sendNotification)
                            .onTapGesture {
                                hideKeyboard()
                            }
                    }
                    Toggle("Gotowe", isOn: $showingAdvancedOptions.animation())
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .disabled(!(!title.isEmpty && !link.isEmpty && !content.isEmpty))
                    if showingAdvancedOptions{
                        
                        Button("Dodaj") {
                            showSheet.toggle()
                        }
                        .sheet(isPresented: $showSheet) {
                            EnrollmentDetailForm(showingAdvancedOptions: $showingAdvancedOptions, title: $title, content: $content, link: $link, sendNotification: $sendNotification)
                        }
                    }
                }
                .listRowBackground(Color("FieldColor"))
            }
            .gesture(DragGesture().onChanged{_ in hideKeyboard()})
            .onChange(of: showSheet) { newValue in
                if(showingAdvancedOptions == false){
                    ifAdding = newValue
                }
            }
            .navigationTitle("Dodaj zapisy")
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
    }
}


struct EnrollmentFormContainer: View{
    @Binding var ifAdding: Bool
    @AppStorage("loggedIn") var loggedIn = false
    
    var body: some View{
        if(loggedIn){
            if #available(iOS 16.0, *) {
                EnrollmentForm(ifAdding: $ifAdding)
                    .scrollContentBackground(.hidden)
                    .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
            } else {
                EnrollmentForm(ifAdding: $ifAdding)
                    .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
            }
        }
        else{
            LogInErrorView()
        }
    }
}


struct EnrollmentForm_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        EnrollmentFormContainer(ifAdding: .constant(true), loggedIn: true)
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .previewDisplayName("MainView")
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
