import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    @Published var locations: [Location]
    
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: self.mapLocation)
        }
    }
    
    @Published var mapRegion: MapCameraPosition
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    @Published var showLocationList: Bool = false
    
    @Published var sheetLocation: Location? = nil
    
    init() {
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(), span: mapSpan))
        self.updateMapRegion(location: locations.first!)
    }
    
    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MapCameraPosition.region(MKCoordinateRegion(center: location.coordinates, span: mapSpan))
        }
        
    }
    
    func toggleLocationsList() {
        withAnimation(.easeInOut) {
            self.showLocationList.toggle()
        }
    }
    
    func selectNewLocation(location: Location) {
        withAnimation(.easeInOut) {
            self.mapLocation = location
            showLocationList = false
        }
    }
    
    func showNextLocation() {
        guard let currentIndex = locations.firstIndex(where: {$0 == self.mapLocation}) else { return }
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            // next index does not exist, restart from 0
            guard let firstLocation = locations.first else { return }
            selectNewLocation(location: firstLocation)
            return
            
        }
        let nextLocation = locations[nextIndex]
        selectNewLocation(location: nextLocation)
    }
}
