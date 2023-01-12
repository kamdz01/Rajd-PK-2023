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
    @State var isLoading = false
    @State var ifError = false
    @State var imageID: String
    @State private var imageURL = URL(string: "")
    @State var image = UIImage()
    
    var body: some View {
        ZStack{
            if (!ifError){
                Image(uiImage: image)
                    .resizable()
                    //.frame(maxHeight: 450)
                    .scaledToFit()
                    .id(image)
                    .transition(.scale.animation(.easeOut(duration: 0.08)))
                    
            }
            else{
                Text("Błąd podczas ładowania obrazka")
            }
            if (isLoading)
            {
                ProgressView()
            }
        }
        .onAppear(perform: loadImageToMem)
    }
    
    ///////////////////////////////////////////////////////////////THIS ONE IS NOT USED RN
    func loadImageFromFirebase(){
        self.isLoading = true
        let storage = Storage.storage().reference(withPath: "images/\(imageID)")
        storage.downloadURL { (url, error) in
            if error != nil {
                print((error?.localizedDescription)!)
                isLoading = false
                ifError = true
                return
            }
            print("Download success")
            self.imageURL = url!
            isLoading = false
            return
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func loadImageToMem(){
        self.isLoading = true
        let storage = Storage.storage().reference(withPath: "images/\(imageID)")
        storage.getData(maxSize: ((2048 * 2048) as Int64) ) { data, error in
            if error != nil {
                isLoading = false
                ifError = true
                return
            }
            image = UIImage(data: data!)!
            isLoading = false
            print("Download success")
            return
        }
    }
}

struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(imageID: "N2_t.png")
    }
}
