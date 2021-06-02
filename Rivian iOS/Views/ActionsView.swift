import SwiftUI

struct ActionsView: View {
    
    let actions: [Vehicle.Action]
    let perform: (Vehicle.Action) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(actions){ act in
                Button(action: { perform(act) }){
                    HStack {
                        Spacer(minLength: 0)
                        VStack(spacing: 10) {
                            act.image.font(Font.title.bold())
                            Text(act.description.uppercased())
                                .font(Font.caption.weight(.black))
                                .lineLimit(1)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(14)
                    .background(Color("riv_yellow"))
                    .cornerRadius(14)
                }
            }
        }.foregroundColor(Color("riv_blue"))
    }
}

struct PreviewActionsView: PreviewProvider {
    static var previews: some View {
        ActionsView(actions: Vehicle.Action.allCases, perform: { _ in })
    }
}
