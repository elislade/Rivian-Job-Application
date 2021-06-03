import Foundation
import SpriteKit

class AtlasSKNode: SKSpriteNode {
    
    private let atlas: SKTextureAtlas
    private var currentComplete: CGFloat = 0
    private var isAnimating = false
    
    init(name: String) {
        self.atlas = SKTextureAtlas(named: name)
        self.atlas.preload {}
        //let t = self.atlas.textureNamed(self.atlas.textureNames[0])
        super.init(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
        self.set(percent: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.atlas = SKTextureAtlas()
        super.init(coder: aDecoder)
    }
    
    func set(percent complete: CGFloat, animated: Bool = false, completion: @escaping () -> Void = {}) {
        if isAnimating || atlas.textureNames.isEmpty { return }
        
        let start = index(for: currentComplete)
        let end = index(for: complete)
        if animated {
            isAnimating = true
            
            var textures: [SKTexture] =  []
            for i in min(start, end)..<max(end, start) {
                textures.append(atlas.textureNamed(atlas.textureNames.sorted()[i]))
            }
            
            var action = SKAction.animate(with: textures, timePerFrame: 0.0333)
            if start > end {
                action = action.reversed()
            }
            
            run(action){
                self.isAnimating = false
                self.currentComplete = complete
                completion()
            }
        } else {
            let endT = atlas.textureNames.sorted()[end]
            texture = atlas.textureNamed(endT)
            currentComplete = complete
            completion()
        }
    }
    
    private func index(for percent: CGFloat) -> Int {
        let totalFrames = atlas.textureNames.count - 1
        return Int(CGFloat(totalFrames) * percent)
    }
}
