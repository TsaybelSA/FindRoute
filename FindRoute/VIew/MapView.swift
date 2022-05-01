//
//  MapView.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 10.04.2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: UIViewRepresentable {
	
	@EnvironmentObject var dataSource: SearchData
		
	let mapView = MKMapView()
	
	@Binding var region: MKCoordinateRegion {
		didSet {
			print("Region changed to current location")
		}
	}
	
	@Binding var routeIsMade: Bool {
		didSet {
			if routeIsMade {
				makeRoute()
			}
			print("Changed")
		}
	}
	
	
	func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
		mapView.showsCompass = true
		mapView.showsUserLocation = true
		return mapView
	}

	func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
		view.setRegion(region, animated: true)
		view.addAnnotations(dataSource.setLocations)
		if routeIsMade {
			makeRoute()
		}
	}
	
	private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
		let startLocation = MKPlacemark(coordinate: startCoordinate)
		let destinationLocation = MKPlacemark(coordinate: destinationCoordinate)
		
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: startLocation)
		request.destination = MKMapItem(placemark: destinationLocation)
		request.transportType = .any
		request.requestsAlternateRoutes = true
		
		let direction = MKDirections(request: request)
		direction.calculate { (responce, error) in
			
			if let error = error {
				print(error)
			}
			
			if let responce = responce, responce.routes.count > 0 {
				let minRoute = responce.routes.sorted(by: { $0.distance < $1.distance }).first!
				mapView.addOverlay(minRoute.polyline)
				
			} else {
				//MARK: - make error alerts
//				dataSource.alertError(error)
			}
		}
	}
	
	private func makeRoute() {
		for index in 0...(dataSource.setLocations.count - 2) {
			let locations = dataSource.setLocations
			createDirectionRequest(startCoordinate: locations[index].coordinate, destinationCoordinate: locations[index + 1].coordinate)
			print("Made routes")
		}
	}
}

//extension MapView: NSObject, MKMapViewDelegate {
//
//
//	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) {
//
//	}
//}
