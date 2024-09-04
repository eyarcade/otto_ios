//
//  MainViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    
    // Loading screen for user until API response appears
    private var loadingView: LoadingView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraVC = CameraViewController()
        let galleryVC = PhotoGalleryViewController()
        
        // Link gallery to camera view controller
        cameraVC.galleryViewController = galleryVC
        
        // Reference to MainViewController in CameraViewController
        cameraVC.mainViewController = self

        // View Vehicle Gallery when swiping left
        pages.append(galleryVC)
        pages.append(cameraVC)

        // Initial view controller - CameraViewController
        setViewControllers([cameraVC], direction: .reverse, animated: true, completion: nil)
        self.dataSource = self
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return nil
        }

        return pages[nextIndex]
    }

    func showLoadingScreen() {
        loadingView = LoadingView(frame: view.bounds)
        if let loadingView = loadingView {
            view.addSubview(loadingView)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loadingView.topAnchor.constraint(equalTo: view.topAnchor),
                loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    func hideLoadingScreen() {
        loadingView?.removeFromSuperview()
        loadingView = nil
    }

    // Orientation Control
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
