import SwiftUI

@main
struct RiviaHostApp: App {
    
    var body: some Scene {
        WindowGroup{
            HostContentView()
                .environmentObject(PeripheralManager())
                .environmentObject(Location())
        }.commands{
            SidebarCommands()
            EmptyCommands()
        }
    }
}
