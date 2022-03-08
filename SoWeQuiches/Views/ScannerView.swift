//
//  ScannerView.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 08/03/2022.
//

import SwiftUI

struct ScannerView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var showAlert: Bool = false
//    @EnvironmentObject var viewRouter: ViewRouter
    @ObservedObject var viewModel = ScannerViewModel()
    @ObservedObject var qrCodeViewModel = QrCodeScannerViewModel()
    @ObservedObject var applicationState: ApplicationState = ApplicationState.shared
    
    func tapticSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func tapticFail() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    var body: some View {
        ZStack {
            QrCodeScannerView()
            .found(r: self.viewModel.onFoundQrCode)
            .torchLight(isOn: self.viewModel.torchIsOn)
            .interval(delay: self.viewModel.scanInterval)
            
            VStack {
                VStack {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("Veuillez scanner un code QR")
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .font(.subheadline).bold()
                    }
                    .padding()
                    .foregroundColor(.black)
                    .background(colorScheme == .dark ? .black : .white)
                    .cornerRadius(.greatestFiniteMagnitude)
                }
                .padding(.top, 60)
                Rectangle()
                    .foregroundColor(.clear)
                    .overlay(
                        Image(systemName: "viewfinder")
                            .font(.system(size: 300, weight: .ultraLight))
                            .foregroundColor(Color(UIColor(red: 240/255, green: 188/255, blue: 2/255, alpha: 100)))
                    )
                Spacer()
            }.padding(.bottom, 35)
        }
        .onChange(of: self.viewModel.lastQrCode) { (_) in
            print("qrCode change: ", self.viewModel.lastQrCode)

//            let result = self.viewModel.lastQrCode.components(separatedBy: ", ")
//            let scannedRestaurant = RestaurantDTO(_id: result[0], name: result[1])
            
//          TODO: Handle QR codes passing the regex but not sending back data from the API
//            if (self.viewModel.lastQrCode.range(of: #"^(\w{24}), [a-zA-Z0-9_ ]*"#,
//                                options: .regularExpression) != nil){
                
//                viewRouter.restaurant = scannedRestaurant
                
//                if (applicationState.state == .authenticated) {
//                    self.viewModel.addRestaurantToHistory(inputRestaurant: scannedRestaurant)
//                }
                
//                self.viewRouter.currentPage = "greetingcard.fill"
                tapticSuccess()
//            } else {
//                tapticFail()
                self.showAlert = true
//            }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(self.viewModel.lastQrCode),
                message: Text(""),
                dismissButton: .default(Text("Ok"), action: {
//                    self.viewRouter.currentPage = ""
                    DispatchQueue.main.async {
                        self.viewModel.lastQrCode = ""
//                        withAnimation { self.viewRouter.currentPage = "qrcode.viewfinder" }
                    }
                }))
        }
    }
}

