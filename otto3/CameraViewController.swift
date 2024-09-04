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
    var focusIndicator: UIView!
    var flashView: UIView!
    
    
    // Reference to the Photo Gallery View Controller
    var galleryViewController: PhotoGalleryViewController?
    
    // Reference to the Main View Controller for loading screen management
    weak var mainViewController: MainViewController?
    
    // Max zoom factor so the quality of image is high enough for API
    private let maximumZoomFactor: CGFloat = 5.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCaptureButton()
        setupFocusIndicator()
        setupPinchGesture() // Pinch gestures for zooming in/out
        setupFlashView()  // Flash screen to indicate picture has been taken
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleFocusTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // Prevent screen from auto-rotating
    override var shouldAutorotate: Bool {
        return false
    }
        
    func setupPinchGesture() {
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            view.addGestureRecognizer(pinchGesture)
        }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
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
    
    // Flash screen to indicate user has taken a picture
    func setupFlashView() {
            flashView = UIView(frame: view.bounds)
            flashView.backgroundColor = UIColor.black
            flashView.alpha = 0
            view.addSubview(flashView)
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
            if galleryViewController?.isViewLoaded == false {
                galleryViewController?.loadViewIfNeeded()
            }
            
            let settings = AVCapturePhotoSettings()
            if #available(iOS 16.0, *) {
                settings.maxPhotoDimensions = CMVideoDimensions(width: 4032, height: 3024)
            } else {
                settings.isHighResolutionPhotoEnabled = true
            }
            settings.flashMode = .auto
            capturePhotoOutput.capturePhoto(with: settings, delegate: self)
            
            // Flash screen clashing aesthetically with loading screen
            // flashScreen()
        
            // Show loading screen after user has captured image
            mainViewController?.showLoadingScreen()
        }
    
    func flashScreen() {
            UIView.animate(withDuration: 0.0, animations: {
                self.flashView.alpha = 1
            }) { _ in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
                    self.flashView.alpha = 0
                })
            }
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
        
        
        guard let imageData = photo.fileDataRepresentation() else {
                mainViewController?.hideLoadingScreen()  // Hide loading screen if there's an error processing the photo
                return
            }
        
        let image = UIImage(data: imageData)
        
        // Send image to TrafficEye API
        sendToTrafficEyeAPI(image: image) { [weak self] result in
                DispatchQueue.main.async {
                    self?.mainViewController?.hideLoadingScreen()  // Hide loading screen after processing the result
                    
                    switch result {
                    case .success(let vehicleInfo):
                        guard let galleryVC = self?.galleryViewController else {
                            print("GalleryViewController is not available")
                            return
                        }
                        galleryVC.addVehicleEntry(image: image, vehicleInfo: vehicleInfo)
                    case .failure(let error):
                        print("Failed to retrieve vehicle info: \(error)")
                    }
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
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            /*
             // Test raw response data
             
             if let rawDataString = String(data: data, encoding: .utf8) {
             print("Raw Response: \(rawDataString)")
             }
             */
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    guard let status = json["status"] as? Int, status == 200 else {
                        print("Failed to retrieve vehicle info: \(json["message"] ?? "Unknown error")")
                        return
                    }
                    
                    if let data = json["data"] as? [String: Any],
                       let combinations = data["combinations"] as? [[String: Any]],
                       let firstCombination = combinations.first,
                       let roadUsers = firstCombination["roadUsers"] as? [[String: Any]],
                       let firstRoadUser = roadUsers.first,
                       let mmr = firstRoadUser["mmr"] as? [String: Any] {
                        
                        // Extract the necessary vehicle information
                        let make = (mmr["make"] as? [String: Any])?["value"] as? String ?? "Unknown"
                        let model = (mmr["model"] as? [String: Any])?["value"] as? String ?? "Unknown"
                        let year = (mmr["generation"] as? [String: Any])?["value"] as? String ?? "Unknown"
                        
                        // Pass the extracted information to the completion handler
                        completion(.success((make, model, year)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
}

