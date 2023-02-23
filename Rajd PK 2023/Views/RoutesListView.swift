//
//  RoutesView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 17/02/2023.
//

import SwiftUI

struct RoutesList: View{
    
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View{
        ScrollViewReader { proxy in
            List(viewModel.routes) { route in
                if(!(route.title ?? "").isEmpty && !(route.hidden ?? true)) {
                    if #available(iOS 15.0, *) {
                        RoutesViewItem(loggedIn: $loggedIn, route: route)
                            .listRowSeparator(.hidden)
                    } else {
                        RoutesViewItem(loggedIn: $loggedIn, route: route)
                            .listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor")).padding(7.0))
                    }
                }
            }
            .onChange(of: tabClicked){ clicked in
                withAnimation{
                    proxy.scrollTo(viewModel.routes[0].id, anchor: .top)
                }
            }
        }
    }
}

struct RoutesListView: View {
    @Binding var loggedIn: Bool
    @EnvironmentObject var viewModel: FirebaseViewModel
    @Binding var tabClicked: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            NavigationView {
                VStack {
                    if #available(iOS 16.0, *) {
                        RoutesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
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
                        RoutesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                self.viewModel.fetchData()
                            }
                            .refreshable {
                                self.viewModel.fetchData()
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        RoutesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
                                self.viewModel.fetchData()
                                UITableView.appearance().backgroundColor = UIColor.clear
                                UITableViewCell.appearance().backgroundColor = UIColor.clear
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    }
                }
                .navigationTitle("Trasy")
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

struct RoutesViewItem: View {
    
    @Binding var loggedIn: Bool
    let route: Route
    @State var tapped = false
    
    var body: some View {
        ZStack{
            Button(action: {
                withAnimation(.easeOut) {
                    tapped.toggle()
                }
            }) {}
            VStack{
                if(!tapped){
                    HStack{
                        VStack(alignment: .center) {
                            Text("\(route.title!)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .padding(.bottom, 1.0)
                        }
                    }
                }
                else{
                    HStack{
                        VStack(alignment: .center) {
                            Text("\(route.title!)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 1.0)
                        }
                    }
                    VStack{
                        
                        if ((route.image ?? "") != ""){
                            FirebaseImage(path: "routes/", imageID: .constant("\(route.image!)"))
                        }
                        Text("\(route.content!)")
                            .padding(.bottom, 1.0)
                        
                        LinkView(link: route.link ?? "", text: "Link do trasy")
                    }
                    .transition(.scale.animation(.easeOut(duration: 0.1)))
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

struct RoutesListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        RoutesListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
    }
}
