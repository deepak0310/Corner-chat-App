//
//  SearchViewController.swift
//  Corner
//
//  Created by MobileGod on 31/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

	@IBOutlet weak var txtViewSearchKeyword: UITextView!
	@IBOutlet weak var btnDone: UIButton!
	
	let placeholderText = "Note: Shops needs ability to search key words. Examples: brand name, customer name, product name"
	let placeholderTextColor = UIColor.init(red: 208, green: 2, blue: 27)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		txtViewSearchKeyword.text = placeholderText
		txtViewSearchKeyword.textColor = placeholderTextColor
		txtViewSearchKeyword.delegate = self
		
		btnDone.setCornerRadius(cornerRadius: 3.0)
		setDisableDoneButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


//
// MARK: - Private Functions
///
///

extension SearchViewController {
	
	
	
	fileprivate func setEnableDoneButton() {
	
		btnDone.setTitleColor(Color.white, for: .normal)
		btnDone.backgroundColor = Color.AppBlue
		btnDone.isEnabled = true
	}
	
	fileprivate func setDisableDoneButton() {
	
		btnDone.setTitleColor(Color.darkGray, for: .normal)
		btnDone.backgroundColor = Color.lightGray
		btnDone.isEnabled = false
	}
}



//
// MARK: - UITextView Delegate
///
///

extension SearchViewController: UITextViewDelegate {

	func textViewDidChange(_ textView: UITextView) {
		
		if textView.text == "" {
			setDisableDoneButton()
		} else {
			setEnableDoneButton()
		}
	}
	
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		
		textView.textColor = UIColor.black
		
		if textView.text == placeholderText {
			textView.text = ""
		}
		
		return true
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		
		if textView.text == "" {
			txtViewSearchKeyword.text = placeholderText
			txtViewSearchKeyword.textColor = placeholderTextColor
		}
	}
}
