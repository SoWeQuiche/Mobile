//
//  ScannerView.swift
//  SoWeQuiches
//
//  Created by Zakarya TOLBA on 08/03/2022.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    @EnvironmentObject private var deepLinkManager: DeepLinkManager
    @Environment(\.colorScheme) private var colorScheme
    @State private var showAlert: Bool = false

    var foundQrCode: (DeepLinkManager.DeepLink) -> ()
    
    var body: some View {
        ZStack {
            CodeScannerView(codeTypes: [.qr], scanMode: .continuous, completion: onFoundQrCode(result:))
                .ignoresSafeArea()
            
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
                    .background(Blur(style: .systemUltraThinMaterial))
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Une erreur est survenue"),
                message: Text("Veuillez scanner un QR Code compatible"),
                dismissButton: .default(Text("Réessayer"), action: {})
            )
        }
        
    }

    func onFoundQrCode(result: Result<ScanResult, ScanError>) {
        guard case let .success(scanResult) = result,
              let url = URL(string: scanResult.string) else { return }

        let deepLink = DeepLinkManager.DeepLink.from(url)

        if case .sign(timeslotId: _, code: _) = deepLink {
            foundQrCode(deepLink)
        }
    }
}

