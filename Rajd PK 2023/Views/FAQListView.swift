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
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.FAQs) {faq in
                        if(!(faq.question ?? "").isEmpty && !(faq.answer ?? "").isEmpty) {
                            FAQViewItem(loggedIn: $loggedIn, faq: faq)
                        }
                    }
                    .onChange(of: tabClicked){ clicked in
                        withAnimation{
                            proxy.scrollTo(viewModel.FAQs[0].id, anchor: .top)
                        }
                    }
                }
                .padding()
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
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        FAQList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        FAQList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
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
            RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))
            VStack {
                if (!tapped){
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
                }
                else{
                    HStack {
                        Spacer()
                        Text("\(faq.question!):")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .lineLimit(nil)
                            .padding(.bottom, 1.0)
                        Spacer()
                        Image(systemName: "chevron.up")
                    }
                    
                    Text("\(faq.answer!)")
                        .font(.title3)
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.1)) {
                tapped.toggle()
            }
        }
        .padding()
        .padding(.vertical, 5.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))        .padding(.horizontal, 7.0)
            .padding(.vertical, 3))
    }
}


struct FAQListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        FAQListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
            .onAppear{
                viewModel.fetchData()
            }
    }
}
