# CryptoWalletVIPER
CryptoWallet using VIPER architect, simple app that allow user to see the crypto list and its prices.

## **1. Architecture**
It's written in VIPER using delegation approach. It's quite similar to the traditional version, just that using cummunicate protocols helps us make the responsibility clearer.

Inspire by https://github.com/infinum/iOS-VIPER-Xcode-Templates/tree/master/Templates and https://github.com/uber/RIBs.

The overview architect look like this:
![image](https://koenig-media.raywenderlich.com/uploads/2020/02/viper.png)

## **2. Code structure**

CryptoWalletVIPER
This consists of files being used in the main target.

- Common: Extend some existing classes/structs such as UIViewController, Constant, Builder...
- Protocols: Declare some protocols/base classes being used across the app such as Presentablt/Interactable/Routable...
- Entities: Declare the models/entities used in the app.
- Services: All the API services to interact with BE. Each service is responsible for sending the request to BE and parsing the response or handling failures.
- Screens: Every screen's VIPER components are located in this folder.

- CryptoWalletVIPERUnitTests: This contains all unit tests, mock classes and extensions that being used in unit tests such as WCryptoWalletVIPERTests, MockComponents

- LocalPods
The libs that can be shared between the main target and unit/UI test target are located in LocalPods such as RxSwift, KingFisher.

## **3. Third-party libraries**
Below is the list of third-party libraries that I use in the project:

- **RxSwift/RxCocoa**: It is this project's backbone to seamlessly manipulate UI events (binding between ViewModel and View) as well as API requests/responses. By transforming everything to a sequence of events, it not only makes the logic more understandable and concise but also helps us get rid of the old approach like adding target, delegates, closures which we might feel tedious sometimes.
- **KingFisher**: Quick and easy download image from internet with elegant caching approach.

## **4. Build the project on local**
After cloning the repo, please run `pod install` from your terminal then open CryptoWalletVIPER.xcworkspace and try to build the project using Xcode 12+. It should work without any additional steps.

## **5. Checklist**
- [x] Programming language: Swift

- [x] Design app's architecture: VIPER

- [x] UI matches in the attachment
 
- [x] Dark mode: supported. Try `cmd + shift + A` if you run on simulator.
 
- [x] Unit tests

- [ ] Error handling

- [x] Caching handling

Thanks and have a nice day ahead!
