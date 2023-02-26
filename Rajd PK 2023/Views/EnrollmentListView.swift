//
//  EnrollmentListView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 10/02/2023.
//

import SwiftUI

struct EnrollmentList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @State private var chosenDelete = false
    @State private var enrollmentToDeleteID = ""
    @Binding var tabClicked: Bool
    
    var body: some View{
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.enrollments) { enrollment in
                        if(!(enrollment.link ?? "").isEmpty && !(enrollment.title ?? "").isEmpty && !(enrollment.hidden ?? true)) {
                            let dateArr = enrollment.date?.components(separatedBy: " ")
                            EnrollmentViewItem(loggedIn: $loggedIn, enrollment: enrollment, dateArr: dateArr)
                                .contextMenu {
                                    if (loggedIn){
                                        if #available(iOS 15.0, *) {
                                            Button(role: .destructive) {
                                                chosenDelete = true
                                                enrollmentToDeleteID = enrollment.id ?? ""
                                            } label: {
                                                Label("Usuń", systemImage: "trash.fill")
                                            }
                                        } else {
                                            Button() {
                                                chosenDelete = true
                                                enrollmentToDeleteID = enrollment.id ?? ""
                                            } label: {
                                                Label("Usuń", systemImage: "trash.fill")
                                            }
                                        }
                                    }
                                }
                        }
                    }
                    .onChange(of: tabClicked){ clicked in
                        withAnimation{
                            proxy.scrollTo(viewModel.enrollments[0].id, anchor: .bottom)
                        }
                    }
                    .actionSheet(isPresented: $chosenDelete) {
                        ActionSheet(
                            title: Text("Czy na pewno chcesz usunąć te zapisy?"),
                            buttons: [
                                .destructive(Text("Usuń")) {
                                    self.viewModel.hideEnrollment(id: enrollmentToDeleteID )
                                    chosenDelete = false
                                },
                                .default(Text("Anuluj")) {
                                    chosenDelete = false
                                },
                            ]
                        )
                    }
                }
                .padding(.all)
            }
        }
    }
}

struct EnrollmentListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @ObservedObject var activeEnrollment = ActiveEnrollment.shared
    @State var ifAdding = false
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    NavigationLink(destination: EnrollmentFormContainer(ifAdding: $ifAdding), isActive: $ifAdding) {
                        EmptyView()
                    }
                    if #available(iOS 16.0, *) {
                        EnrollmentList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        EnrollmentList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        EnrollmentList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Zapisy")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing){
                        if (loggedIn){
                            Button(action: {
                                ifAdding = true
                            }, label: {
                                Image("plus-icon")
                            })
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack {
                            Text("")
                            NavigationLink(destination: SignInView()){
                                Image("login-icon")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct EnrollmentViewItem: View {
    
    @Binding var loggedIn: Bool
    let enrollment: Enrollment
    let dateArr: [String]?
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))
            HStack {
                VStack(alignment: .leading) {
                    Group{
                        HStack {
                            VStack {
                                Text(enrollment.title!)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            Spacer()
                            VStack {
                                Text(dateArr?[0] ?? "")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Text(dateArr?[1] ?? "")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            
                        }
                        if (enrollment.content != ""){
                            Text(enrollment.content!)
                                .fontWeight(.medium)
                        }
                        LinkView(link: (enrollment.link ?? ""), text: "Link do formularza")
                    }
                }
                Spacer()
            }
        }
        .padding()
        .padding(.vertical, 5.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))        .padding(.horizontal, 7.0)
            .padding(.vertical, 4.0))
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        EnrollmentListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
        ContentView()
            .previewDisplayName(/*@START_MENU_TOKEN@*/"ContentView"/*@END_MENU_TOKEN@*/)
    }
}
