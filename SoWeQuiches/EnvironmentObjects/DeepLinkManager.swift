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
        deepLink = .from(url)
    }

    func setDeepLink(_ deepLink: DeepLink) {
        self.deepLink = deepLink
    }

    func clear() {
        deepLink = .none
    }

    enum DeepLink: Equatable {
        case sign(timeslotId: String, code: String)
        case none

        static func from(_ url: URL?) -> DeepLink {
            guard let url = url else { return .none }

            let components = URLComponents(string: url.absoluteString)

            if url.path == "/sign",
               let timeslotId = components?.queryItems?.first(where: { $0.name == "timeslotId" })?.value,
               let code = components?.queryItems?.first(where: { $0.name == "code" })?.value {
                return .sign(timeslotId: timeslotId, code: code)
            } else {
                return .none
            }
        }
    }
}
