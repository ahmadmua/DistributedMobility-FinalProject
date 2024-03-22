//
//  AppError.swift
//  ShopTillYouDrop
//
//  Created by Muaz on 2024-03-22.
//

import Amplify
import Foundation
enum AppError: Error {
    case amplify(AmplifyError)
}
