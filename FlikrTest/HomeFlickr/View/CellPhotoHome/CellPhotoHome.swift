//
//  CellPhotoHome.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 04/06/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import UIKit
import RxSwift

class CellPhotoHome: UITableViewCell, ReusableIdentifier {
    
    var bag = DisposeBag()
    @IBOutlet weak var lblPicName: UILabel!
    @IBOutlet weak var lblOwnerName: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var imgOfFlickr: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
