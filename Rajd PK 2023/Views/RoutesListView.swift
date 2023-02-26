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
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.routes) {route in
                        if(!(route.title ?? "").isEmpty && !(route.hidden ?? true)) {
                            RoutesViewItem(loggedIn: $loggedIn, route: route)
                        }
                    }
                    .onChange(of: tabClicked){ clicked in
                        withAnimation{
                            proxy.scrollTo(viewModel.routes[0].id, anchor: .top)
                        }
                    }
                }
            }
            .padding()
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
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                            .scrollContentBackground(.hidden)
                    }
                    else if #available(iOS 15.0, *) {
                        RoutesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .refreshable {
                                print("ODSWIEŻONO")
                            }
                            .background(LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom))
                    } else {
                        RoutesList(loggedIn: $loggedIn, tabClicked: $tabClicked)
                            .onAppear() {
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
            RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))
            VStack{
                if(!tapped){
                    HStack{
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(route.title!)")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                        }
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                }
                else{
                    HStack{
                        Spacer()
                        VStack(alignment: .center) {
                            Text("\(route.title!)")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        Image(systemName: "chevron.up")
                    }
                    .padding(.bottom, 1.0)
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
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.1)) {
                tapped.toggle()
            }
        }
        .padding()
        .padding(.vertical, 5.0)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color("FieldColor"))        .padding(.horizontal, 7.0)
            .padding(.vertical, 4.0))
    }
}

struct RoutesListView_Previews: PreviewProvider {
    static let viewModel = FirebaseViewModel()
    static var previews: some View {
        RoutesListView(loggedIn: .constant(true), tabClicked: .constant(true))
            .environmentObject(viewModel)
    }
}
