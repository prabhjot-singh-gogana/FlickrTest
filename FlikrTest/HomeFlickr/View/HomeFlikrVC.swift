//
//  ViewController.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 29/05/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class HomeFlikrVC: UITableViewController {
    // diposable bag is used to avoid the memory leaks
    private let disposeBag = DisposeBag()
    var homeViewModel = HomeFlikrViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBindings()
        homeViewModel.requestData()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        // Registering CellPhotoHome
        self.tableView.registerReusableIDCell(CellPhotoHome.self)
        
        //        // binding loading to vc
        //        homeViewModel.loading
        //            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        
        //home save photos statically or globally
        homeViewModel.photoFlikr.subscribeOn(MainScheduler.instance).subscribe(onNext: { (photos) in
            DispatchQueue.main.async {
                photosFlickrGlobal = photos
                self.tableView.reloadData()
            }
        }).disposed(by:disposeBag)
        
        // observing errors to show
        homeViewModel
            .error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (error) in
                switch error {
                case .internetError(let message):
                    print("Error - \(message)")
                case .serverMessage(let message):
                    print("Warning - \(message)")
                }
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeFlikrVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosFlickrGlobal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CellPhotoHome = tableView.dequeueReusableIDCell(indexPath: indexPath)
        let element = photosFlickrGlobal[indexPath.row]
        cell.lblPicName.text = element.title
        cell.lblOwnerName.text = element.ownername
        cell.btnFav.isSelected = element.isFav
        cell.btnFav.tag = indexPath.row
        cell.imgOfFlickr?.loadImage(fromURL: element.url) // Cache used here
        cell.btnFav.rx.controlEvent(.touchUpInside).bind { [weak self] in
            photosFlickrGlobal[indexPath.row].isFav = !photosFlickrGlobal[indexPath.row].isFav
            cell.btnFav.isSelected = photosFlickrGlobal[indexPath.row].isFav
            if photosFlickrGlobal[indexPath.row].isFav == true {
                //                Add then Observe or notify the photoFlikrFav object
                self?.homeViewModel.photoFlikrFav.add(element: photosFlickrGlobal[indexPath.row])
            } else {
                //                Remove then Observe or notify the photoFlikrFav object
                self?.homeViewModel.photoFlikrFav.removeItem(element: element)
            }
        }.disposed(by: cell.bag)
        return cell
    }
    
    //    Used to do the animation for uitable view
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell: CellPhotoHome = tableView.dequeueReusableIDCell(indexPath: indexPath)
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 0, 0)
        cell.layer.transform = transform
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            cell.alpha = 1
            cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}



