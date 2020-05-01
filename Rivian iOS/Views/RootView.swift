import SwiftUI

struct RootView: View {
    
    func axis(from size:CGSize) -> Binding<Axis> {
        let a:Axis = size.width > size.height ? .horizontal : .vertical
        return .constant(a)
    }
    
    var body: some View {
        GeometryReader {
            ContentView(proxy: $0, axis: self.axis(from: $0.size))
        }.background(Color.white)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
