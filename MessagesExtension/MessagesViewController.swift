//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Justin Dike on 9/21/16.
//  Copyright © 2016 CartoonSmart.com. All rights reserved.
//

import UIKit
import Messages
import StoreKit


class MessagesViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , SKProductsRequestDelegate, SKPaymentTransactionObserver, SKStoreProductViewControllerDelegate  {
    
    var freeArrayNames = [String]()
    var lockedArrayNames = [String]()
    var restoreButton:UIButton = UIButton()
    var buyButton:UIButton = UIButton()
    var bottomButton:UIButton = UIButton()
    var nextButton:UIButton = UIButton()
    var prevButton:UIButton = UIButton()
    var stickersAlreadyBought:Bool = false
    var stickerNames = [String]()
    var orderedStickerNames = [String]()
    var upgradeTimer:Timer = Timer()
    var productIdentifiers =  Set<String>()
    var product: SKProduct?
    var productsArray = [SKProduct]()
    var restoreSilently:Bool = true
    var request:SKProductsRequest?
    var purchasingEnabled:Bool = false
    var debugMode:Bool = true
    let defaults:UserDefaults = UserDefaults.standard
    var inAppID:String = "ALLSTICKERS"
    let bgColor:UIColor = UIColor.white
    var sortByABC:Bool = false
    var lockedStickerCount:Int = 0
    var reallowFreeStickersAt:Int = 0
    var fontToUse:String = "ACME Secret Agent BB"
    var fontSizeRegular:CGFloat = 15
    var buyButtonWider:Bool = false
    var extraVerticalSpacing:CGFloat = 0
    
    var red:Float = 0
    var green:Float = 0
    var blue:Float = 0
    var buttonAlpha:Float = 0.5
    var inFreeMode:Bool = false
    var t:Bool = true
    var lockedImageTag:Int = 555555
    var appOwnID:String = ""
    var isPhone:Bool = true
    var isPortrait:Bool = true
    var cellOffset:Int = 0
    var setCount:Int = 0
    
    var a:String = ""
    var b = [String]()
    var c:Int = 10
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    //var items = ["Sticker0", "Sticker1", "Sticker2", "Sticker3", "Sticker4", "Sticker0", "Sticker1", "Sticker2", "Sticker3", "Sticker4"]
    
    
    var minItemSpacing: CGFloat = 0
    var itemWidth: CGFloat      = 120
    var headerHeight: CGFloat   = 30
    
    
    var purchaseText:String = "Get Every Sticker"
    var purchaseText2:String = ""
    var purchaseText3:String = ""
    var morePacksTitle:String = "Browse More Free Stickers...."
    
    
    
    var storeViewController = SKStoreProductViewController()
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    var allLinks = [String]()
    var allImages = [String]()
    
