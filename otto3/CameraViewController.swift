//
//  CameraViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var capturePhotoOutput: AVCapturePhotoOutput!
    var focusIndicator: UIView!  // Focus indicator view
    
    // Reference to the Photo Gallery View Controller
    var galleryViewController: PhotoGalleryViewController?
    
    // Define the maximum zoom factor
    private let maximumZoomFactor: CGFloat = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCaptureButton()
        setupFocusIndicator()
        setupPinchGesture() // Set up pinch gestures for zooming in/out
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFocusTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
        
    func setupPinchGesture() {
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            view.addGestureRecognizer(pinchGesture)
        }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
            // Get the device from the first input
            guard let deviceInput = captureSession.inputs.first(where: { $0 is AVCaptureDeviceInput }) as? AVCaptureDeviceInput else { return }
            let device = deviceInput.device
            
            if gesture.state == .began || gesture.state == .changed {
                // Calculate zoom factor based on the pinch gesture scale
                let currentZoomFactor = device.videoZoomFactor
                let zoomScale = max(1.0, min(currentZoomFactor * gesture.scale, maximumZoomFactor))
                setZoomFactor(zoomScale)
                gesture.scale = 1.0
            }
        }

        func setZoomFactor(_ zoomFactor: CGFloat) {
            guard let deviceInput = captureSession.inputs.first(where: { $0 is AVCaptureDeviceInput }) as? AVCaptureDeviceInput else { return }
            let device = deviceInput.device
            
            do {
                try device.lockForConfiguration()
                let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
                device.videoZoomFactor = min(maxZoomFactor, max(1.0, zoomFactor))
                device.unlockForConfiguration()
            } catch {
                print("Failed to lock device for configuration: \(error)")
            }
        }
    
    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Unable to access back camera!")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            print("Error unable to initialize back camera: \(error.localizedDescription)")
        }

        capturePhotoOutput = AVCapturePhotoOutput()
        captureSession.addOutput(capturePhotoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func setupFocusIndicator() {
        let indicatorSize: CGFloat = 100
        focusIndicator = UIView(frame: CGRect(x: 0, y: 0, width: indicatorSize, height: indicatorSize))
        focusIndicator.layer.borderColor = UIColor.white.cgColor
        focusIndicator.layer.borderWidth = 2.0
        focusIndicator.layer.cornerRadius = 15
        focusIndicator.backgroundColor = UIColor.clear
        focusIndicator.alpha = 0
        view.addSubview(focusIndicator)
    }

    func setupCaptureButton() {
        let buttonSize: CGFloat = 80
        let captureButton = UIButton(frame: CGRect(x: view.frame.width/2 - buttonSize/2, y: view.frame.height - buttonSize - 40, width: buttonSize, height: buttonSize))
        captureButton.backgroundColor = .clear
        captureButton.layer.borderColor = UIColor.white.cgColor
        captureButton.layer.borderWidth = 5.0
        captureButton.layer.cornerRadius = buttonSize / 2
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        view.addSubview(captureButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        if let captureButton = view.subviews.first(where: { $0 is UIButton }) {
            captureButton.center = CGPoint(x: view.frame.width / 2, y: view.frame.height - captureButton.frame.height / 2 - 40)
        }
    }
    
    

    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        if #available(iOS 16.0, *) {
            settings.maxPhotoDimensions = CMVideoDimensions(width: 4032, height: 3024)
        } else {
            settings.isHighResolutionPhotoEnabled = true
        }
        settings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: settings, delegate: self)
    }

    // Make focus indicator "bounce" before fading out
    @objc func handleFocusTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: view)
        
        // Position the focus indicator at the tap point
        focusIndicator.center = tapPoint
        focusIndicator.alpha = 1.0
        
        // Shrink animation
        UIView.animate(withDuration: 0.3, animations: {
            self.focusIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { _ in
            // Blink animation
            self.blinkAnimation(repeatCount: 1) { [weak self] in
                // Reset focus indicator
                self?.focusIndicator.transform = CGAffineTransform.identity
                self?.focusIndicator.alpha = 0
            }
        })
        
        focus(at: tapPoint)
    }

    func blinkAnimation(repeatCount: Int, completion: @escaping () -> Void) {
        if repeatCount > 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.focusIndicator.alpha = self.focusIndicator.alpha == 0 ? 1 : 0
            }, completion: { _ in
                self.blinkAnimation(repeatCount: repeatCount - 1, completion: completion)
            })
        } else {
            completion()
        }
    }


    func focus(at point: CGPoint) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        let focusPoint = CGPoint(x: point.x / view.bounds.size.width, y: point.y / view.bounds.size.height)

        do {
            try device.lockForConfiguration()

            if device.isFocusPointOfInterestSupported {
                device.focusPointOfInterest = focusPoint
                device.focusMode = .autoFocus
            }

            if device.isExposurePointOfInterestSupported {
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = .continuousAutoExposure
            }

            device.unlockForConfiguration()
        } catch {
            print("Error setting focus and exposure: \(error.localizedDescription)")
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        
        // Send image to TrafficEye API
        sendToTrafficEyeAPI(image: image) { [weak self] result in
            switch result {
            case .success(let vehicleInfo):
                self?.galleryViewController?.addVehicleEntry(image: image, vehicleInfo: vehicleInfo)
            case .failure(let error):
                print("Failed to retrieve vehicle info: \(error)")
            }
        }
    }
    
    
    func sendToTrafficEyeAPI(image: UIImage?, completion: @escaping (Result<(make: String, model: String, year: String), Error>) -> Void) {
        guard let image = image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let url = URL(string: "https://trafficeye.ai/recognition")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("c5b0495563c33ea4a2ad91eb5f3b4bc08e416334e47e0cfc55290d32ebf850f0", forHTTPHeaderField: "apikey")
        
        // Boundary for the multipart/form-data request
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // HTTP body with image data
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            /*
             // Raw response data
             
             if let rawDataString = String(data: data, encoding: .utf8) {
             print("Raw Response: \(rawDataString)")
             }
             */
            
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Check the status
                    guard let status = json["status"] as? Int, status == 200 else {
                        print("Failed to retrieve vehicle info: \(json["message"] ?? "Unknown error")")
                        return
                    }
                    
                    // Navigate to the relevant parts of the JSON structure
                    if let data = json["data"] as? [String: Any],
                       let combinations = data["combinations"] as? [[String: Any]],
                       let firstCombination = combinations.first,
                       let roadUsers = firstCombination["roadUsers"] as? [[String: Any]],
                       let firstRoadUser = roadUsers.first,
                       let mmr = firstRoadUser["mmr"] as? [String: Any] {
                        
                        // Extract make, model, generation, and color
                        if let make = mmr["make"] as? [String: Any],
                           let makeValue = make["value"] as? String {
                            print("Make: \(makeValue)")
                        }
                        
                        if let model = mmr["model"] as? [String: Any],
                           let modelValue = model["value"] as? String {
                            print("Model: \(modelValue)")
                        }
                        
                        if let generation = mmr["generation"] as? [String: Any],
                           let generationValue = generation["value"] as? String {
                            print("Generation: \(generationValue)")
                        }
                        
                        if let color = mmr["color"] as? [String: Any],
                           let colorValue = color["value"] as? String {
                            print("Color: \(colorValue)")
                        }
                    }
                    
                    
                    
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
            
        }
        task.resume()
    }
    
}

    /*
    func sendToTrafficEyeAPI(image: UIImage?, completion: @escaping (Result<(make: String, model: String, year: String), Error>) -> Void) {
        guard let image = image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        let url = URL(string: "https://trafficeye.ai/recognition")! // Replace with actual API URL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Add your API key in the headers
        request.setValue("c5b0495563c33ea4a2ad91eb5f3b4bc08e416334e47e0cfc55290d32ebf850f0", forHTTPHeaderField: "apikey")
        
        // Create a boundary for the multipart/form-data request
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Construct the HTTP body with image data
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Check the status
                    guard let status = json["status"] as? Int, status == 200 else {
                        let errorMessage = json["message"] as? String ?? "Unknown error"
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        return
                    }

                    // Navigate to the relevant parts of the JSON structure
                    if let data = json["data"] as? [String: Any],
                       let combinations = data["combinations"] as? [[String: Any]],
                       let firstCombination = combinations.first,
                       let roadUsers = firstCombination["roadUsers"] as? [[String: Any]],
                       let firstRoadUser = roadUsers.first,
                       let mmr = firstRoadUser["mmr"] as? [String: Any] {

                        // Extract make, model, generation, and color
                        let makeValue = (mmr["make"] as? [String: Any])?["value"] as? String ?? ""
                        let modelValue = (mmr["model"] as? [String: Any])?["value"] as? String ?? ""
                        let generationValue = (mmr["generation"] as? [String: Any])?["value"] as? String ?? ""
                        let colorValue = (mmr["color"] as? [String: Any])?["value"] as? String ?? ""
                        
                        // Create a dictionary to cache the data
                        let vehicleInfo = ["make": makeValue, "model": modelValue, "generation": generationValue, "color": colorValue]
                        
                        // Cache the data using UserDefaults (or another cache mechanism)
                        UserDefaults.standard.set(vehicleInfo, forKey: "cachedVehicleInfo")
                        
                        // Pass the data to the completion handler
                        completion(.success((make: makeValue, model: modelValue, year: generationValue)))
                    }
                    
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}

func retrieveCachedVehicleInfo() -> [String: String]? {
    return UserDefaults.standard.dictionary(forKey: "cachedVehicleInfo") as? [String: String]
}

*/
