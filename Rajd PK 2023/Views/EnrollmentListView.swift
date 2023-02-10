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
    
    var body: some View{
        List(viewModel.enrollments) { enrollment in
            if(!(enrollment.link ?? "").isEmpty && !(enrollment.title ?? "").isEmpty) {
                let dateArr = enrollment.date?.components(separatedBy: " ")
                if #available(iOS 15.0, *) {
                    EnrollmentViewItem(loggedIn: $loggedIn, enrollment: enrollment, dateArr: dateArr)
                        .listRowSeparator(.hidden)
                } else {
                    EnrollmentViewItem(loggedIn: $loggedIn, enrollment: enrollment, dateArr: dateArr)
                }
            }
        }
    }
}

struct EnrollmentListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        EnrollmentList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        EnrollmentList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        EnrollmentList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Zapisy")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct EnrollmentViewItem: View {
    
    @Binding var loggedIn: Bool
    let enrollment: Enrollment
    let dateArr: [String]?
    var body: some View {
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
                            Link(destination: URL(string: enrollment.link ?? "")!, label: {
                                Text("Link do formularza")
                                    .underline()
                                    .fontWeight(.medium)
                            })
                        }
                }
                Spacer()
            }
        .padding(.vertical, 5.0)
        .padding(.horizontal, -7.0)
        .padding(7.0)
        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
    }
}

struct EnrollmentListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        EnrollmentListView(loggedIn: .constant(true))
            .environmentObject(viewModel)
        ContentView()
            .previewDisplayName(/*@START_MENU_TOKEN@*/"ContentView"/*@END_MENU_TOKEN@*/)
    }
}
