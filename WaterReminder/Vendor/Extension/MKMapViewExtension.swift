//
//  setCenter+MKMapView.swift
//
//

import Foundation
import MapKit
import CoreLocation
import JZLocationConverter

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
    
    
    /// 将 GPS 坐标转换为火星坐标 设为地图中心 并缩放
    ///
    /// - Parameter center:  GPS 坐标
    func setMapCenterAndZoom(center : CLLocationCoordinate2D) {
        //gps 转火星坐标
        let wgsCenter = JZLocationConverter.wgs84(toGcj02: center)
        //移动到设置的位置
        self.setCenter(wgsCenter, animated: true)
        self.setRegion(MKCoordinateRegionMakeWithDistance(wgsCenter, 200, 200), animated: true) //缩放到所选位置
    }
    
    
    /// 根据火星坐标 设置地图中心 并缩放
    ///
    /// - Parameter center: 火星坐标
    func setGcjMapAndZoom(center : CLLocationCoordinate2D)  {
        //移动到设置的位置
        self.setCenter(center, animated: true)
        self.setRegion(MKCoordinateRegionMakeWithDistance(center, 200, 200), animated: true) //缩放到所选位置
    }
    
}
