import SwiftUI

struct LayoutModifier: ViewModifier {
    @State var axis:Axis
    
    func body(content: Content) -> some View {
        Group {
            if axis == .horizontal {
                HStack{ content }
            } else if axis == .vertical {
                VStack{ content }
            }
        }
    }
}

extension View {
    func layout(along axis:Axis) -> some View {
        self.modifier(LayoutModifier(axis:axis))
    }
}


struct HingeModifier: ViewModifier {
    var degrees:Double = 0
    var edge:Edge = .top
    
    var yA:CGFloat {
        edge == .bottom ? 1 : edge == .top ? 0 : 0.5
    }
    
    var xA:CGFloat {
        edge == .leading ? 0 : edge == .trailing ? 1 : 0.5
    }
    
    var axis:(CGFloat,CGFloat,CGFloat) {
        edge == .top || edge == .bottom ? (1,0,0) : (0,1,0)
    }
    
    var normalizedDeg:Double {
        edge == .leading || edge == .bottom ? degrees * -1 : degrees
    }
    
    func body(content: Content) -> some View {
        content.rotation3DEffect(
            Angle(degrees: normalizedDeg),
            axis: axis,
            anchor: UnitPoint(x: xA, y: yA),
            anchorZ: 0,
            perspective: -1
        )
    }
}

extension AnyTransition {
    static func hinge(_ edge:Edge) -> AnyTransition {
        AnyTransition.modifier(
            active: HingeModifier(degrees: 90, edge: edge),
            identity: HingeModifier(edge: edge)
        ).combined(with: .opacity)
    }
}
