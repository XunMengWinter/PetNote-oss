import NukeUI
import SwiftUI

struct AttachmentImageView: View {
    let imageUrl: String
    
    @GestureState private var zoom = 1.0
    
    var body: some View {
        ZoomableContainer {
            LazyImage(url: URL(string: imageUrl)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(zoom)
                } else if state.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
        }
    }
}
