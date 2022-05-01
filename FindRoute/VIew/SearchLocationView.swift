//
//  SearchLocationView.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 08.04.2022.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct SearchLocationView: View {
	
	@EnvironmentObject var dataSource: SearchData
	
	@Environment(\.presentationMode) var presentationMode
	
	@State var adress = ""
	
	@Binding var region: MKCoordinateRegion
	
    var body: some View {
		NavigationView {
			Form {
				adressLine
				results
			}
			.dismissable { presentationMode.wrappedValue.dismiss() }
			.navigationTitle("Search For Location")
		}
		.onChange(of: adress) { adress in
			dataSource.findPlacemarks(for: adress)
		}
    }
	
	var adressLine: some View {
		Section("Location") {
			TextField("Type Necessary Adress", text: $adress)
		}
	}
	
	@ViewBuilder
	var results: some View {
		Section("Results") {
			ForEach(dataSource.searchList) { location in
					VStack {
						Text(location.name)
						if let additionInformation = location.additionInformation {
							Text(additionInformation)
						}
					}
					.onTapGesture {
						withAnimation  {
							dataSource.setPlacemark(for: location)
							presentationMode.wrappedValue.dismiss()
							setRegionToPlacemarkLocation(for: location)
						}
					}
//				}
			}
		}
	}
	
	private func setRegionToPlacemarkLocation(for placemark: Location) {
		region = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 750, longitudinalMeters: 750)

	}
}

struct SearchLocationView_Previews: PreviewProvider {
    static var previews: some View {
		SearchLocationView(region: .constant(MKCoordinateRegion()))
    }
}
