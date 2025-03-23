//
//  KikurageUITestsLaunchTests.swift
//  KikurageUITests
//
//  Created by Shusuke Ota on 2022/2/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import XCTest

class AppLaunchTests: XCTestCase {

    private let launchCount = 5

    /// If this property is true, run testing  for each languages and device orientations.
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()

        for i in 1...launchCount {
            app.launch()

            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 5), "App didn't launch successfully on attempt \(i)")

            let topPage = TopPage()
            XCTAssertTrue(topPage.exists, "Top page title is not found on attempt \(i)")

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "Launch Screen"
            attachment.lifetime = .keepAlways
            add(attachment)

            app.terminate()
        }
    }
}
