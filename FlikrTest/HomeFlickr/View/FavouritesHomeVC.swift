//
//  FavouritesHomeVC.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 04/06/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class FavouritesHomeVC: UITableViewController {
    private let disposeBag = DisposeBag()
    var homeViewModel: HomeFlikrViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupBindings()
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        
        tableViewBindings()
    }
    
//    Table binding
    func tableViewBindings() {
        // fetch the object from tab bar controller
        guard let homeVC: HomeFlikrVC = self.tabBarController?.findController() else {return}
        self.homeViewModel = homeVC.homeViewModel
        //registered the cell
        self.tableView.registerReusableIDCell(CellPhotoHome.self)
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        //bind the photoFlikrFav to observe their changes and use it for creating the cell through bindings
        homeViewModel?.photoFlikrFav.bind(to: self.tableView.rx.items(cellIdentifier: String(describing: CellPhotoHome.self), cellType: CellPhotoHome.self)) {  (row,element,cell) in
            cell.lblPicName.text = element.title
            cell.lblOwnerName.text = element.ownername
            cell.btnFav.isSelected = element.isFav
            cell.imgOfFlickr?.loadImage(fromURL: element.url)
            cell.btnFav.rx.controlEvent(.touchUpInside).bind {
                if let index = photosFlickrGlobal.firstIndex(where: {$0.picID == element.picID}){
                    photosFlickrGlobal[index].isFav = false
                }
                cell.btnFav.isSelected = false
//                remved item and it will notify the photoFlikrFav it will call the table no need to reload the table.
                self.homeViewModel?.photoFlikrFav.removeItem(element: element)
//                just reloadind the visible cell no need to reload all table
                DispatchQueue.main.async {
                    homeVC.tableView.reloadRows(at: homeVC.tableView?.indexPathsForVisibleRows ?? [], with: .none)
                }
            }.disposed(by: cell.bag)
        }.disposed(by: disposeBag)
    }
    
}


