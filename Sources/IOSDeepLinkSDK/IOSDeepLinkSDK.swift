import SwiftUI
import WebKit

/// Main class to initialize and use the SDK
public class IOSDeepLinkSDK {
    /// The hosted web URL to load
    private static var hostedWebUrl: URL = URL(string: "https://test-sdk-ios-xaults.netlify.app/")!
    
    /// Singleton instance
    public static let shared = IOSDeepLinkSDK()
    
    private init() {}
    
    /// Configure the SDK with custom URL
    /// - Parameter webUrl: The hosted web URL to use
    public func configure(webUrl: URL) {
        IOSDeepLinkSDK.hostedWebUrl = webUrl
    }
    
    /// Returns the URL to be used by the WebView
    public func getHostedWebUrl() -> URL {
        return IOSDeepLinkSDK.hostedWebUrl
    }
    
    /// Creates a button that will open the SDK WebView when tapped
    /// - Parameters:
    ///   - label: The text to display on the button
    ///   - action: Additional action to perform when button is tapped (optional)
    /// - Returns: A button view that can be integrated into SwiftUI layouts
    public func createLaunchButton(label: String, action: (() -> Void)? = nil) -> some View {
        Button(label) {
            action?()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
    
    /// Returns a WebView that can be presented in your application
    /// - Parameter onNavigation: Callback for when navigation to a deep link occurs
    /// - Returns: A WebView that loads the hosted web content
    public func createWebView(onNavigation: @escaping (DeepLinkType) -> Void) -> some View {
        return SDKWebView(url: IOSDeepLinkSDK.hostedWebUrl, onNavigation: onNavigation)
    }
}

/// Types of deep links that can be handled by the SDK
public enum DeepLinkType {
    /// Navigation to the test page
    case test
    
    /// Unknown navigation type
    case unknown(url: URL)
}

/// WebView coordinator that handles navigation events
class SDKWebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: SDKWebView
    
    init(_ parent: SDKWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.absoluteString == "iosapp://test" {
                parent.onNavigation(.test)
                decisionHandler(.cancel)
                return
            } else if !url.absoluteString.hasPrefix("http") && !url.absoluteString.hasPrefix("https") {
                parent.onNavigation(.unknown(url: url))
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

/// WebView component that displays the hosted content
public struct SDKWebView: UIViewRepresentable {
    let url: URL
    let onNavigation: (DeepLinkType) -> Void
    
    public init(url: URL, onNavigation: @escaping (DeepLinkType) -> Void) {
        self.url = url
        self.onNavigation = onNavigation
    }
    
    public func makeCoordinator() -> SDKWebViewCoordinator {
        SDKWebViewCoordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

/// A view that handles navigation from the WebView to native screens
public struct SDKTestView: View {
    @Environment(\.dismiss) var dismiss
    let isFromWebView: Bool
    
    public init(isFromWebView: Bool) {
        self.isFromWebView = isFromWebView
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("iOS Test Page")
                    .font(.largeTitle)
                    .bold()
                
                Text(isFromWebView ? 
                    "Successfully navigated from WebView!" :
                    "Successfully navigated from Home Page!")
                    .font(.title2)
                
                Button("Go Back") {
                    dismiss()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .navigationBarItems(leading: Button("Close") {
                dismiss()
            })
        }
    }
}
