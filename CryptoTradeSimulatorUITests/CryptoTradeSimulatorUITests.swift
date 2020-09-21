//
//  CryptoTradeSimulatorUITests.swift
//  CryptoTradeSimulatorUITests
//
//  Created by Kuba on 19/09/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import XCTest

class CryptoTradeSimulatorUITests: XCTestCase {

    func testUserLogin() throws {
         let app = XCUIApplication()
        let email = "2@2.pl"
        let password = "123456"
         app.launch()
        let emailTextField = app.textFields["E-mail"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(email)
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(password)
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Sign In"]/*[[".buttons[\"Sign In\"].staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let button = app.buttons.staticTexts["Get More $$$"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testUserRegister() throws {
        let app = XCUIApplication()
        let email = "test@test.com"
        let password = "123456"
        app.launch()
        app.staticTexts["Sign Up"].tap()
        let emailTextField = app.textFields["E-mail"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText(email)
        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText(password)
        let repeatPasswordTextField = app.secureTextFields["Repeat Password"]
        XCTAssertTrue(repeatPasswordTextField.exists)
        repeatPasswordTextField.tap()
        repeatPasswordTextField.typeText(password)
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["Register"].tap()
        let button = app.buttons.staticTexts["Get More $$$"]
        expectation(for: NSPredicate(format: "exists == 1"), evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
