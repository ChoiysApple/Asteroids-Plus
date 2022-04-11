import SwiftUI
import SpriteKit

struct ContentView: View {
    
    var scene: SKScene {
         let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
         scene.scaleMode = .fill
         return scene
     }
    
    var body: some View {
        
        GeometryReader { (geometry) in
            
            SpriteView(scene: self.scene)
                .ignoresSafeArea()
                .previewInterfaceOrientation(.landscapeLeft)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
        
    }
}
