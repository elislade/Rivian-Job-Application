import SwiftUI
import SpriteKit

struct AtlasTexture {
    
    let name: String
    let control: TextureControl
    
    func makeView() -> SKView {
        let scene = SKScene()
        scene.backgroundColor = .clear
        let n = AtlasSKNode(name: name)
        n.scale(to: scene.size)
        n.position = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(n)
        self.control.listen{ comp, anim in
            n.set(percent: comp, animated: anim)
        }
        
        let view = SKView()
        view.allowsTransparency = true
        view.presentScene(scene)
        return view
    }
    
    func updateView(_ view: SKView) { }
}

#if os(iOS)

extension AtlasTexture: UIViewRepresentable {
    typealias UIViewType = SKView
    
    func makeUIView(context: UIViewRepresentableContext<AtlasTexture>) -> SKView {
        makeView()
    }
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<AtlasTexture>) {
        updateView(uiView)
    }
}

#else

extension AtlasTexture: NSViewRepresentable {
    typealias NSViewType = SKView
    
    func makeNSView(context: NSViewRepresentableContext<AtlasTexture>) -> SKView {
        makeView()
    }
    
    func updateNSView(_ nsView: SKView, context: NSViewRepresentableContext<AtlasTexture>) {
        updateView(nsView)
    }
}

#endif


class TextureControl {
    private var listener: (CGFloat, Bool) -> Void = { _, _ in }
    
    func set(percent complete: CGFloat, animated: Bool = false){
        listener(complete, animated)
    }
    
    fileprivate func listen(_ c: @escaping (CGFloat, Bool) -> Void) {
        self.listener = c
    }
}
