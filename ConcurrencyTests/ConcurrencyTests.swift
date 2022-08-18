//
//  ConcurrencyTests.swift
//  ConcurrencyTests
//
//  Created by Daniel Souza on 08.08.22.
//

import XCTest
@testable import Concurrency

class ConcurrencyTests: XCTestCase {

    var sut: MyStore!
    var mock: DependecyMock!

    override func setUp() async throws {
        mock = .init()
        sut = .init(dependecy: mock)
        self.continueAfterFailure = false
    }

    func test_startFlows_usingTaskSleep_changesStateTo2Eventually() async throws {
        await sut.startFlow()

        //this suspends the testing task and gives time for the Store's task to run
        try await Task.sleep(nanoseconds: NSEC_PER_MSEC * 100)

        XCTAssertEqual(sut.state, 2)
    }

    func test_startFlows_usingExpectations_changesStateTo2Eventually() async {
        let expectation = XCTestExpectation(description: "mock called")
        mock.callBack = { expectation.fulfill() }

        await sut.startFlow()

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.state, 2)
    }

    func test_startFlows_usingNormalSleep_changesStateTo2Eventually() async {
        await sut.startFlow()
        sleep(1)
        XCTAssertEqual(sut.state, 2)
    }

}

class DependecyMock: Dependency {
    var callBack: (() -> Void)?
    func update() async {
        callBack?()
    }
}
