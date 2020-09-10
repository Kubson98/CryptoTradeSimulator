//
//  CryptoTradeSimulatorUITests.swift
//  CryptoTradeSimulatorUITests
//
//  Created by Kuba on 10/09/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import XCTest

class CryptoTradeSimulatorUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
        
//        
//        let app = XCUIApplication()
//        app.launch()
//        app.textFields["E-mail"].tap()
//        
//        let moreKey = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"cyfry\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//        moreKey.tap()
//        //moreKey.tap()
//        
//        let key = app/*@START_MENU_TOKEN@*/.keys["2"]/*[[".keyboards.keys[\"2\"]",".keys[\"2\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key.tap()
//        //key.tap()
//        
//        let key2 = app/*@START_MENU_TOKEN@*/.keys["@"]/*[[".keyboards.keys[\"@\"]",".keys[\"@\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key2.tap()
//        //key2.tap()
//        key.tap()
//       // key.tap()
//        
//        let key3 = app/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key3.tap()
//       // key3.tap()
//        
//        let moreKey2 = app/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"litery\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//        moreKey2.tap()
//       // moreKey2.tap()
//        
//        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        pKey.tap()
//       // pKey.tap()
//        
//        let lKey = app/*@START_MENU_TOKEN@*/.keys["l"]/*[[".keyboards.keys[\"l\"]",".keys[\"l\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        lKey.tap()
//        //lKey.tap()
//        app.secureTextFields["Password"].tap()
//        moreKey.tap()
//        //moreKey.tap()
//        
//        let key4 = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key4.tap()
//        //key4.tap()
//        key.tap()
//       // key.tap()
//        
//        let key5 = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key5.tap()
//        //key5.tap()
//        
//        let key6 = app/*@START_MENU_TOKEN@*/.keys["4"]/*[[".keyboards.keys[\"4\"]",".keys[\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key6.tap()
//       // key6.tap()
//        
//        let key7 = app/*@START_MENU_TOKEN@*/.keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key7.tap()
//       // key7.tap()
//        
//        let key8 = app/*@START_MENU_TOKEN@*/.keys["6"]/*[[".keyboards.keys[\"6\"]",".keys[\"6\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        key8.tap()
//        
//        app.toolbars["Toolbar"].buttons["Done"].tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["Sign In"]/*[[".buttons[\"Sign In\"].staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//        let app = XCUIApplication()
//        app.textFields["E-mail"].tap()
//        app.secureTextFields["Password"].tap()
//        app.toolbars["Toolbar"].buttons["Done"].tap()
//        app/*@START_MENU_TOKEN@*/.staticTexts["Sign In"]/*[[".buttons[\"Sign In\"].staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        
//       // key8.tap()
//        //app/*@START_MENU_TOKEN@*/.staticTexts["Sign In"]/*[[".buttons[\"Sign In\"].staticTexts[\"Sign In\"]",".staticTexts[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//                
//        
//        

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
