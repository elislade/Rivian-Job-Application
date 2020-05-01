import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {}){
                    Image(systemName: "info.circle")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                Spacer()
                Image("rivian")
                Spacer()
                Button(action: {}){
                    Image(systemName: "car.fill")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
            }
            .padding(.horizontal)
            .frame(height: 56)
        }
        .overlay(Divider(), alignment: .bottom)
        .foregroundColor(Color("riv_blue"))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
