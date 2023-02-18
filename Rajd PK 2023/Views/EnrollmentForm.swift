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
    @AppStorage("loggedIn") var loggedIn = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)
            Form {
                Group{
                    Section(header: Text("Ogłoszenie:")){
                        FloatingTextField(title: "Tytuł", text: $title)
                        FloatingTextField(title: "Treść", text: $content)
                        FloatingTextField(title: "Link", text: $link)
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
        .onChange(of: loggedIn){ loggedIn in
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct EnrollmentFormContainer: View{
    @Binding var ifAdding: Bool
    var body: some View{
        if #available(iOS 16.0, *) {
            EnrollmentForm(ifAdding: $ifAdding)
                .scrollContentBackground(.hidden)
                .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
        } else {
            EnrollmentForm(ifAdding: $ifAdding)
                .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
        }
    }
}


struct EnrollmentForm_Previews: PreviewProvider {
    static var previews: some View {
        EnrollmentForm(ifAdding: .constant(true))
        MainView(loggedIn: .constant(true), email: .constant("sample@email.com"), password: .constant("password"))
            .previewDisplayName("MainView")
    }
}
