
class KalmanLocation {

    var decay: Double

    var variance: Double

    var minAccuracy: Double

    var latitude: Double

    var longitude: Double

    var timestampInMs: Double

    convenience init(decay: Double) {
        self.decay = decay
        self.variance = -1
        self.minAccuracy = 1
    }

    public func process(location: CLLocation) -> CLLocation {
        var latitude = location.coordinate.latitude
        var longitude = location.coordinate.longitude
        var accuracy = location.horizontalAccuracy
        var timestampInMs = location.timestamp.timeIntervalSince1970

        var newLocation = CLLocation(coordinate: location.coordinate, altitude: location.altitude, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, course: location.course, speed: location.speed, timestamp: location.timestamp)

        if accuracy < self.minAccuracy
            accuracy = self.minAccuracy

        if self.variance < 0 {
          self.timestampInMs = timestampInMs
          self.latitude = latitude
          self.longitude = longitude
          self.variance = accuracy * accuracy
        } else {
          let timeIncMs = timestampInMs - self.timestampInMs

          if timeIncMs > 0 {
            self.variance += (timeIncMs * self.decay * self.decay) / 1000
            self.timestampInMs = timestampInMs
          }

          let _k = self.variance / (self.variance + (accuracy * accuracy))
          self.latitude += _k * (latitude - self.latitude)
          self.longitude += _k * (longitude - self.longitude)

          self.variance = (1 - _k) * self.variance
        }

        newLocation.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)

        return newLocation
    }
}