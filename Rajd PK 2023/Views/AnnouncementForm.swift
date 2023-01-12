//
//  FormView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 14/12/2022.
//

import SwiftUI

struct AnnouncementForm: View {
    @State private var showSheet = false
    @State var showingAdvancedOptions = false
    @State private var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    @State var title: String = ""
    @State var subTitle: String = ""
    @State var content: String = ""
    @State var priority: Bool = false
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        Form {
            Section(header: Text("Ogłoszenie:")){
                TextField("Tytuł", text: $title)
                TextField("Podtytuł", text: $subTitle)
                if #available(iOS 16.0, *) {
                    TextField("Treść", text: $content, axis: .vertical)
                } else {
                    TextField("Treść", text: $content)
                }
                Toggle("Wyróżnione", isOn: $priority)
                    .onTapGesture {
                        hideKeyboard()
                    }
            }
            HStack{
                Button("Usuń zdjęcie"){
                    inputImage = nil
                }
                .foregroundColor(Color.red)
                Spacer()
                if(image == nil){
                    Button("Dodaj zdjęcie"){}
                        .onTapGesture {
                            hideKeyboard()
                            showingImagePicker = true
                        }
                }
                else{
                    Button("Zmień zdjęcie"){}
                        .onTapGesture {
                            hideKeyboard()
                            showingImagePicker = true
                        }
                }
            }
            if(image != nil){
                image?
                    .resizable()
                    .scaledToFit()
            }
            
            Toggle("Gotowe", isOn: $showingAdvancedOptions.animation())
                .onTapGesture {
                    hideKeyboard()
                }
                .disabled(!(!title.isEmpty && !subTitle.isEmpty && !content.isEmpty))
            if showingAdvancedOptions{
                
                if #available(iOS 15.0, *) {
                    Button("Dodaj") {
                        showSheet.toggle()
                    }
                    .sheet(isPresented: $showSheet) {
                        AnnouncementDetailForm(showingAdvancedOptions: $showingAdvancedOptions, inputImage: $inputImage, title: $title, subTitle: $subTitle, content: $content, priority: $priority)
                    }
                } else {
                    NavigationLink(destination: AnnouncementDetailForm(showingAdvancedOptions: $showingAdvancedOptions, inputImage: $inputImage, title: $title, subTitle: $subTitle, content: $content, priority: $priority))
                    {
                        Button("Dodaj") {}
                    }
                }
            }
        }
        .gesture(DragGesture().onChanged{_ in hideKeyboard()})
        .onChange(of: inputImage) { _ in loadImage() }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .navigationTitle("Dodaj ogłoszenie")
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
    func loadImage() {
        guard let inputImage = inputImage else {
            image = nil
            return
        }
        image = Image(uiImage: inputImage)
    }
}

struct AnnouncementFormContainer: View{
    var body: some View{
        NavigationView{
            if #available(iOS 16.0, *) {
                AnnouncementForm()
                    .scrollContentBackground(.hidden)
                    .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
            } else {
                AnnouncementForm()
            }
        }
    }
}



#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        print("HIDE_KBRD")
    }
}
#endif

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        AnnouncementFormContainer()
    }
}
