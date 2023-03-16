//
//  AskForPermNotifView.swift
//  Rajd PK 2023
//
//  Created by Kamil Dziedzic on 16/03/2023.
//

import SwiftUI

struct AskForPermNotifView: View {
    
    @State var NotificationsOK = 0
    @State var chosenNotToAsk = false
    @Binding var showNotificationDialog: Bool
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color("TabColor"), Color("BGBot")], startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all)
            VStack{
                if (NotificationsOK == 0){
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Prosimy, włącz powiadomienia w ustawieniach aplikacji. To pozwoli Ci być na bieżąco z wszystkimi ogłoszeniami.")
                        .font(.title3)
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        if #available(iOS 15.0, *) {
                            Text("Chcę powiadomienia!")
                                .bold()
                                .frame(width: 360, height: 50)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                        } else {
                            Text("Chcę powiadomienia!")
                                .bold()
                                .padding()
                                .frame(width: 360, height: 50)
                                .background(Color("FieldColor"))
                                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                        }
                    }
                    Button(action: {
                        chosenNotToAsk.toggle()
                    }) {
                        if #available(iOS 15.0, *) {
                            Text("Nie chcę, nie pytaj więcej")
                                .bold()
                                .frame(width: 360, height: 50)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                        } else {
                            Text("Nie chcę, nie pytaj więcej")
                                .bold()
                                .padding()
                                .frame(width: 360, height: 50)
                                .background(Color("FieldColor"))
                                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.red)
                        }
                    }
                    .actionSheet(isPresented: $chosenNotToAsk) {
                        ActionSheet(
                            title: Text("Czy na pewno Nie chcesz otrzymywać powiadomień z tej aplikacji?"),
                            buttons: [
                                .destructive(Text("Nie chcę")) {
                                    @AppStorage("notificationAskCnt") var notificationAskCnt = 0
                                    notificationAskCnt = -1
                                    NotificationsOK = 2
                                },
                                .default(Text("Anuluj")) {
                                    chosenNotToAsk = false
                                },
                            ]
                        )
                    }
                    Button(action: {
                        showNotificationDialog.toggle()
                    }) {
                        if #available(iOS 15.0, *) {
                            Text("Nie chcę")
                                .bold()
                                .frame(width: 360, height: 50)
                                .background(.thinMaterial)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                        } else {
                            Text("Nie chcę")
                                .bold()
                                .padding()
                                .frame(width: 360, height: 50)
                                .background(Color("FieldColor"))
                                .cornerRadius(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                else if (NotificationsOK == 1){
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(Color.green)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Dziękujemy za włączenie powiadomień!")
                        .font(.title3)
                }
                else {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.red)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .frame(width: 150.0, height: 150.0)
                    Text("Przykro nam, że nie chcesz otrzymywać powiadomień. Pamiętaj, że w każdej chwili możesz to zmienić w ustawieniach aplikacji.")
                        .font(.title3)
                }
            }
            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)

            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let center = UNUserNotificationCenter.current()
                    center.getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            return
                        }
                        NotificationsOK = 1
                    }
                }
            }
        }
    }
}

struct AskForPermNotifView_Previews: PreviewProvider {
    static var previews: some View {
        AskForPermNotifView(showNotificationDialog: .constant(true))
    }
}
