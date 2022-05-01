//
//  SearchViewModel.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 09.04.2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct Location: Identifiable {
	let id = UUID()
	let name: String
	let additionInformation: String?
	let coordinate: CLLocationCoordinate2D
}

class SearchData: ObservableObject {
	
	@Published private(set) var searchList = [Location]()
	
	@Published private(set) var setLocations = [MKPointAnnotation]() {
		didSet {
			print("Location was added")
		}
	}
	
	@Published private(set) var routeIsMade = false
		
//	var alertToShow: IdentifiableAlert?

	//MARK: - Intention(s)
	
	func makeRoute() {
		routeIsMade = true
	}
	
	func setPlacemark(for location: Location) {
		let annotation = MKPointAnnotation()
		annotation.title = location.name
		annotation.coordinate = location.coordinate
		setLocations.append(annotation)
		print("location added \(setLocations)")
	}
	
	func findPlacemarks(for adress: String) {
		searchList.removeAll()
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(adress) { [weak self] placemarks, error in
			if let error = error {
				print(error)
//				self?.alertToShow = IdentifiableAlert(title: "Connection problems", message: "Please try again")
			}
			if let placemarks = placemarks {
				for placemark in placemarks {
					if let name = placemark.name, let coordinate = placemark.location?.coordinate {
						self?.searchList.append(Location(name: name, additionInformation: placemark.administrativeArea, coordinate: coordinate))
					}
				}
			}
		}
	}
}
