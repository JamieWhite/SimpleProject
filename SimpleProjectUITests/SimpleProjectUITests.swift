import XCTest

@testable import SimpleProject

final class SimpleProjectUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        let path = Bundle(for: SimpleProjectUITests.self).path(forResource: "StubbedProducts", ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["stubbedProducts"] = String(data: jsonData, encoding: .utf8)
        app.launch()
    }

    func testCanSelectRow() throws {
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Borsao Macabeo"]/*[[".cells[\"Borsao Macabeo\"].staticTexts[\"Borsao Macabeo\"]",".staticTexts[\"Borsao Macabeo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssert(app.scrollViews.otherElements.staticTexts["Borsao Macabeo"].exists)
                
    }
    
}
