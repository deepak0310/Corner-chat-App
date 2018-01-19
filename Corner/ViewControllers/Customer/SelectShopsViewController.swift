//
//  SelectShopsViewController.swift
//  Corner
//
//  Created by MobileGod on 26/01/2017.
//  Copyright © 2017 BSE. All rights reserved.
//

import UIKit
import MapKit


class SelectShopsViewController: AppViewController,CLLocationManagerDelegate
{
    @IBOutlet weak var lbl_noRecordFound: UILabel!
    
	@IBOutlet weak var tableView:	UITableView!

    @IBOutlet weak var segment_listMap: UISegmentedControl!
    public var newMessageVC:		NewMessageViewController!

    @IBOutlet weak var mapView: MKMapView!
    public var shops1 =		DataManager.shared.shops
    public var shops =        [Shop]()

	public var shopsChecked = [Bool]()
	fileprivate let reuseIdOfSwitCell = "SwitchTableViewCell"
	fileprivate let reuseIdOfShopCell = "SelShopTableViewCell"

    let locationManager = CLLocationManager()

    
    var array_selectedCell = [Bool]()
    
    
    
    func sortFunc(num1: Int, num2: Int) -> Bool {
        return num1 < num2
    }
    
    
    
	override func viewDidLoad() {
		super.viewDidLoad()

        lbl_noRecordFound.text = "Oops we haven't made it to your area yet.  Find us on social @cornerchat and tag your local shop that you want to chat with.";
        
        array_selectedCell = shopsChecked.filter{ $0 == true }

		let nibSwitchCell = UINib(nibName: "SwitchTableViewCell", bundle: nil)
		let nibSelShopCell = UINib(nibName: "SelShopTableViewCell", bundle: nil)

		tableView.register(nibSwitchCell, forCellReuseIdentifier: reuseIdOfSwitCell)
		tableView.register(nibSelShopCell, forCellReuseIdentifier: reuseIdOfShopCell)

        tableView.delegate = self
		tableView.dataSource = self

        
        tableView.reloadData()
        tableView.tableFooterView = UIView.init()
        
        tableView.isHidden = false
        
	}
    
    
    @IBAction func action_listMap(_ sender: UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            
            tableView.isHidden = false
            

        
            
        }else
        {
            tableView.isHidden = true
            

            
        }
        
    }
    
}

extension SelectShopsViewController {

	fileprivate func configCell(indexPath: IndexPath) -> UITableViewCell {

//        if indexPath.row == 0 {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfSwitCell, for: indexPath) as! SwitchTableViewCell
//            cell.lblAll.text = "All"
//
//            if numSelShops != shopsChecked.count {
//                cell.swtView.isOn = false
//            } else {
//                cell.swtView.isOn = true
//            }
//
//            cell.swtView.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
//
//            return cell
//
//        } else {

			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdOfShopCell, for: indexPath) as! SelShopTableViewCell

			cell.nameLabel.text = shops[indexPath.row ].name
        cell.lbl_address.text = shops[indexPath.row ].street + ", " + shops[indexPath.row ].city + (NSString(format:"(%.2f", (shops[indexPath.row ].distance)/1609.34) as String) + " miles/" + (NSString(format:"%.2f", (shops[indexPath.row ].distance)/1000) as String) + " km)"
//        cell.nameLabel.text = shop.name
//        cell.streetLabel.text = shop.street
//        cell.cityLabel.text = shop.city

          
            
			if shopsChecked[indexPath.row ] {
				cell.imgCheck.image = #imageLiteral(resourceName: "icn_selected")
			} else {
				cell.imgCheck.image = #imageLiteral(resourceName: "icn_deselected")
			}

			return cell
//        }
	}

	@objc private func switchChanged(sender: UISwitch) {

		if sender.isOn {
			shopsChecked = Array(repeating: true, count: shopsChecked.count)
		} else {
			shopsChecked = Array(repeating: false, count: shopsChecked.count)
		}
        newMessageVC.shopsChecked = shopsChecked

		UIView.setAnimationsEnabled(false)
		tableView.reloadData()
		UIView.setAnimationsEnabled(true)
	}

	fileprivate var numSelShops: Int {
		return shopsChecked.filter{$0 == true}.count
	}
}

extension SelectShopsViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shops.count == 0
        {
            lbl_noRecordFound.isHidden = false;

            return shops.count

        }else
        {
            lbl_noRecordFound.isHidden = true;

            return shops.count

        }
        
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70.0
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 35.0
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let view = UIView(frame: CGRect.init(x: 0, y: 0, width: screenSize.width, height: 35.0))
		view.backgroundColor = UIColor.clear

		return view
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		return configCell(indexPath: indexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		tableView.deselectRow(at: indexPath, animated: true)

//        if indexPath.row > 0 {

            
            
            array_selectedCell = shopsChecked.filter{ $0 == true }

            if shopsChecked[indexPath.row ] == true
            {
                
            }
            
            if (shopsChecked[indexPath.row ] == true)
            {
                shopsChecked[indexPath.row ] = false
                
            }else
            {
                if array_selectedCell.count == 6
                {
                    self.showAlert("", message: "Only 6 stores can be selected")
                    return;
                }
                shopsChecked[indexPath.row ] = true
            }
            
            
            
            print(shopsChecked)
            
//            shopsChecked[indexPath.row - 1] = !shopsChecked[indexPath.row - 1]

            newMessageVC.shopsChecked = shopsChecked
            
			UIView.setAnimationsEnabled(false)
			let indexPathOfSwitchCell = IndexPath(row: 0, section: 0)
			tableView.reloadRows(at: [indexPathOfSwitchCell, indexPath], with: .none)
			UIView.setAnimationsEnabled(true)
//        }
	}
}

