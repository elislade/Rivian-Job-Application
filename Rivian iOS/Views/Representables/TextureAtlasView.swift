import SwiftUI
import SpriteKit

final class AtlasTexture {

    @State var complete = 0.0
    
    var textures:[SKTexture]
    var node = SKSpriteNode()
    
    let scene:SKScene
    
    init(_ name:String) {
        self.scene = SKScene()
        self.scene.backgroundColor = .clear
        let atlas = SKTextureAtlas(named:name)
        self.textures = atlas.textureNames.sorted().map {
            atlas.textureNamed($0)
        }
        
        // setup node
        node = SKSpriteNode(texture: textures[0])
        node.scale(to: scene.size)
        node.position = CGPoint(x: 0.5, y: 0.5)
        scene.addChild(node)
    }
    
    func setTextures(from atlas:SKTextureAtlas) {
        self.textures = atlas.textureNames.sorted().map {
            atlas.textureNamed($0)
        }
    }
    
    private var currentComplete:CGFloat = 1.0
    private var targetComplete:CGFloat = 0.0 {
        didSet {
            if targetComplete != currentComplete {
                if !isAnimating {
                    updateTexture()
                }
            }
        }
    }
    
    var isAnimating = false
    
    func updateTexture(isAnimated flag:Bool = true) {
        let currentFrame = index(from: textures, atPercent: currentComplete)
        let targetFrame = index(from: textures, atPercent: targetComplete)
        
        if flag {
            isAnimating = true
            let start = min(currentFrame, targetFrame)
            let end = max(currentFrame, targetFrame)
            let slice = textures[start..<end]
            let frames = targetFrame < currentFrame ? Array(slice).reversed() : Array(slice)
            node.run(SKAction.animate(with: frames, timePerFrame: 0.04), completion: {
                self.isAnimating = false
                self.currentComplete = self.targetComplete
            })
        } else {
            node.run(SKAction.setTexture(textures[targetFrame]), completion: {
                self.currentComplete = self.targetComplete
            })
        }
    }
    
    func index(from collection:[SKTexture], atPercent percent:CGFloat) -> Int {
        let percentFrame = (CGFloat(collection.count - 1) * percent)
        return Int(percentFrame)
    }
    
    var bindedComplete:Binding<CGFloat>{
        Binding<CGFloat>(get: {
            return self.currentComplete
        }, set: {
            self.targetComplete = $0
        })
    }
    
    func makeView() -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        view.presentScene(scene)
        targetComplete = 0
        return view
    }
    
    func updateView(_ view: SKView) {
        targetComplete = 0
    }
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
