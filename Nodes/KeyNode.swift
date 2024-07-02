import SceneKit

class KeyNode: SCNNode {
    override init() {
        super.init()
        let keyGeometry = SCNBox(width: 0.1, height: 0.01, length: 0.3, chamferRadius: 0.01)
        self.geometry = keyGeometry
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func pressKey() {
        let moveDown = SCNAction.moveBy(x: 0, y: -0.01, z: 0, duration: 0.1)
        let moveUp = SCNAction.moveBy(x: 0, y: 0.01, z: 0, duration: 0.1)
        let changeColor = SCNAction.run { node in
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        }
        let resetColor = SCNAction.run { node in
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        }
        let sequence = SCNAction.sequence([moveDown, changeColor, SCNAction.wait(duration: 0.5), resetColor, moveUp])
        self.runAction(sequence)
    }
}
