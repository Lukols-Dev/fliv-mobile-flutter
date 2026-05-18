import Flutter
import CoreLocation
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  private let channelName = "fliv/location_permission"
  private let locationManager = CLLocationManager()
  private var pendingPermissionResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: channelName,
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { [weak self] call, result in
        guard let self = self else { return }
        switch call.method {
        case "check":
          result(self.currentPermissionStatus())
        case "request":
          self.requestPermission(result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestPermission(_ result: @escaping FlutterResult) {
    let status = currentPermissionStatus()
    if status == "granted" || status == "serviceDisabled" || status == "deniedForever" {
      result(status)
      return
    }

    if pendingPermissionResult != nil {
      result(FlutterError(
        code: "permission_request_active",
        message: "Location permission request is already active.",
        details: nil
      ))
      return
    }

    pendingPermissionResult = result
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }

  private func currentPermissionStatus() -> String {
    let authorizationStatus: CLAuthorizationStatus
    if #available(iOS 14.0, *) {
      authorizationStatus = locationManager.authorizationStatus
    } else {
      authorizationStatus = CLLocationManager.authorizationStatus()
    }

    switch authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      return CLLocationManager.locationServicesEnabled() ? "granted" : "serviceDisabled"
    case .denied, .restricted:
      return "deniedForever"
    case .notDetermined:
      return "denied"
    @unknown default:
      return "denied"
    }
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    guard let result = pendingPermissionResult else { return }
    pendingPermissionResult = nil
    result(currentPermissionStatus())
  }

  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    guard let result = pendingPermissionResult else { return }
    pendingPermissionResult = nil
    result(currentPermissionStatus())
  }
}
