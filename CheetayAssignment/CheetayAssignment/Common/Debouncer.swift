//
//  Debouncer.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
class Debouncer {
    private let interval: TimeInterval
    private var timer: Timer?

    init(interval: TimeInterval) {
        self.interval = interval
    }

    func debounce(action: @escaping (() -> Void)) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            action()
        }
    }
}