    var stopOffScreenAnimations:Bool = false
    var deceleration:CGFloat = UIScrollViewDecelerationRateNormal
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            
            isPhone = false
            
            
        }
        
        if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
            isPortrait = false
            print ("is Landscape")
        }
        
        
        
        makeA()
        
        
        collectionView.backgroundColor = UIColor.clear
        
        //0.99 UIScrollViewDecelerationRateFast
        
        collectionView.decelerationRate = deceleration
        
        
        print ("collectionView.decelerationRate \(collectionView.decelerationRate)")
        
        
        let path = Bundle.main.path(forResource:"Stickers", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.object(forKey: "ID") != nil) {
            
            if let theInAppID:String = dict.object(forKey: "ID") as? String {
                
                inAppID = theInAppID
                print (inAppID)
            }
            
            
        }
        
        if (dict.object(forKey: "Background") != nil) {
            
            if let color:String = dict.object(forKey: "Background") as? String {
                
                if ( color == "Black"){
                    
                    self.view.backgroundColor = UIColor.black
                    
                } else if ( color == "White"){
                    
                    self.view.backgroundColor = UIColor.white
                    
                } else {
                    
                    self.view.backgroundColor = UIColor(patternImage: UIImage(named: color)!  )
                    
                }
                
                
            }
            
            
        }
        if (dict.object(forKey: "ExtraVerticalSpacing") != nil) {
            
            if let space:CGFloat = dict.object(forKey: "ExtraVerticalSpacing") as? CGFloat {
                
                extraVerticalSpacing = space
                
            }
            
            
        }
        
        
        if (dict.object(forKey: "TestInPaidMode") != nil) {
            
            if let testInPaid:Bool = dict.object(forKey: "TestInPaidMode") as? Bool {
                
                if (testInPaid == true) {
                    
                    inFreeMode = true
                    self.defaults.set("Purchased", forKey: inAppID)
                    print("WARNING ------- Setting this to FREE basically ------")
                    
                }
            }
            
            
        }
        
        if (dict.object(forKey: "StopOffScreenAnimations") != nil) {
            
            if let theBool:Bool = dict.object(forKey: "StopOffScreenAnimations") as? Bool {
                
                stopOffScreenAnimations = theBool
                
            }
        }
        
        if (dict.object(forKey:a) == nil) {
            
            
            t = false
            
            
        } else {
            
            if let d:String = dict.object(forKey:a) as? String {
                
                if (d.count < c) {
                    
                    
                    t = false
                    
                } else {
                    
                    t = true
                }
                
            }
            
            
        }
        
        if (dict.object(forKey: "Deceleration") != nil) {
            
            if let decel:CGFloat = dict.object(forKey: "Deceleration") as? CGFloat {
                
                deceleration = decel
                
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        //checks the defaults for an object key matching "ALLSTICKERS" and if the value is nil, that means the in-app wasn't purchased yet
        // Note: if the in-app purchase was bought or restored that value will equal "Purchased", but since we are testing for nil, it really doesn't matter.
        
        
        
        
        
        if ( self.defaults.object(forKey: inAppID) == nil) {
            
            
            
            print ( "Not Bought")
            
            self.productIdentifiers.insert(inAppID)
            self.setUpPurchasing()
            
        } else {
            
            print ("already bought")
            stickersAlreadyBought = true
            headerHeight = 0
        }
        
        
        removePurchaseButtons()  //will check if purchased or not
        
        if (t){
            
            parsePropertyList()
            
        }
        
        
        
        print(self.view.bounds.size.width )
        
        
        
        if ( self.view.bounds.size.width >= 414) {
            
            //iPhone 6 Plus
            
            itemWidth = 120
            minItemSpacing = 3
            //89 does 4 across
            
        } else if ( self.view.bounds.size.width == 375) {
            
            //iPhone 6
            
            itemWidth = 88
            //at 89 does 4 across
            
        } else if ( self.view.bounds.size.width == 320) {
            
            //iPhone 5
            
            itemWidth = 90
            //at 89 does 4 across
            
        }else {
            //iPhone SE
            itemWidth = 88
            
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + extraVerticalSpacing)
        layout.minimumInteritemSpacing = minItemSpacing
        layout.minimumLineSpacing = minItemSpacing
        layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)
        
        // Find n, where n is the number of item that can fit into the collection view
        var n: CGFloat = 1
        let containerWidth = collectionView.bounds.width
        while true {
            let nextN = n + 1
            let totalWidth = (nextN*itemWidth) + (nextN-1)*minItemSpacing
            if totalWidth > containerWidth {
                break
            } else {
                n = nextN
            }
        }
        
        // Calculate the section inset for left and right.
        // Setting this section inset will manipulate the items such that they will all be aligned horizontally center.
        let inset = max(minItemSpacing, floor( (containerWidth - (n*itemWidth) - (n-1)*minItemSpacing) / 2 ) )
        layout.sectionInset = UIEdgeInsets(top: minItemSpacing , left: inset, bottom: minItemSpacing , right: inset)
        
        collectionView.collectionViewLayout = layout
        
        
        collectionView.reloadData()
        
    }
    
    
    
    
    
    
    
    func parsePropertyList(){
        
        stickerNames.removeAll()
        orderedStickerNames.removeAll()
        
        
        lockedArrayNames.removeAll()
        
        
        
        let path = Bundle.main.path(forResource:"Stickers", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        
        if ( dict.object(forKey: "StickerList") != nil) {
            
            if let theArray:[  [String : String] ] = dict.object(forKey: "StickerList") as? [[String : String] ] {
                
                for stickerDict in theArray {
                    
                    var isFree:Bool = true
                    var name:String = ""
                    
                    for (key, value) in stickerDict {
                        
                        if (key == "Free") {
                            
                            if (value == "false"){
                                
                                isFree = false
                            }
                            
                        }
                        if (key == "PNG") {
                            
                            name = value
                            
                        }
                        
                    }
                    
                    stickerNames.append(name)
                    
                    if ( isFree == false) {
                        
                        lockedArrayNames.append(name)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        
        
        
        
        
        
        if (dict.object(forKey: "Font") != nil) {
            
            if let theFont:String = dict.object(forKey: "Font") as? String {
                
                fontToUse = theFont
                print (fontToUse)
            }
            
            
        }
        
        
        
        
        
        
        if (dict.object(forKey: "BuyButtonWider") != nil) {
            
            if let wider:Bool = dict.object(forKey: "BuyButtonWider") as? Bool {
                
                buyButtonWider = wider
                print ("Buy Button will be 2/3 instead of half")
            }
            
            
        }
        
        if (dict.object(forKey: "ButtonAlpha") != nil) {
            
            if let alpha:Float = dict.object(forKey: "ButtonAlpha") as? Float {
                
                buttonAlpha = alpha
                
            }
            
            
        }
        if (dict.object(forKey: "Red") != nil) {
            
            if let theRed:Float = dict.object(forKey: "Red") as? Float {
                
                red = theRed
                
            }
            
            
        }
        if (dict.object(forKey: "Blue") != nil) {
            
            if let theBlue:Float = dict.object(forKey: "Blue") as? Float {
                
                blue = theBlue
                
            }
            
            
        }
        if (dict.object(forKey: "Green") != nil) {
            
            if let theGreen:Float = dict.object(forKey: "Green") as? Float {
                
                green = theGreen
                
            }
            
            
        }
        if (dict.object(forKey: "PurchaseText") != nil) {
            
            if let theText:String = dict.object(forKey: "PurchaseText") as? String {
                
                purchaseText = theText
                
            }
            
            
        }
        if (dict.object(forKey: "PurchaseText2") != nil) {
            
            if let theText:String = dict.object(forKey: "PurchaseText2") as? String {
                
                purchaseText2 = theText
                
            }
            
            
        }
        if (dict.object(forKey: "PurchaseText3") != nil) {
            
            if let theText:String = dict.object(forKey: "PurchaseText3") as? String {
                
                purchaseText3 = theText
                
            }
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    @objc func changeUpgradeText() {
        
        if (stickersAlreadyBought == true){
            
            upgradeTimer.invalidate()
            
        } else {
            
            if ( buyButton.superview != nil){
                
                if (buyButton.titleLabel?.text == purchaseText &&  purchaseText2 != "") {
                    
                    buyButton.setTitle(purchaseText2, for: .normal)
                    
                } else if (buyButton.titleLabel?.text == purchaseText2 && purchaseText3 != "") {
                    
                    buyButton.setTitle(purchaseText3, for: .normal)
                    
                } else if (buyButton.titleLabel?.text == purchaseText2 ) {
                    
                    buyButton.setTitle(purchaseText, for: .normal)
                    
                } else if (buyButton.titleLabel?.text == purchaseText3) {
                    
                    buyButton.setTitle(purchaseText, for: .normal)
                    
                }
                
                
                
                
            }
        }
        
        
    }
    
    
    func createTheBuyAndRestoreButtons() {
        
        if ( buyButton.superview == nil) {
            
            buyButton = UIButton(type: .custom)
            
            if (buyButtonWider == true){
                
                buyButton.frame = CGRect(x:0, y:0, width: self.view.bounds.width * 0.66, height: 30)
                
            } else {
                
                buyButton.frame = CGRect(x:0, y:0, width: self.view.bounds.width / 2, height: 30)
            }
            
            
            buyButton.addTarget(self, action:#selector(self.buyInAppPurchase), for: .touchUpInside)
            buyButton.setTitle(purchaseText, for: .normal)
            buyButton.titleLabel!.font = UIFont(name: fontToUse, size:fontSizeRegular)
            buyButton.setTitleColor(UIColor.white, for: .normal)
            buyButton.titleLabel?.adjustsFontSizeToFitWidth = true
            buyButton.backgroundColor =  UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(buttonAlpha))
            collectionView.addSubview(buyButton)
            
            upgradeTimer =  Timer.scheduledTimer(timeInterval: 3,
                                                 target: self,
                                                 selector: #selector(self.changeUpgradeText),
                                                 userInfo: nil,
                                                 repeats: true)
            
        }
        
        if ( restoreButton.superview == nil){
            
            restoreButton = UIButton(type: .custom)
            
            if (buyButtonWider == true){
                
                restoreButton.frame = CGRect(x:self.view.bounds.width * 0.66, y:0, width: self.view.bounds.width * 0.33, height: 30)
                
            } else {
                
                restoreButton.frame = CGRect(x:self.view.bounds.width / 2, y:0, width: self.view.bounds.width / 2, height: 30)
                
            }
            restoreButton.addTarget(self, action:#selector(self.restorePurchasesPressed), for: .touchUpInside)
            restoreButton.setTitle("Restore", for: .normal)
            restoreButton.titleLabel!.font = UIFont(name: fontToUse, size:fontSizeRegular)
            restoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
            restoreButton.setTitleColor(UIColor.white, for: .normal)
            restoreButton.backgroundColor =  UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(buttonAlpha))
            collectionView.addSubview(restoreButton)
            
        }
        
        
    }
    
    
    
    // MARK: - The number of cells in the collection view
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        return self.stickerNames.count  + cellOffset
        
        
    }
    
    
    // MARK: - MAIN COLLECTION VIEW Statement
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print ("setup view")
        
        
        
        var i:Int = 0
        for view in collectionView.subviews {
            
            if ( view .isKind(of: MSStickerView.self)){
                
                i += 1
                
            }
            
        }
        
        // print (i)
        
        if ( stickersAlreadyBought == false ){
            
            createTheBuyAndRestoreButtons ()
            
        }
        
        
        
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        
        
        cell.backgroundColor = UIColor.clear
        
        if ( indexPath.row < stickerNames.count ){
            
            //print ( stickerNames[indexPath.row] )
            
            let stickerPath = Bundle.main.path(forResource: stickerNames[indexPath.row], ofType: "png")
            let stickerURL = URL(fileURLWithPath: stickerPath!)
            
            
            
            if ( collectionView.viewWithTag(indexPath.row + 100) == nil ){
                
                
                
                //print("No tag with ID \(indexPath.row)")
                
                
                
                let sticker: MSSticker
                do {
                    
                    try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: stickerNames[indexPath.row])
                    
                    
                    let newStickerView:MSStickerView = MSStickerView(frame: cell.frame)
                    collectionView.addSubview(newStickerView)
                    newStickerView.tag = indexPath.row + 100
                    newStickerView.sticker = sticker
                    
                    newStickerView.startAnimating()
                    
                    
                    
                    if ( checkIfNameInLockedArray(theName: stickerNames[indexPath.row]) == true && stickersAlreadyBought == false  ) {
                        
                        
                        
                        newStickerView.isUserInteractionEnabled = false
                        let lockView = UIImageView(frame: cell.frame)
                        lockView.image = UIImage(named: "LockIcon")
                        lockView.tag = lockedImageTag
                        collectionView.insertSubview(lockView, aboveSubview: newStickerView)
                        
                        
                        
                    }
                    
                    
                    
                } catch {
                    
                    print(error)
                    
                    
                }
                
                
                
                
            }
            
        }
        
        
        
        
        
        
        if ( inFreeMode == true){
            
            print("WARNING ------- Setting this to FREE basically ------")
        }
        
        
        return cell
    }
    
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if ( stopOffScreenAnimations == true ){
            
            for view in collectionView.subviews {
                
                if let stickerView:MSStickerView = view as? MSStickerView {
                    
                    stickerView.stopAnimating()
                    
                }
                
            }
            
        }
        
    }
    /*
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
     
     }
     */
    
    func checkIfNameInLockedArray(theName:String) -> Bool {
        
        var locked:Bool = false
        
        for name in lockedArrayNames {
            
            if (name == theName){
                
                locked = true
                break
            }
            
            
        }
        
        
        
        return locked
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        if ( stopOffScreenAnimations == true){
            
            var i:Int = 0
            
            for cell in collectionView.visibleCells {
                
                i += 1
                
                for view in collectionView.subviews {
                    
                    
                    if let stickerView:MSStickerView = view as? MSStickerView {
                        
                        
                        
                        if (cell.frame == stickerView.frame) {
                            
                            stickerView.startAnimating()
                            
                        }
                        
                    }
                    
                    
                    
                }
                
                
            }
            
        }
        
    }
    
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        print( indexPath.row  )
        
        if ( indexPath.row >= lockedStickerCount && stickersAlreadyBought == false  ) {
            
            print("lets buy it!")
            buyProduct( inAppID)
            
        }
    }
    
    @objc func buyInAppPurchase() {
        
        print ("purchase")
        buyProduct( inAppID)
        
    }
    @objc func restorePurchasesPressed() {
        
        print ("restore")
        restorePurchases()
        
    }
    
    func unlockAllStickers() {
        
        
        
        
        orderedStickerNames.removeAll()
        lockedArrayNames.removeAll()
        
        
        
        removePurchaseButtons()
        
        
        for theView in collectionView.subviews {
            
            if let stickerView:MSStickerView = theView as? MSStickerView {
                
                
                stickerView.isUserInteractionEnabled = true
                
            }
            
            if let someImage:UIImageView = theView as? UIImageView {
                
                
                
                if (someImage.tag == lockedImageTag){
                    
                    someImage.removeFromSuperview()
                    
                }
                
            }
            
            
            
        }
        
        
        
        
        
    }
    
    func makeA() {
        
        
        b.append(ID.a.rawValue)
        b.append(ID.b.rawValue)
        b.append(ID.c.rawValue)
        b.append(ID.d.rawValue)
        b.append(ID.e.rawValue)
        b.append(ID.c.rawValue)
        b.append(ID.f.rawValue)
        b.append(ID.g.rawValue)
        b.append(ID.h.rawValue)
        b.append(ID.i.rawValue)
        b.append(ID.d.rawValue)
        b.append(ID.j.rawValue)
        b.append(ID.k.rawValue)
        
        for element in b {
            
            a = a + element
            
        }
        
        
        
    }
    
    
    func removePurchaseButtons() {
        
        
        if ( stickersAlreadyBought == true) {
            
            // do stuff like that
            buyButton.isHidden = true
            restoreButton.isHidden = true
            //shareButton.isHidden = true
            //self.offsetY = 0
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        
        // Use this method to prepare for the change in presentation style.
        
        
        if ( presentationStyle == .compact) {
            
            
            
            
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
        
        if ( presentationStyle == .expanded) {
            
            
            
        }
        
        
        
    }
    
    
    
}








