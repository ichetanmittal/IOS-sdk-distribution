import XCTest
@testable import IOSDeepLinkSDK

final class IOSDeepLinkSDKTests: XCTestCase {
    func testInitialUrl() {
        let url = IOSDeepLinkSDK.shared.getHostedWebUrl().absoluteString
        XCTAssertEqual(url, "https://test-sdk-ios-xaults.netlify.app/")
    }
    
    func testCustomUrl() {
        let customUrl = URL(string: "https://example.com")!
        IOSDeepLinkSDK.shared.configure(webUrl: customUrl)
        
        let url = IOSDeepLinkSDK.shared.getHostedWebUrl()
        XCTAssertEqual(url, customUrl)
    }
}
