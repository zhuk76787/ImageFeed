//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 5/8/24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var buttonAction: (() -> Void)?
}
