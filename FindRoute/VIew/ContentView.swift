//
//  ContentView.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 08.04.2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct ContentView: View {
	
	@EnvironmentObject var dataSource: SearchData

	let locationManager = CLLocationManager()
		
	@State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020), latitudinalMeters: 750, longitudinalMeters: 750)
		
	@State var showingSearchList = false
	
	@State var alertToShow: IdentifiableAlert?
	
	@State var routeIsMade = false
	
	
    var body: some View {
		map
		.overlay(alignment: .center) {
			rightSideButtons
		}
		.overlay(alignment: .bottom) {
			bottomButtons
		}
		

		.popover(isPresented: $showingSearchList) {
			SearchLocationView(region: $region)
		}
		
		.alert(item: $alertToShow) { alertToShow in
			alertToShow.alert()
		}
		
		.onAppear {
			isLocationServiceEnabled()
			setRegionToUserCurrentLocation()
		}
    }
	
	var map: some View {
		MapView(region: $region, routeIsMade: $routeIsMade)
		.ignoresSafeArea()
		.onAppear {
			setRegionToUserCurrentLocation()
		}
		
	}
	
	var rightSideButtons: some View {
		VStack {
			searchLocationButton
			currentLocationButton
		}
		.padding()
	}
	
	@ViewBuilder
	var bottomButtons: some View {
		if dataSource.setLocations.count > 2 {
			HStack {
				makeRouteButton
				Spacer()
				cancelRouteButton
			}
		}
	}
	
	var currentLocationButton: some View {
		HStack {
			Spacer()
			AnimatedActionButton(systemImage: "location.circle") {
				setRegionToUserCurrentLocation()
			}
			.borderedCaption()
		}
	}
	
	var searchLocationButton: some View {
		HStack {
			Spacer()
			AnimatedActionButton(systemImage: "magnifyingglass") {
				showingSearchList = true
			}
			.borderedCaption()
		}
	}
	
	var makeRouteButton: some View {
		Button {
			withAnimation {
				routeIsMade = true
				print("Toggled")
			}
		} label: {
			VStack {
				Text("Make")
				Text("Route")
			}
			.font(.title)
		}
		.borderedCaption()
		.padding()
	}
	
	var cancelRouteButton: some View {
		Button {
			withAnimation {
				
			}
		} label: {
			VStack {
				Text("Cancel")
				Text("Route")
			}
			.font(.title)
		}
		.borderedCaption()
		.padding()
	}
	
	
	private func isLocationServiceEnabled() {
		if CLLocationManager.locationServicesEnabled() {
			checkAuthorizationStatus()
		}
		else {
			displayAlert(isServiceEnabled: true)
		}
	}
	
	private func checkAuthorizationStatus() {
		let status = locationManager.authorizationStatus
		if status == .authorizedAlways || status == .authorizedWhenInUse {
			setRegionToUserCurrentLocation()
		} else if status == .denied || status == .restricted {
			displayAlert(isServiceEnabled: false)
		} else if status == .notDetermined {
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	private func displayAlert(isServiceEnabled: Bool) {
		let serviceEnableMessage = "Location services must to be enabled to use this awesome app feature. You can enable location services in your settings."
		let authorizationStatusMessage = "This awesome app needs authorization to do some cool stuff with the map"
		let message = isServiceEnabled ? serviceEnableMessage : authorizationStatusMessage

		alertToShow = IdentifiableAlert(title: "Can`t access to current location", message: message)
	}
	
	private func setRegionToUserCurrentLocation() {
		let location = locationManager.location
		if let coordinate = location?.coordinate {
			region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 750, longitudinalMeters: 750)
			print("Region changed")
		}
	}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			.previewDevice("iPhone 12")
    }
}
