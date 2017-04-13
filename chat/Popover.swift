//
//  Popover.swift
//  extension
//
//  Created by Chiang Chuan on 12/04/2017.
//  Copyright © 2017 Chiang Chuan. All rights reserved.
//

import UIKit

extension LoginController: UIPopoverPresentationControllerDelegate {

    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController)
    {
    
    // Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the
    // dismissal of the view.
    }
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController)
    {
    
    // -popoverPresentationController:willRepositionPopoverToRect:inView: is called on your delegate when the
    // popover may require a different view or rectangle.
    }
    public func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>){
        
    }

    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool{
        return true
    }

    func popover(pop: UIViewController, size: CGSize, arch: UIView, Direction: UIPopoverArrowDirection){
        pop.modalPresentationStyle = .popover
        pop.popoverPresentationController?.delegate = self
        pop.popoverPresentationController?.sourceView = arch
        pop.popoverPresentationController?.sourceRect = arch.bounds
        pop.preferredContentSize = size
        pop.popoverPresentationController?.permittedArrowDirections = Direction
        self.present(pop, animated: true, completion: nil)
        
    }

}
