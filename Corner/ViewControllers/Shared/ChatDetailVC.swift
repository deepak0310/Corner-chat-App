//
//  ChatDetailVC.swift
//  Corner
//
//  Created by Marco Cabazal on 3/28/2016.
//  Copyright © 2016 Big Screen Entertainment. All rights reserved.
//

import UIKit
import AlamofireImage
import Firebase
import FirebaseDatabase
import SlackTextViewController
import UIImageView_Letters


let DEBUG_CUSTOM_TYPING_INDICATOR = false
let SHOULD_AUTOCOMPLETE = false

class ChatDetailVC: SLKTextViewController {
    
    var otherUser = User()
    var issue: Issue?
    var conversation: Conversation?
    
    var conversationID: String?
    
    var ref: DatabaseReference!
    var chatHandle: DatabaseHandle?
    var messages = [ChatMessage]()
    
    var editingMessage = ChatMessage()
    var loadingMessages = false
    
    let indexPathForInsertion = IndexPath(row: 0, section: 0)
    let rowAnimation: UITableViewRowAnimation = .bottom
    let scrollPosition: UITableViewScrollPosition = .bottom
    
    
    fileprivate let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    
    override class func tableViewStyle(for decoder: NSCoder) -> UITableViewStyle {
        return .plain
    }
    
