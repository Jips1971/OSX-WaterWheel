import SwiftUI

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        
        
        .onAppear {
            DispatchQueue.main.async {
                NSApplication.shared.windows.first?.toggleFullScreen(nil)
            }   }
        }
    }
}
