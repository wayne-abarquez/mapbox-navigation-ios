import CoreLocation


class KalmanLocation {

    var decay: Double = 3

    var variance: Double = -1

    var minAccuracy: Double = 1

    var latitude: Double = 0

    var longitude: Double = 0

    var timestampInMs: Double = 0

    convenience init(decay: Double = 3) {
        self.init(decay: decay)
    }

    public func process(location: CLLocation) -> CLLocation {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        var accuracy = location.horizontalAccuracy
        var timestampInMs = Double((location.timestamp.timeIntervalSince1970 * 1000.0).rounded())
        
        if accuracy < self.minAccuracy {
            accuracy = self.minAccuracy
        }

        if self.variance < 0 {
          self.timestampInMs = timestampInMs
          self.latitude = latitude
          self.longitude = longitude
          self.variance = accuracy * accuracy
        } else {
          let timeIncMs = timestampInMs - self.timestampInMs

          if timeIncMs > 0 {
            self.variance += (timeIncMs * self.decay * self.decay) / 1000.0
            self.timestampInMs = timestampInMs
          }

          let _k = self.variance / (self.variance + (accuracy * accuracy))
          self.latitude += _k * (latitude - self.latitude)
          self.longitude += _k * (longitude - self.longitude)

          self.variance = (1 - _k) * self.variance
        }

        let newCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)

        let newLocation = CLLocation(coordinate: newCoordinate, altitude: location.altitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, course: location.course, speed: location.speed, timestamp: location.timestamp)
        
        return newLocation
    }
}
