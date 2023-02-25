//
//  ContactsView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 15/12/2022.
//

import SwiftUI

struct FAQList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View{
        ScrollViewReader { proxy in
            List(viewModel.FAQs) { faq in
                if(!(faq.question ?? "").isEmpty && !(faq.answer ?? "").isEmpty) {
                    if #available(iOS 15.0, *) {
                        FAQViewItem(loggedIn: $loggedIn, faq: faq)
                            .listRowSeparator(.hidden)
                    } else {
                        FAQViewItem(loggedIn: $loggedIn, faq: faq)
                            .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .onChange(of: tabClicked){ clicked in
                withAnimation{
                    proxy.scrollTo(viewModel.FAQs[0].id, anchor: .top)
                }
            }
        }
    }
}

struct FAQListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        FAQList(loggedIn: $loggedIn, tabClicked: $tabClicked)
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
                        FAQList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        FAQList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                self.viewModel.fetchData()
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
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

struct FAQViewItem: View {
    
    @Binding var loggedIn: Bool
    let faq: FAQ
    @State var tapped = false
    var body: some View {
        ZStack{
            Button(action: {
                withAnimation(.easeOut) {
                    tapped.toggle()
                }
            }) {}
            VStack {
                if (!tapped){
                    Group{
                        HStack {
                            Spacer()
                            Text("\(faq.question!):")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                            .padding(.bottom, 1.0)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        
                        Text("\(faq.answer!)")
                            .font(.title3)
                            .lineLimit(2)
                            .transition(.scale.animation(.easeOut(duration: 0.1)))
                    }
                }
                else{
                    Group{
                        HStack {
                            Spacer()
                            Text("\(faq.question!):")
                                .font(.title2)
                                .fontWeight(.semibold)
                            .padding(.bottom, 1.0)
                            Spacer()
                            Image(systemName: "chevron.up")
                        }
                        
                        Text("\(faq.answer!)")
                            .font(.title3)
                            .transition(.scale.animation(.easeOut(duration: 0.1)))
                    }
                }
            }
        }
        .padding(.vertical, 5.0)
        .padding(.horizontal, -7.0)
        .padding(7.0)
        .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
    }
}


struct FAQListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        FAQListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
    }
}
