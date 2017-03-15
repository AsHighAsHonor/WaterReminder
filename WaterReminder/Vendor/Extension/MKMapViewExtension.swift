//
//  setCenter+MKMapView.swift
//
//

import Foundation
import MapKit
import CoreLocation

extension MKMapView {
    func setCenter(coordinate: CLLocationCoordinate2D, coordinatesDelta: Double) {
        let span = MKCoordinateSpan(latitudeDelta: coordinatesDelta, longitudeDelta: coordinatesDelta)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.setRegion(region, animated: true)
    }
    
    func zoomMap(byFactor delta: Double) {
        var region: MKCoordinateRegion = self.region
        var span: MKCoordinateSpan = self.region.span
        span.latitudeDelta *= delta
        span.longitudeDelta *= delta
        region.span = span
        self.setRegion(region, animated: true)
    }
    
}
