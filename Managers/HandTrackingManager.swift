import ARKit

class HandTrackingManager {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let handAnchor = anchor as? ARHandAnchor {
                let fingerTipPosition = handAnchor.jointLandmark(.indexTip)
                checkCollision(with: fingerTipPosition)
            }
        }
    }

    func checkCollision(with fingerTipPosition: vector_float3) {
        let fingerTipNode = SCNNode()
        fingerTipNode.position = SCNVector3(fingerTipPosition)
        let hitResults = sceneView.scene.rootNode.hitTestWithSegment(from: fingerTipNode.position, to: fingerTipNode.position, options: nil)
        for result in hitResults {
            if let keyNode = result.node as? SCNNode {
                let moveDown = SCNAction.moveBy(x: 0, y: -0.01, z: 0, duration: 0.1)
                let moveUp = SCNAction.moveBy(x: 0, y: 0.01, z: 0, duration: 0.1)
                let changeColor = SCNAction.run { node in
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                }
                let resetColor = SCNAction.run { node in
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                }
                let sequence = SCNAction.sequence([moveDown, changeColor, SCNAction.wait(duration: 0.5), resetColor, moveUp])
                keyNode.runAction(sequence)
            }
        }
    }
}
