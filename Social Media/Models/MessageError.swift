//
//  MessageError.swift
//  Social Media
//
//  Created by Mostafa Elshazly on 11/30/19.
//  Copyright © 2019 Mostafa Elshazly. All rights reserved.
//

import Foundation

public enum MessagesError: Error {
    case noMessages
}

extension MessagesError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noMessages:
            return NSLocalizedString("No Messages to show", comment: "Custom error to show when there is no messages between two users")
        }
    }
}
