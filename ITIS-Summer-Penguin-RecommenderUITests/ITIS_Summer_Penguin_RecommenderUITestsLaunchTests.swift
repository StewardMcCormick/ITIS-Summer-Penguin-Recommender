//
//  ITIS_Summer_Penguin_RecommenderUITestsLaunchTests.swift
//  ITIS-Summer-Penguin-RecommenderUITests
//
//  Created by Егор Бессонов on 04.07.2026.
//

import XCTest

final class ITIS_Summer_Penguin_RecommenderUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
