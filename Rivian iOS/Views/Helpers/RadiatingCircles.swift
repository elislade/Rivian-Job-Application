import SwiftUI

struct RadiatingCicles: View  {
    
    var animTemp: Animation {
        Animation.easeOut(duration: 10).repeatForever(autoreverses: false)
    }
    
    @State private var anim = false
    
    var body: some View {
        ZStack {
            ForEach(0..<5){ i in
                Circle()
                    .frame(width: 10, height: 10)
                    .scaleEffect(anim ? 40 : 1)
                    .opacity(anim ? 0 : 1)
                    .animation(animTemp.delay(Double(i * 2)))
            }
        }.onAppear{
            anim.toggle()
        }
    }
}

struct PreviewRadiatingCircle: PreviewProvider {
    static var previews: some View {
        RadiatingCicles()
    }
}
