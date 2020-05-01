import SwiftUI
import MapKit

struct MapView {
    
    @State var anno:MKAnnotation
    @State var showMyLocation = true
    
    func makeView() -> MKMapView {
        let view = MKMapView()
        return view
    }
    
    func updateView(_ view: MKMapView) {
        view.addAnnotation(anno)
        view.showsUserLocation = showMyLocation
        DispatchQueue.main.async {
            view.setRegion(MKCoordinateRegion(
                center: self.anno.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            ), animated: false)
        }
    }
    
}

#if os(iOS)

extension MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        makeView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        updateView(uiView)
    }
}

#else

extension MapView: NSViewRepresentable {
    typealias NSViewType = MKMapView
    
    func makeNSView(context: NSViewRepresentableContext<MapView>) -> MKMapView {
        makeView()
    }
    
    func updateNSView(_ nsView: MKMapView, context: NSViewRepresentableContext<MapView>) {
        updateView(nsView)
    }
}

#endif
