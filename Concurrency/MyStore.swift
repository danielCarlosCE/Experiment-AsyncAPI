//
//  MyStore.swift
//  Concurrency
//
//  Created by Daniel Souza on 08.08.22.
//

import Foundation

protocol Dependency {
    func update() async
}

class MyStore {

    let dependecy: Dependency
    var state = 0

    init(dependecy: Dependency) {
        self.dependecy = dependecy
    }

    func startFlow() async {
        state = 1
        Task {
            await dependecy.update()
            state = 2
        }
    }
}
