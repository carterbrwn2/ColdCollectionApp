//
//  CalendarViewController.swift
//  Cold Collection
//
//  Created by Carter Brown on 7/30/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    let formatter = DateFormatter()
    var dateSelected = ""
    var eventsOnDate = 0
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    // Set colors for calendar
    let outsideMonthColor = UIColor.darkGray
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(red: 0/255, green: 100/255, blue: 200/255, alpha: 1)
    let currentDateTextColor = UIColor(red: 0/255, green: 100/255, blue: 200/255, alpha: 1)
    let currentDateSelectedViewColor = UIColor(red: 20/255, green: 120/255, blue: 180/255, alpha: 1)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set UITableView style
        myTableView.separatorStyle = .none
        
        // Initialize dateSelected
        initDate()
        
        // Calendar setup
        setupCalendarView()
        
        // Side menu setup
        sideMenus()
        customizeNavBar()
        
        // Scroll to today's date and highlight it
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
    }
    
    // Display message when a user adds an event to their calendar
    @IBAction func addEventWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Event added", message: "The event was added to your calendar. You will be notified 24 hours before.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // On load, makes sure dateSelected is not an empty String
    func initDate() {
        formatter.dateFormat = "yyyy MM dd"
        dateSelected = formatter.string(from: Date())
    }

    // Setup calendar spacing and labels
    func setupCalendarView() {
        // Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    // Sets year and month text
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        // Year
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        // Month
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    // Sets cell text color
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {  // Cell is not selected
            if isTodaysDate(cellState: cellState) {
                validCell.dateLabel.textColor = currentDateTextColor
            } else if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    // Reloads the table data based on the date currently selected
    func updateTableView(cellState: CellState) {
        dateSelected = formatter.string(from: cellState.date)
        if EVENT_MAP.events.keys.contains(dateSelected) {
            eventsOnDate = (EVENT_MAP.events[dateSelected]?.count)!
        } else {
            eventsOnDate = 0
        }
        
        myTableView.reloadData()
    }
    
    // Handles cell being selected/deselected
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        formatter.dateFormat = "yyyy MM dd"
        if cellState.isSelected {
            updateTableView(cellState: cellState)
            validCell.selectedView.isHidden = false
            validCell.eventView.backgroundColor = selectedMonthColor
        } else {    // Cell was deselected
            validCell.selectedView.isHidden = true
            if isTodaysDate(cellState: cellState) {
                validCell.todaysView.isHidden = false
            } else {
                validCell.todaysView.isHidden = true
            }
            if cellState.dateBelongsTo != .thisMonth {
                validCell.eventView.backgroundColor = UIColor.darkGray
            } else {
                validCell.eventView.backgroundColor = UIColor.white
            }
        }
    }
    
    // Returns string that is the passed date + 1 year
    func addYearToDate(date: String) -> String {
        let nonLeapInterval: TimeInterval = 31536000
        let leapInterval: TimeInterval = 31622400

        let leap = isLeapYear(date: date)
        var newDate: String
        if leap {
            newDate = String(Date().addingTimeInterval(leapInterval).description.prefix(8)).replacingOccurrences(of: "-", with: " ")+"01"
        } else {
            newDate = String(Date().addingTimeInterval(nonLeapInterval).description.prefix(8)).replacingOccurrences(of: "-", with: " ")+"01"
        }

        return newDate
    }
    
    // Returns whether or not passed year is a leap year
    func isLeapYear(date: String) -> Bool {
        let year = Int(date.prefix(4))!
        return year % 4 == 0 && (year % 400 == 0 || year % 100 != 0)
    }
    
    // Function to compare passed CellState.date to current date
    func isTodaysDate(cellState: CellState) -> Bool {
        formatter.dateFormat = "yyyy MM dd"
        
        let compDate = formatter.string(from: cellState.date)
        let todaysDate = formatter.string(from: Date())
        
        return compDate == todaysDate
    }
    
    /*
     sideMenus() and customizeNavBar() set up the side menu --------------------------------------------
     */
    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 70
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1)

        navigationController?.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName: UIColor.white] as [NSAttributedStringKey : Any]
    }
    
    // -------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

/*
 Setting up the UITableView for the events on the selected date ----------------------------------------
*/
extension CalendarViewController: UITableViewDelegate {
    // nothing to do here
}

extension CalendarViewController: UITableViewDataSource {
    // Return number of sections in Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // Return number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if section > 0 {
            numberOfRows = eventsOnDate
        }
        
        return numberOfRows
    }
    
    // Initializes Table View section headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont(name: "Arial-BoldItalicMT", size: 17)

        formatter.dateFormat = "yyyy MM dd"
        let myDate = formatter.date(from: dateSelected)
        formatter.dateFormat = "MMM dd yyyy"
        let myDateString = formatter.string(from: myDate!)
        
        if section == 0 {
            label.text = myDateString
        } else {
            label.text = "Events"
        }
        
        return label
    }
    
    // Sets height of section headers
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.init(30)
    }
    
    // Initializes each cell - only runs when date selected has events associated with it
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventCell
        
        // Setup text view
        let name = EVENT_MAP.events[dateSelected]![indexPath.row].artistName
        let type = EVENT_MAP.events[dateSelected]![indexPath.row].eventType
        let title = EVENT_MAP.events[dateSelected]![indexPath.row].title
        
        cell.myTextView.text = "Artist Name: "+name+"\nEvent Type: "+type+"\nTitle: "+title
        
        // Setup add event button
        cell.setEventIndex(index: indexPath.row)
        cell.setDate(date: dateSelected)
        
        return cell
    }
    
}

// -----------------------------------------------------------------------------------------------------

/*
 Setting up the Calendar -------------------------------------------------------------------------------
 */
extension CalendarViewController: JTAppleCalendarViewDataSource {
    // Setup and configure calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let thisDate = String(Date().description.prefix(8)).replacingOccurrences(of: "-", with: " ")+"01"

        let endDateString = addYearToDate(date: thisDate)
        
        let startDate = formatter.date(from: thisDate)!
        let endDate = formatter.date(from: endDateString)!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    // willDisplay function
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        
        // Put all code here
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    // cellForItemAtIndex function (Display the cell)
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        // Put all code here
        sharedFunctionToConfigureCell(myCustomCell: cell, cellState: cellState, date: date)

        return cell
    }
    
    // Code for selecting date
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // Code for deselecting date
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    // Update year and month labels
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
    // configureCell function to avoid code duplication
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date) {
        myCustomCell.dateLabel.text = cellState.text
        formatter.dateFormat = "yyyy MM dd"
        if EVENT_MAP.events.keys.contains(formatter.string(from: cellState.date)) {
            if cellState.dateBelongsTo == .thisMonth {
                myCustomCell.eventView.backgroundColor = UIColor.white
            } else {
                myCustomCell.eventView.backgroundColor = UIColor.darkGray
            }
            myCustomCell.eventView.isHidden = false
        } else {
            myCustomCell.eventView.isHidden = true
        }
        
        handleCellSelected(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
    }
    
    // -----------------------------------------------------------------------------------------------------

}



