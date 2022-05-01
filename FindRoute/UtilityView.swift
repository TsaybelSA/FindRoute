//
//  UtilityView.swift
//  FindRoute
//
//  Created by Сергей Цайбель on 08.04.2022.
//

import SwiftUI

struct AnimatedActionButton: View {
	var title: String? = nil
	var systemImage: String? = nil
	let action: () -> Void
	
	var body: some View {
		Button {
			withAnimation {
				action()
			}
		} label: {
			if title != nil && systemImage != nil {
				Label(title!, systemImage: systemImage!)
			} else if title != nil {
				Text(title!)
			} else if systemImage != nil {
				Image(systemName: systemImage!)
			}
		}
	}
}

// Create rounded rectangle shaped frame around content

struct BorderedCaption: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(5)
			.background(.gray.opacity(0.5))
			.clipShape(RoundedRectangle(cornerRadius: 15))
			.foregroundColor(Color.blue)
			.font(.largeTitle)
	}
}
extension View {
	func borderedCaption() -> some View {
		modifier(BorderedCaption())
	}
}

//wrapping view into navigation view
//it will add cancel button to the view

extension View {
	@ViewBuilder
	func wrappedInNavigationViewToMakeDismissable(_ dismiss:(() -> Void)?) -> some View {
		if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
			NavigationView {
				self
					.navigationBarTitleDisplayMode(.inline)
					.dismissable(dismiss)
			}
			.navigationViewStyle(StackNavigationViewStyle())
		} else {
			self
		}
	}
	
	@ViewBuilder
	func dismissable(_ dismiss:(() -> Void)?) -> some View {
		if UIDevice.current.userInterfaceIdiom != .pad, let dismiss = dismiss {
			self.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Close") { dismiss() }
				}
			}
		} else {
			self
		}
	}
}
