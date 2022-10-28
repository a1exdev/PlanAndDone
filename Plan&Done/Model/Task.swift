//
//  Task.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import Foundation

struct Task {
    let id = UUID()
    var title: String
    var description: String
    let datetimeCreation: String
    var datetimeDeadline: String
    var project: Project?
    var isDone: Bool
}
