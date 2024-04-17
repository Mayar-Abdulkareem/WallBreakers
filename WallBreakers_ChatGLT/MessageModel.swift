//
//  MessageModel.swift
//  WallBreakers
//
//  Created by ftsmobileteam on 16/04/2024.
//

import Foundation

struct ReceivedMessage: Codable {
    var answer: String
}

struct MessageModel: Identifiable, Codable {
    let id: String
    let message: String
    let isBotMessage: Bool
    let date: Date
}
