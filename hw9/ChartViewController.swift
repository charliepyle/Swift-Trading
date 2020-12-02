//
//  ChartViewController.swift
//  hw9
//
//  Created by Charlie Pyle on 12/2/20.
//

import SwiftUI
import UIKit
import WebKit
//
class ChartViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self

        let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Website")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
//
//struct WebView: UIViewRepresentable {
//    @Binding var title: String
//    var url: URL
//    var loadStatusChanged: ((Bool, Error?) -> Void)? = nil
//
//    func makeCoordinator() -> WebView.Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let view = WKWebView()
//        view.navigationDelegate = context.coordinator
//        view.load(URLRequest(url: url))
//        return view
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // you can access environment via context.environment here
//        // Note that this method will be called A LOT
//    }
//
//    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
//        var copy = self
//        copy.loadStatusChanged = perform
//        return copy
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        let parent: WebView
////        @IBOutlet weak var webView: WKWebView!
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
////        override func viewDidLoad() {
////            super.viewDidLoad()
////
////            webView.uiDelegate = self
////            webView.navigationDelegate = self
////
////            let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Website")!
////            webView.loadFileURL(url, allowingReadAccessTo: url)
////            let request = URLRequest(url: url)
////            webView.load(request)
////        }
//
//        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//            parent.loadStatusChanged?(true, nil)
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            parent.title = webView.title ?? ""
//            parent.loadStatusChanged?(false, nil)
//        }
//
//        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//            parent.loadStatusChanged?(false, error)
//        }
//    }
//}
//
//struct Display: View {
//    @State var title: String = "Test"
//    @State var error: Error? = nil
//
//    var body: some View {
//        NavigationView {
//            WebView(title: $title, url: URL(string: "https://www.apple.com/")!)
//                .onLoadStatusChanged { loading, error in
//                    if loading {
//                        print("Loading started")
//                        self.title = "Loading…"
//                    }
//                    else {
//                        print("Done loading.")
//                        if let error = error {
//                            self.error = error
//                            if self.title.isEmpty {
//                                self.title = "Error"
//                            }
//                        }
//                        else if self.title.isEmpty {
//                            self.title = "Some Place"
//                        }
//                    }
//            }
//            .navigationBarTitle(title)
//        }
//    }
//}
//
//struct ChartViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartViewController()
//    }
//}
