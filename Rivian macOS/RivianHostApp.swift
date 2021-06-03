import SwiftUI

@main
struct RiviaHostApp: App {
    
    var body: some Scene {
        WindowGroup{
            HostContentView().environmentObject(Location())
        }
        //.windowStyle(HiddenTitleBarWindowStyle())
        .commands{
            SidebarCommands()
            EmptyCommands()
        }
    }
}
