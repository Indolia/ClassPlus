//
//  ClassPlusUITests.swift
//  ClassPlusUITests
//
//  Created by Rishi pal on 25/10/20.
//

import XCTest

class ClassPlusUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testLoginAsMember() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Member"].staticTexts["Member"].tap()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let nameField = elementsQuery.textFields["User Name"]
        nameField.tap()
        nameField.typeText("Indolia")
        nameField.typeText("\n")
        XCTAssertEqual(nameField.value as! String, "Indolia", "Name is right")
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("wiier")
        passwordSecureTextField.typeText("\n")
        elementsQuery.buttons["Submit"].tap()
       // app.navigationBars["Login"].buttons["Back"].tap()
        sleep(5)
    }
//
//    func testExample() throws {
//        // UI tests must launch the application that they test.
//        let app = XCUIApplication()
//        app.launch()
        
//       // let app = XCUIApplication()
//        app.buttons["Guest"].staticTexts["Guest"].tap()
//        app.buttons["Create New Employee"].staticTexts["Create New Employee"].tap()
//        app.tables/*@START_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"eve.holt@reqres.in")/*[[".cells.containing(.staticText, identifier:\"Eve Holt\")",".cells.containing(.staticText, identifier:\"eve.holt@reqres.in\")"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["more"].tap()
//        app.sheets.scrollViews.otherElements.buttons["Edit Details"].tap()
//
//        let homeButton = app.navigationBars["ClassPlus.CreateOrEditEmployeeView"].buttons["Home"]
//        homeButton.tap()
//        app.staticTexts["Create New Employee"].tap()
//        homeButton.tap()
//        app.navigationBars["Home"].buttons["Back"].tap()
//        app.buttons["Member"].tap()
//
//        let scrollViewsQuery = app.scrollViews
//        let elementsQuery = scrollViewsQuery.otherElements
//        elementsQuery.textFields["User Name"].tap()
//        scrollViewsQuery.children(matching: .other).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
//
//        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
//        passwordSecureTextField.tap()
//        passwordSecureTextField.tap()
//        elementsQuery.buttons["Submit"].tap()
//        app.navigationBars["Login"].buttons["Back"].tap()
//        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
   // }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
