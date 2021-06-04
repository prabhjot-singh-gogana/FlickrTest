//
//  HomeViewModel.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 03/06/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct HomeFlikrViewModel {
//    6f3c1390c25d372643ad0d9b8f8db21c
    public enum HomeError {
        case internetError(String)
        case serverMessage(String)
    }
    
    public let photoFlikr : PublishSubject<[FlickrPhoto]> = PublishSubject()
    public var photoFlikrFav : BehaviorRelay<[FlickrPhoto]> = BehaviorRelay<[FlickrPhoto]>(value: [FlickrPhoto]())
//    public let loading: PublishSubject<Bool> = PublishSubject()
    public let error : PublishSubject<HomeError> = PublishSubject()
    
    private let disposable = DisposeBag()
    
    
    public func requestData(){
//        self.loading.onNext(true)
/*        Added the url with base url. get parameters can put on parameter as well but it will work too just for API. I prefer my generic API https://github.com/prabhjot-singh-gogana/PSAPI
         which workd with Alamofire please have a look.
 */
        APIManager.requestData(url: "?method=flickr.people.getPublicPhotos&api_key=6f3c1390c25d372643ad0d9b8f8db21c&user_id=65789667%40N06&extras=url_m%2Cowner_name&format=json&nojsoncallback=1", method: .get, parameters: nil, completion: { (result) in
//            self.loading.onNext(false)
            switch result {
            case .success(let returnJson):
                let photosJson = returnJson["photos"]
                let photos = photosJson["photo"].arrayValue.compactMap {
                    return FlickrPhoto(data: try! $0.rawData()) // no need to fill the data used codable protocol for that.
                }
                self.photoFlikr.onNext(photos) // observing photos

            case .failure(let failure) :
                switch failure {
                case .connectionError:
                    self.error.onNext(.internetError("Check your Internet connection."))
                case .authorizationError(let errorJson):
                    self.error.onNext(.serverMessage(errorJson["message"].stringValue))
                default:
                    self.error.onNext(.serverMessage("Unknown Error"))
                }
            }
        })
        
    }
}
