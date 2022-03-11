//
//  DeepLinkManager.swift
//  SoWeQuiches
//
//  Created by Maxence on 10/03/2022.
//

import Foundation

class DeepLinkManager: ObservableObject {
    @Published private(set) var deepLink: DeepLink = .none

    func getDeepLink(from url: URL?) {
        guard let url = url else { return }

        let components = URLComponents(string: url.absoluteString)

        if url.path == "/sign",
           let timeslotId = components?.queryItems?.first(where: { $0.name == "timeslotId" })?.value,
           let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
            deepLink = .sign(timeslotId: timeslotId, code: code)
        } else {
            deepLink = .none
        }
    }

    func clear() {
        deepLink = .none
    }

    enum DeepLink: Equatable {
        case sign(timeslotId: String, code: String)
        case none
    }
}
