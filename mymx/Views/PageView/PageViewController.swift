//
//  PageViewController.swift
//  Landmarks
//
//  Created by ice on 2024/6/16.
//

import SwiftUI
import UIKit

struct PageViewController<Page: View>: UIViewControllerRepresentable{
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    var pages: [Page]
    @Binding var currentPage: Int
    
    func makeUIViewController(context: Context) -> UIPageViewController  {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: Context) {
        context.coordinator.parent = self
        uiViewController.setViewControllers([context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate{
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard controllers.count > 1 else { return nil }
            guard let index = controllers.firstIndex(of: viewController) else { return nil}
            print("viewControllerBefore: \(index)")
            if(index == 0){
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard controllers.count > 1 else { return nil }
            guard let index = controllers.firstIndex(of: viewController) else { return nil}
            print("viewControllerAfter: \(index)")
            if(index + 1 >= controllers.count){
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if(completed){
                let visibleViewController = pageViewController.viewControllers?.first
                if((visibleViewController) != nil){
                    let index = controllers.firstIndex(of: visibleViewController!)
                    print("didFinishAnimating")
                    if( index != nil){
                        parent.currentPage  = index!
                    }
                }
            }
        }
        
        var parent: PageViewController
        var controllers = [UIViewController]()
        init(_ parent: PageViewController) {
            self.parent = parent
            self.controllers = parent.pages.map({
                UIHostingController(rootView: $0)
            })
        }
    }
}
