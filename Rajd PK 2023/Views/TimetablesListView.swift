//
//  TimetableView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI

struct TimetablesList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    
    var body: some View{
        List(viewModel.Timetables) { timetable in
            if(!(timetable.day ?? "").isEmpty) {
                if #available(iOS 15.0, *) {
                    TimetablesViewItem(loggedIn: $loggedIn, timetable: timetable)
                        .listRowSeparator(.hidden)
                } else {
                    TimetablesViewItem(loggedIn: $loggedIn, timetable: timetable)
                        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
                }
            }
        }
    }
}

struct TimetablesListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        TimetablesList(loggedIn: $loggedIn)
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
                        TimetablesList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        TimetablesList(loggedIn: $loggedIn)
                            .onAppear() {
                                self.viewModel.fetchData()
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Harmonogram")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        HStack {
                            Text("")
                            NavigationLink(destination: SignInView()){
                                Image(systemName: "person.crop.circle")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct TimetablesViewItem: View {
    
    @Binding var loggedIn: Bool
    let timetable: Timetable
    @State var tapped = false
    var body: some View {
        ZStack{
            Button(action: {
                withAnimation(.easeOut) {
                    tapped.toggle()
                }
            }) {}
            if(!tapped){
                HStack{
                    VStack(alignment: .center) {
                        Text("\(timetable.day!)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .padding(.bottom, 1.0)
                    }
                }
            }
            else{
                VStack{
                    HStack{
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(timetable.day!)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1.0)
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        if (timetable.name1 != nil && timetable.content1 != nil){
                            Text("\(timetable.name1!):")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("\(timetable.content1!)")
                        }
                        if (timetable.name2 != nil && timetable.content2 != nil){
                            Text("\(timetable.name2!):")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("\(timetable.content2!)")
                        }
                        if (timetable.name3 != nil && timetable.content3 != nil){
                            Text("\(timetable.name3!):")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("\(timetable.content3!)")
                        }
                    }
                }
            }
        }
        .padding(.vertical, 5.0)
        .padding(.horizontal, -7.0)
        .padding(7.0)
        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
        .background(Color(.init(srgbRed: 1, green: 1, blue: 1, alpha: 0)))
    }
}

struct TimetablesListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        TimetablesListView(loggedIn: .constant(true))
            .environmentObject(viewModel)
    }
}