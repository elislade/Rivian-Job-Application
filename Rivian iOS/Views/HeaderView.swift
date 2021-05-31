import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Image("logo")
            Spacer()
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
