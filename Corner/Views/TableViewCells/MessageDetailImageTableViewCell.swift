//
//  MessageDetailImageTableViewCell.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class MessageDetailImageTableViewCell: UITableViewCell, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    @IBOutlet var scrView: UIScrollView!
    @IBOutlet var pgeCtrl: UIPageControl!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var firstImageView: UIImageView!
    var pageView: UIPageViewController!
    var test: UIView!
    
    var orderedViewControllers = [UIViewController]()
    
    private func newImageViewController(_ imageString: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: firstImageView.bounds.height)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: vc.view.bounds.height))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        vc.view.addSubview(imageView)
        imageView.af_setImage(withURL: URL(string: imageString)!)
        return vc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scrView.backgroundColor = UIColor.lightGray
        txtView.isEditable = false
        txtView.isSelectable = false
        txtView.isScrollEnabled = false
        pageView = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
    }
    
    override func prepareForReuse() {
        orderedViewControllers = [UIViewController]()
    }
    
    func setupCell(issue: Issue?) {
        orderedViewControllers = [UIViewController]()
        guard let user = DataManager.shared.currentUser else { return }
        guard let issueOwnerId = issue?.ownerOID else { return }
        txtView.text = issue?.message
        firstImageView.backgroundColor = .white
        if user.oid == issueOwnerId {
            if let imageURL1 = issue?.image1, imageURL1 != "" {
                orderedViewControllers.append(newImageViewController(imageURL1))
            }
            if let imageURL2 = issue?.image2, imageURL2 != "" {
                orderedViewControllers.append(newImageViewController(imageURL2))
            }
            if let imageURL3 = issue?.image3, imageURL3 != "" {
                orderedViewControllers.append(newImageViewController(imageURL3))
            }
            guard let frame = firstImageView?.frame else { return }
            pageView.dataSource = self
            pageView.delegate = self
            pageView.view.frame  = frame
            
            self.contentView.addSubview(pageView.view)
            
            if let firstViewController = orderedViewControllers.first {
                pageView.setViewControllers([firstViewController],
                                            direction: .forward,
                                            animated: true,
                                            completion: nil)
            }
            bringSubview(toFront: pgeCtrl)

        } else {
            guard let issue = issue else { return }
            IssuesManager.shared.fetchIssueImages(issue: issue, uid: issueOwnerId) { [weak self] (images) in
                guard let strongSelf = self else { return }
                strongSelf.orderedViewControllers = [UIViewController]()
                if let imageURL1 = images["image1"], imageURL1 != "" {
                    strongSelf.orderedViewControllers.append(strongSelf.newImageViewController(imageURL1))
                }
                if let imageURL2 = images["image2"], imageURL2 != "" {
                    strongSelf.orderedViewControllers.append(strongSelf.newImageViewController(imageURL2))
                }
                if let imageURL3 = images["image3"], imageURL3 != "" {
                    strongSelf.orderedViewControllers.append(strongSelf.newImageViewController(imageURL3))
                }
                guard let frame = strongSelf.firstImageView?.frame else { return }
                strongSelf.pageView.dataSource = self
                strongSelf.pageView.delegate = self
                strongSelf.pageView.view.frame  = frame
                
                strongSelf.contentView.addSubview(strongSelf.pageView.view)
                
                if let firstViewController = strongSelf.orderedViewControllers.first {
                    strongSelf.pageView.setViewControllers([firstViewController],
                                                direction: .forward,
                                                animated: true,
                                                completion: nil)
                }
                strongSelf.bringSubview(toFront: strongSelf.pgeCtrl)
                strongSelf.pageView.reloadInputViews()
            }
        }
        
        
    }
    
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard orderedViewControllers.count > previousIndex else { return nil }
        
        return orderedViewControllers[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else { return nil }
        guard orderedViewControllersCount > nextIndex else { return nil }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageView.viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    

    
    
}