    func commonInit() {
        
        NotificationCenter.default.addObserver(self.tableView, selector: #selector(UITableView.reloadData), name: .UIContentSizeCategoryDidChange, object: nil)
        
        // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
        self.registerClass(forTextView: MessageTextView.classForCoder())
        
        if DEBUG_CUSTOM_TYPING_INDICATOR == true {
            // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
            self.registerClass(forTypingIndicatorView: TypingIndicatorView.classForCoder())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        guard let unwrappedIssue = issue else { return }
        //        IssuesManager.shared.markIssueRead(issue: unwrappedIssue)
        loadConversation()
        configureActionItems()
        
        // SLKTVC's configuration
        bounces = true
        shakeToClearEnabled = true
        isKeyboardPanningEnabled = true
        shouldScrollToBottomAfterKeyboardShows = false
        isInverted = true
        
        leftButton.setImage(UIImage(named: "icn_upload"), for: .normal)
        leftButton.tintColor = UIColor.gray
        
        rightButton.setTitle(NSLocalizedString("Send", comment: ""), for: UIControlState())
        
        textInputbar.autoHideRightButton = true
        textInputbar.maxCharCount = 256
        textInputbar.counterStyle = .split
        textInputbar.counterPosition = .top
        
        textInputbar.editorTitle.textColor = UIColor.darkGray
        textInputbar.editorLeftButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        textInputbar.editorRightButton.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        if DEBUG_CUSTOM_TYPING_INDICATOR == false {
            typingIndicatorView!.canResignByTouch = true
        }
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        
        view.backgroundColor = Color.AppGreen
        
        //TODO: (Jun) replace
        tableView.register(MessageTableViewCell.classForCoder(), forCellReuseIdentifier: MessengerCellIdentifier)
        tableView.register(UINib.init(nibName:"ChatImageCell", bundle: nil), forCellReuseIdentifier: "ChatImageCell")
        textView.placeholder = "Message";
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = conversation!.shopName
        textInputbar.subviews.last?.removeFromSuperview()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let y = 20.0 as CGFloat
        let height = view.bounds.size.height - y
        tableView.frame = CGRect(x: 0.0, y: y, width: view.bounds.size.width , height: height)
    }
}

extension ChatDetailVC {
    
    func loadConversation() {
        
        print("chat: getting conversation ID")
        
        self.listenForIncomingMessages()
        
        conversation?.markConversationAsRead()
    }
    
    func listenForIncomingMessages() {
        
        print("chat: starting to listen for incoming messages")
        
        NotificationCenter.default.removeObserver(self, name: .gotIncomingMessageInChat, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showInsertedMessage(_:)), name: .gotIncomingMessageInChat, object: nil)
        
        let conversationRef = IssuesManager.shared.firebaseReference
            .child("/issues/\(issue!.id)/conversations/\(conversation!.id)")
            .queryLimited(toLast: 20)
        
        conversationRef.keepSynced(true)
        
        chatHandle = conversationRef.observe(.childAdded, with: { [weak self] (snapshot) in
            guard let _ = self else { return }
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            let incoming = ChatMessage()
            
            if let value = snapshot.value as? [String: Any] {
                
                incoming.ownerOID = value["owner_oid"] as! String
                incoming.ownerFullname = value["owner_name"] as! String
                incoming.message = value["message"] as! String
                incoming.image = value["image"] as! String
                
                NotificationCenter.default.post(name: .gotIncomingMessageInChat, object: incoming)
                
            }
        })
    }
    
    func showInsertedMessage(_ notification: Notification) {
        
        let incoming = notification.object as! ChatMessage
        tableView.beginUpdates()
        
        messages.insert(incoming, at: 0)
        tableView.insertRows(at: [indexPathForInsertion], with: self.rowAnimation)
        tableView.endUpdates()
        
        tableView.scrollToRow(at: indexPathForInsertion, at: scrollPosition, animated: true)
        
        //		self.tableView.reloadRows(at: [self.indexPathForInsertion], with: .automatic)
    }
    
    func configureActionItems() {
        
        let arrowItem = UIBarButtonItem(image: UIImage(named: "icn_arrow_down"), style: .plain, target: self, action: #selector(ChatDetailVC.hideOrShowTextInputbar(_:)))
        navigationItem.rightBarButtonItem = arrowItem
    }
    
    // MARK: - Action Methods
    func hideOrShowTextInputbar(_ sender: AnyObject) {
        
        guard let buttonItem = sender as? UIBarButtonItem else {
            return
        }
        
        let hide = !isTextInputbarHidden
        let image = hide ? UIImage(named: "icn_arrow_up") : UIImage(named: "icn_arrow_down")
        
        setTextInputbarHidden(hide, animated: true)
        buttonItem.image = image
    }
    
    func simulateUserTyping(_ sender: AnyObject) {
        
        if !canShowTypingIndicator() {
            return
        }
        
        typingIndicatorView!.insertUsername("Boyd Martin")
        
    }
    
    func didLongPressCell(_ gesture: UIGestureRecognizer) {
        
        guard let view = gesture.view else {
            return
        }
        
        if gesture.state != .began {
            return
        }
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.sourceView = view.superview
        alertController.popoverPresentationController?.sourceRect = view.frame
        
        alertController.addAction(UIAlertAction(title: "Edit Message", style: .default, handler: { [weak self] (action) -> Void in
            guard let strongSelf = self else { return }
            strongSelf.editCellMessage(gesture)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    func editCellMessage(_ gesture: UIGestureRecognizer) {
        
        guard let cell = gesture.view as? MessageTableViewCell else {
            return
        }
        
        editingMessage = self.messages[cell.indexPath.row]
        editText(self.editingMessage.message)
        
        tableView.scrollToRow(at: cell.indexPath, at: .bottom, animated: true)
    }
    
    func editLastMessage(_ sender: AnyObject?) {
        
        if self.textView.text.characters.count > 0 {
            return
        }
        
        let lastSectionIndex = self.tableView.numberOfSections-1
        let lastRowIndex = self.tableView.numberOfRows(inSection: lastSectionIndex)-1
        
        let lastMessage = self.messages[lastRowIndex]
        
        editText(lastMessage.message)
        
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
    }
}

// MARK: - Overriden Methods
extension ChatDetailVC {
    
    override func ignoreTextInputbarAdjustment() -> Bool {
        return super.ignoreTextInputbarAdjustment()
    }
    
    override func forceTextInputbarAdjustment(for responder: UIResponder!) -> Bool {
        
        guard let _ = responder as? UIAlertController else {
            // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
            return UIDevice.current.userInterfaceIdiom == .pad
        }
        return true
    }
    
    // Notifies the view controller that the keyboard changed status.
    override func didChangeKeyboardStatus(_ status: SLKKeyboardStatus) {
    }
    
    // Notifies the view controller that the text will update.
    override func textWillUpdate() {
        super.textWillUpdate()
    }
    
    // Notifies the view controller that the text did update.
    override func textDidUpdate(_ animated: Bool) {
        super.textDidUpdate(animated)
    }
    
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    override func didPressLeftButton(_ sender: Any!) {
        super.didPressLeftButton(sender)
        
        dismissKeyboard(true)
        
        openImagePicker()
    }
    
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    override func didPressRightButton(_ sender: Any!) {
        
        textView.refreshFirstResponder()
        
        print("right button tapped")
        ChatMessage.send(message: self.textView.text, issue: issue!, conversation: conversation!)
        Issue.updateIssueUpdatedDate(issue: issue!)
        
        super.didPressRightButton(sender)
    }
    
    override func didPressArrowKey(_ keyCommand: UIKeyCommand?) {
        
        guard let keyCommand = keyCommand else { return }
        
        if keyCommand.input == UIKeyInputUpArrow && self.textView.text.characters.count == 0 {
            editLastMessage(nil)
        }
        else {
            super.didPressArrowKey(keyCommand)
        }
    }
    
    override func keyForTextCaching() -> String? {
        
        return Bundle.main.bundleIdentifier
    }
    
    // Notifies the view controller when the user has pasted a media (image, video, etc) inside of the text view.
    override func didPasteMediaContent(_ userInfo: [AnyHashable: Any]) {
        
        super.didPasteMediaContent(userInfo)
        
        //		let mediaType = userInfo[SLKTextViewPastedItemMediaType] as? Int
        //		let contentType = userInfo[SLKTextViewPastedItemContentType]
        //		let data = userInfo[SLKTextViewPastedItemData]
        
        //		print("didPasteMediaContent : \(contentType!) (type = \(mediaType) | data : \(data))")
        print("didPasteMediaContent")
    }
    
    // Notifies the view controller when a user did shake the device to undo the typed text
    override func willRequestUndo() {
        super.willRequestUndo()
    }
    
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    
    override func didCommitTextEditing(_ sender: Any) {
        
        print ("comitting")
        editingMessage.message = self.textView.text
        tableView.reloadData()
        
        super.didCommitTextEditing(sender)
    }
    
    // Notifies the view controller when tapped on the left "Cancel" button
    override func didCancelTextEditing(_ sender: Any) {
        super.didCancelTextEditing(sender)
    }
    
    override func canPressRightButton() -> Bool {
        return super.canPressRightButton()
    }
    
    override func canShowTypingIndicator() -> Bool {
        
        if DEBUG_CUSTOM_TYPING_INDICATOR == true {
            return true
        }
        else {
            return super.canShowTypingIndicator()
        }
    }
    
    override func shouldProcessText(forAutoCompletion text: String) -> Bool {
        return SHOULD_AUTOCOMPLETE
    }
}

// MARK: - UITableViewDataSource and Delegate Methods
extension ChatDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return self.messages.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.messageCellForRowAtIndexPath(indexPath)
    }
    
    func messageCellForRowAtIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCell(withIdentifier: MessengerCellIdentifier) as! MessageTableViewCell
        let message = self.messages[(indexPath as NSIndexPath).row]
        var urlString = message.image
        
        if urlString.characters.count > 0 && urlString.hasPrefix("http"){
            
            cell = self.tableView.dequeueReusableCell(withIdentifier: "ChatImageCell") as! ChatImageCell
            (cell as! ChatImageCell).chatImageView.af_setImage(withURL: URL(string:urlString)!)
            
        } else {
            
            cell.bodyLabel.text = message.message
            
        }
        
        guard let user = DataManager.shared.currentUser else { return UITableViewCell() }
        
        cell.titleLabel.text = message.ownerFullname
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: MessageTableViewCell.defaultFontSize())
        if message.ownerOID != user.oid {
            cell.titleLabel.textColor = UIColor.init(hex: 0xeb6544, alpha: 1)
            cell.thumbnailView.setImageWith(message.ownerFullname, color: UIColor.init(hex: 0xeb6544, alpha: 1))
        } else {
            cell.titleLabel.textColor = UIColor.init(hex: 0x444444, alpha: 1)
            cell.thumbnailView.setImageWith(message.ownerFullname, color: UIColor.init(hex: 0x0E7CB5, alpha: 1))
            
            if let url = APIManager.keychain[Prefs.avatarKey] {
                var imageUrl = url
                if (imageUrl.characters.count) > 0 {
                    if !((imageUrl.hasPrefix("http"))){
                        imageUrl = "\(AppConfig.apiHost)\(imageUrl)"
                    }
                    if let ul = URL(string:imageUrl) {
                        cell.thumbnailView.af_setImage(withURL: ul)
                    }
                    
                }
                
            }
        }
        
        if cell.gestureRecognizers?.count == nil {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ChatDetailVC.didLongPressCell(_:)))
            cell.addGestureRecognizer(longPress)
        }
        
        cell.indexPath = indexPath
        cell.usedForMessage = true
        
        cell.transform = self.tableView.transform
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            let message = self.messages[(indexPath as NSIndexPath).row]
            
            if message.image.characters.count > 0 {
                return 165.0
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left
            
            let pointSize = MessageTableViewCell.defaultFontSize()
            
            let attributes = [
                NSFontAttributeName : UIFont.systemFont(ofSize: pointSize),
                NSParagraphStyleAttributeName : paragraphStyle
            ]
            
            var width = tableView.frame.width-kMessageTableViewCellAvatarHeight
            width -= 25.0
            
            let titleBounds = (message.ownerFullname as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            let bodyBounds = (message.message as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            if message.message.characters.count == 0 {
                return 0
            }
            
            var height = titleBounds.height
            height += bodyBounds.height
            height += 40
            
            if height < kMessageTableViewCellMinimumHeight {
                height = kMessageTableViewCellMinimumHeight
            }
            
            return height
            
        } else {
            return kMessageTableViewCellMinimumHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}


// MARK: - ImagePickerDelegate
extension ChatDetailVC: UIImagePickerControllerDelegate {
    
    fileprivate func openImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { (action) in
            
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let rollAction = UIAlertAction(title: "Camera roll", style: .default) { (action) in
            
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(rollAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(showInsertedMessage(_:)), name: .gotIncomingMessageInChat, object: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        let localPath = self.saveImageDocumentDirectory(image: selectedImage)
        ChatMessage.uploadImage(message: textView.text, imagePath: "file://\(localPath)", issue: issue!, conversation: conversation!)
        dismiss(animated: true, completion: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(showInsertedMessage(_:)), name: .gotIncomingMessageInChat, object: nil)
        
    }
    
    func saveImageDocumentDirectory(image:UIImage) -> String{
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("image.jpg")
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return paths
    }
}

// MARK: - UIScrollViewDelegate Methods
extension ChatDetailVC {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
    }
}

// MARK: - UITextViewDelegate Methods
extension ChatDetailVC {
    
    override func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    override func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you override this method, to call super.
        return true
    }
    
    override func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return super.textView(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    override func textView(_ textView: SLKTextView, shouldOfferFormattingForSymbol symbol: String) -> Bool {
        
        if symbol == ">" {
            let selection = textView.selectedRange
            
            // The Quote formatting only applies new paragraphs
            if selection.location == 0 && selection.length > 0 {
                return true
            }
            
            // or older paragraphs too
            let prevString = (textView.text as NSString).substring(with: NSMakeRange(selection.location-1, 1))
            
            if CharacterSet.newlines.contains(UnicodeScalar((prevString as NSString).character(at: 0))!) {
                return true
            }
            
            return false
        }
        
        return super.textView(textView, shouldOfferFormattingForSymbol: symbol)
    }
    
    override func textView(_ textView: SLKTextView, shouldInsertSuffixForFormattingWithSymbol symbol: String, prefixRange: NSRange) -> Bool {
        
        if symbol == ">" {
            return false
        }
        
        return super.textView(textView, shouldInsertSuffixForFormattingWithSymbol: symbol, prefixRange: prefixRange)
    }
}
