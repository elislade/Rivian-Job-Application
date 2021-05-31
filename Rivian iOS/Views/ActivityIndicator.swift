import SwiftUI

struct ActivityIndicator:UIViewRepresentable {
    typealias UIViewType = UIActivityIndicatorView
    
    let style: UIActivityIndicatorView.Style = .medium
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let a = UIActivityIndicatorView(style: style)
        a.startAnimating()
        return a
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        // update
    }
}
