//
//  RouteMapView.swift
//  FMS
//
//  Created by Kanishq Mehta on 26/02/25.
//

import SwiftUI
import MapKit

struct RouteMapView: UIViewRepresentable {
    let startAddress: String
    let endAddress: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false // Hide live location
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        fetchCoordinates(for: startAddress, endAddress, on: mapView)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    // Convert addresses to coordinates & draw route
    private func fetchCoordinates(for start: String, _ end: String, on mapView: MKMapView) {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(start) { startPlacemarks, _ in
            geocoder.geocodeAddressString(end) { endPlacemarks, _ in
                if let startLocation = startPlacemarks?.first?.location,
                   let endLocation = endPlacemarks?.first?.location {
                    
                    let startCoordinate = startLocation.coordinate
                    let endCoordinate = endLocation.coordinate
                    
                    let startAnnotation = MKPointAnnotation()
                    startAnnotation.coordinate = startCoordinate
                    startAnnotation.title = "Start"
                    
                    let endAnnotation = MKPointAnnotation()
                    endAnnotation.coordinate = endCoordinate
                    endAnnotation.title = "Destination"
                    
                    mapView.addAnnotations([startAnnotation, endAnnotation])
                    
                    let request = MKDirections.Request()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinate))
                    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinate))
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request: request)
                    directions.calculate { response, _ in
                        if let route = response?.routes.first {
                            mapView.addOverlay(route.polyline)
                            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                        }
                    }
                }
            }
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}
