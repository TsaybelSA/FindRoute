//
//  UtilityExtentions.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 08.04.2022.
//

import SwiftUI
import CoreLocation
import MapKit

struct IdentifiableAlert: Identifiable {
	var id: String
	var alert: () -> Alert
	
	init(id: String, alert: @escaping () -> Alert) {
		self.id = id
		self.alert = alert
	}
	
	init(id: String, title: String, message: String) {
		self.id = id
		alert = { Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK"))) }
	}
	
	init(title: String, message: String) {
		self.id = title + message
		alert = { Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK"))) }
	}
}


