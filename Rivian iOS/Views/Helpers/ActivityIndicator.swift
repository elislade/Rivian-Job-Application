import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    let style: UIActivityIndicatorView.Style = .medium
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let a = UIActivityIndicatorView(style: style)
        a.startAnimating()
        return a
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
}
