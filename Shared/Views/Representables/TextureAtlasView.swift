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
        self.control.listen{ l in
            n.set(percent: l.percent, animated: l.animated, completion: l.completion)
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
    
    struct Config {
        var percent: CGFloat = 0
        var animated = false
        var completion: () -> Void = {}
    }
    
    private var listener: (Config) -> Void = { _ in }
    
    func set(percent complete: CGFloat, animated: Bool = false, completion: @escaping () -> Void = {}){
        listener(Config(percent: complete, animated: animated, completion: completion))
    }
    
    fileprivate func listen(_ c: @escaping (Config) -> Void) {
        self.listener = c
    }
}
