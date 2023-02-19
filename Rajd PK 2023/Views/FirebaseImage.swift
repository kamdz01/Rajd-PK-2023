//
//  ImageView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 20/12/2022.
//


import SwiftUI
import Combine
import FirebaseStorage

struct FirebaseImage : View {
    var path: String
    @State var isLoading = false
    @State var ifError = false
    @Binding var imageID: String
    @State private var imageURL = URL(string: "")
    @State var image = UIImage()
    @State var ifShown = false
    
    var body: some View {
        ZStack{
            if (!ifError){
                Image(uiImage: image)
                    .resizable()
                //.frame(maxHeight: 450)
                    .scaledToFit()
                    .id(image)
                    .transition(.scale.animation(.easeOut(duration: 0.15)))
                
            }
            else{
                Text("Błąd podczas ładowania obrazka")
            }
            if (isLoading)
            {
                ProgressView()
            }
        }
        .onAppear{
            if (!ifShown){
                loadImageToMem()
                ifShown = true
            }
        }
        .onChange(of: imageID){ id in
            loadImageToMem()
        }
    }
    
    func loadImageToMem(){
        if (isLoading){
            return
        }
        isLoading = true
        let storage = Storage.storage().reference(withPath: "\(path)\(imageID)")
        storage.getData(maxSize: ((2048 * 2048) as Int64) ) { data, error in
            if error != nil {
                isLoading = false
                ifError = true
                return
            }
            print("Download success")
            image = UIImage(data: data!)!
            ifError = false
            isLoading = false
            return
        }
    }
}

struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(path: "", imageID: .constant("N2_t.png"))
    }
}
