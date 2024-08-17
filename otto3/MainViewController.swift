//
//  MainViewController.swift
//  otto3
//
//  Created by Cade on 8/10/24.
//

import UIKit

class MainViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let cameraVC = CameraViewController()
        let galleryVC = PhotoGalleryViewController()
        
        // Link gallery to camera view controller
        cameraVC.galleryViewController = galleryVC

        pages.append(cameraVC)
        pages.append(galleryVC)

        setViewControllers([cameraVC], direction: .forward, animated: true, completion: nil)
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

    // Orientation Control

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return false
    }
}
