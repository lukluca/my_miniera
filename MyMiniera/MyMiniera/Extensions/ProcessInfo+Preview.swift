//
//  ProcessInfo+Preview.swift
//  MyMiniera
//
//  Created by lukluca on 31/03/24.
//

import Foundation

extension ProcessInfo {
    static func isOnPreview() -> Bool {
        return processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
