//
//  CryptoWalletVIPERTests.swift
//  CryptoWalletVIPERTests
//
//  Created by Anh Lê on 5/24/21.
//

import XCTest
@testable import CryptoWalletVIPER

class CryptoWalletVIPERTests: XCTestCase {

    var sut: CryptoListPresenter!
    var interactor: MockCryptoListInteractor!
    var router: MockCryptoListRouter!
    var view: MockCryptoListViewable!
    
    let cryptos = [Crypto(base: "BTC", name: "Bitcoin", buy: "40000", sell: "39800", icon: "https://www.google.com", counter: "USD"),
                   Crypto(base: "ETH", name: "Etherium", buy: "3000", sell: "2900", icon: "https://www.google.com", counter: "USD")]
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        view = MockCryptoListViewable()
        view.stubbedViewModels = BehaviorRelay<[CryptoInfoViewModel]>(value: [])
        interactor = MockCryptoListInteractor()
        router = MockCryptoListRouter()
        
        sut = CryptoListPresenter(view: view, interactor: interactor, router: router)
        interactor.presenter = sut
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    // MARK: - Presenter to Interactor
    /// ViewDidLoad -> Interactor get data
    func testGetCryptoList() throws {
        /// Before
        XCTAssertEqual(interactor.invokedGetCryptoList, false)
        XCTAssertEqual(interactor.invokedGetCryptoListCount, 0)
        
        sut.viewDidLoadRelay.accept(())
        
        /// After
        XCTAssertEqual(interactor.invokedGetCryptoList, true)
        XCTAssertEqual(interactor.invokedGetCryptoListCount, 1)
    }
    /// changFavoriteRelay triggerd, invoked func UpdateFavorites
    func testUpdateFavorite() throws {
        /// Before
        XCTAssertEqual(interactor.invokedUpdateFavorite, false)
        XCTAssertEqual(interactor.invokedUpdateFavoriteCount, 0)
        
        sut.changFavoriteRelay.accept("BTC")
        /// After
        XCTAssertEqual(interactor.invokedUpdateFavorite, true)
        XCTAssertEqual(interactor.invokedUpdateFavoriteCount, 1)
    }
    
    // MARK: - Presenter to View
    func testOnGetCryptoListSuccess() throws {
        /// Before
        XCTAssertEqual(view.invokedViewModelsGetter, true)
        XCTAssertEqual(view.invokedViewModelsGetterCount, 1)
        
        XCTAssertEqual(view.invokedEndRefreshing, false)
        XCTAssertEqual(view.invokedEndRefreshingCount, 0)
        
        sut.onSearchCryptoListSuccess(cryptos)
        
        /// After
        XCTAssertEqual(view.invokedViewModelsGetter, true)
        XCTAssertEqual(view.invokedViewModelsGetterCount, 2)
        
        XCTAssertEqual(view.invokedEndRefreshing, true)
        XCTAssertEqual(view.invokedEndRefreshingCount, 1)
    }
    
    func testOnGetCryptoListError() throws {
        /// Before
        XCTAssertEqual(view.invokedViewModelsGetter, true)
        XCTAssertEqual(view.invokedViewModelsGetterCount, 1)
        
        XCTAssertEqual(view.invokedEndRefreshing, false)
        XCTAssertEqual(view.invokedEndRefreshingCount, 0)
        
        sut.onSearchError(ServiceError.recieveNilBody)
        
        /// After
        XCTAssertEqual(view.invokedViewModelsGetter, true)
        XCTAssertEqual(view.invokedViewModelsGetterCount, 1)
        
        XCTAssertEqual(view.invokedEndRefreshing, true)
        XCTAssertEqual(view.invokedEndRefreshingCount, 1)
    }
}
