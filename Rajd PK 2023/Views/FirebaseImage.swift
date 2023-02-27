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
    private let fileManager = LocalFileManager.instance
    
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
                if (nil != fileManager.getImage(imageName: imageID, folderName: "temp")){
                    image = fileManager.getImage(imageName: imageID, folderName: "temp")!
                    print ("Image already in storage")
                    ifShown = true
                }
                else{
                    loadImageToMem()
                    print ("Image Downloaded to storage")
                    ifShown = true
                }
            }
        }
        .onChange(of: imageID){ id in
            if (nil != fileManager.getImage(imageName: imageID, folderName: "temp")){
                image = fileManager.getImage(imageName: imageID, folderName: "temp")!
                print ("Image already in storage")
                ifShown = true
            }
            else{
                loadImageToMem()
                print ("Image Downloaded to storage")
                ifShown = true
            }
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
                print("Download fail")
                isLoading = false
                ifError = true
                return
            }
            if (data != nil){
                print("Download success")
                fileManager.saveImage(image: UIImage(data: data!)!, imageName: imageID, folderName: "temp")
                image = fileManager.getImage(imageName: imageID, folderName: "temp") ?? UIImage(data: data!) ?? UIImage()
                ifError = false
                isLoading = false
                return
            }
            else{
                print("Download fail")
                ifError = true
                isLoading = false
                return
            }
        }
    }
}

struct FirebaseImage_Previews : PreviewProvider {
    static var previews: some View {
        FirebaseImage(path: "", imageID: .constant("N2_t.png"))
    }
}
