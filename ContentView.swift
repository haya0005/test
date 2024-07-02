import SwiftUI
import ARKit
import SceneKit

struct ContentView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.delegate = context.coordinator
        arView.scene = SCNScene()
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: ContentView
        let handTrackingManager = HandTrackingManager()

        init(_ parent: ContentView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
            guard let sceneView = gestureRecognize.view as? ARSCNView else { return }
            let location = gestureRecognize.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, types: .featurePoint)
            if let result = hitResults.first {
                let worldPosition = result.worldTransform.columns.3
                let position = SCNVector3(worldPosition.x, worldPosition.y, worldPosition.z)
                addKey(at: position, in: sceneView)
            }
        }
        
        func addKey(at position: SCNVector3, in sceneView: ARSCNView) {
            let keyNode = KeyNode()
            keyNode.position = position
            sceneView.scene.rootNode.addChildNode(keyNode)
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            handTrackingManager.session(session, didUpdate: anchors)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
