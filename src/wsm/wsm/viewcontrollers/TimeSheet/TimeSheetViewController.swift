//
//  TimeSheetViewController.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Floaty
import InAppLocalize
import PromiseKit

class TimeSheetViewController: BaseViewController, FloatyDelegate {

    //MARK: properties
    fileprivate let floaty = Floaty()
    fileprivate var calendar: FSCalendar!
    fileprivate let calenderIdentifier = "wsmCalendar"
    fileprivate let calenderCellIdentifier = "calenderCellIdentifier"
    fileprivate var workingTimeSheets: TimeSheetModel?
    fileprivate var gregorian: Calendar!
    fileprivate var preMonthButton: UIButton!
    fileprivate var nextMonthButton: UIButton!
    fileprivate var today = Calendar.calendarUS.todayOfCalendar
    private let buttonHeaderWidth: CGFloat = 40.0
    fileprivate var selectedTimeSheetDay: TimeSheetDayModel?
    fileprivate var shouldShowTimeSheetDayDetail = false
    fileprivate let refreshControl = UIRefreshControl()

    //MARK: IBOutlet
    @IBOutlet weak var timeSheetTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        gregorian = Calendar.calendarUS

        timeSheetTableView.delegate = self
        timeSheetTableView.dataSource = self

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            timeSheetTableView.refreshControl = refreshControl
        } else {
            timeSheetTableView.addSubview(refreshControl)
        }

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler(_:)), for: .valueChanged)

        initDateForToday()
    }

    @objc private func pullToRefreshHandler(_: Any) {
        fetchWorkingCalendarData(forDate: self.calendar.currentPage)
    }

    //1. run API with today value
    //2.1 check if: start ..-> today ..-> end working date => keep current page
    //2.2 check if: today ..-> start ..-> end working date => this case never happend -> just set null for API return value -> display normal calendar
    //2.3 check if: start ..-> end ..-> today working date => call API with value of current endWorkingDate.addMonth(1) value (month, year)
    //2.3.1 move currrent page to next page
    private func initDateForToday() {
        AlertHelper.showLoading()

        if let cutOffDate = UserServices.getLocalUserProfile()?.company?.cutOffDate,
            let dayOfToday = today.component(.day),
            dayOfToday > cutOffDate {
            today = today.dateFor(.startOfMonth).adjust(.month, offset: 1)
        }

        TimesheetProvider.getUserTimeSheet(month: today.component(.month)!, year: today.component(.year)!)
            .then { userTimeSheet -> Void in

                self.workingTimeSheets = userTimeSheet.userTimeSheetData
                if let workingTimeSheets = self.workingTimeSheets {
                    let correctMonthOffSet = -self.correctMonthAdujstOffSet(startWorkingDate: workingTimeSheets.startDate?.dateFor(.startOfDay),
                                                                            endWorkingDate: workingTimeSheets.endDate?.dateFor(.startOfDay),
                                                                            currentPage: self.today)

                    if correctMonthOffSet == 1 {
                        let nextWorkingMonth = self.today.adjust(.month, offset: correctMonthOffSet)
                        self.fetchWorkingCalendarData(forDate: nextWorkingMonth, withAnimation: false)
                    } else if correctMonthOffSet == -1 {
                        self.workingTimeSheets = nil
                        AlertHelper.hideLoading()
                    } else {
                        //update cutOffDay on UserProfile
                        if let userProfile = UserServices.getLocalUserProfile() {
                            userProfile.company?.cutOffDate = workingTimeSheets.endDate?.component(.day)
                            UserServices.saveUserProfile(userProfileResult: userProfile)
                        }
                        AlertHelper.hideLoading()
                    }
                }
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                self.createFSCalendar(withToday: self.today)
                self.calendar.setCurrentPage(self.today, animated: false)
                self.calendar.reloadData()
                self.timeSheetTableView.reloadData()
        }
    }

    func fetchWorkingCalendarData(forDate date: Date, withAnimation: Bool = true) {
        firstly { _ -> Promise<TimeSheetApiOutputModel>  in

            self.shouldShowTimeSheetDayDetail = false
            self.timeSheetTableView.reloadData()
            AlertHelper.showLoading()

            return TimesheetProvider.getUserTimeSheet(month: date.component(.month)!, year: date.component(.year)!)
            }.then { userTimeSheet -> Void in
                if let workingTimeSheets = userTimeSheet.userTimeSheetData {
                    self.workingTimeSheets = workingTimeSheets
                    //update cutOffDay on UserProfile
                    if let userProfile = UserServices.getLocalUserProfile() {
                        userProfile.company?.cutOffDate = workingTimeSheets.endDate?.component(.day)
                        UserServices.saveUserProfile(userProfileResult: userProfile)
                    }

                    self.correctCalendarDisplayCurrentPage(startWorkingDate: workingTimeSheets.startDate,
                                                           endWorkingDate: workingTimeSheets.endDate,
                                                           currentPage: self.calendar.currentPage,
                                                           withAnimation: withAnimation)
                }
            }.recover { error in
                AlertHelper.showErrorWithPromise(error: error)
            }.always {
                self.refreshControl.endRefreshing()
                AlertHelper.hideLoading()
        }
    }

    /**
     * each page which is have the calendar.currentPage is the first day of current month
     * if new workingTimeSheets is nil -> keep current state
     * 1. if the new startWorkingDay ->.. currentPage ->.. endWorkingDay |=> keep display currentPage
     * 2. if the     currentPage ->.. new startWorkingDay ->.. endWorkingDay |=> display next page
     * 3. if the new startWorkingDay ->.. endWorkingDay ->.. currentPage |=> display previous page
     */
    private func correctMonthAdujstOffSet(startWorkingDate: Date?, endWorkingDate: Date?, currentPage: Date) -> Int {
        var offset = 0
        if let startWorkingDate = startWorkingDate,
            let endWorkingDate = endWorkingDate {
            if (currentPage.compare(.isLater(than: startWorkingDate)) || currentPage.compare(.isSameDay(as: startWorkingDate))) &&
                (currentPage.compare(.isEarlier(than: endWorkingDate)) || currentPage.compare(.isSameDay(as: endWorkingDate))) {
                //case 1
                offset = 0
            } else if currentPage.compare(.isEarlier(than: startWorkingDate)) {
                //case 2
                offset = 1
            } else if currentPage.compare(.isLater(than: endWorkingDate)) {
                //case 3
                offset = -1
            }
        }

        print("startWorkingDate: \(String(describing: startWorkingDate)) , endWorkingDate: \(String(describing: endWorkingDate)) , currentPage: \(currentPage) , offset: \(offset)")
        return offset
    }


    /**
     * Correct display of calendar page
     */
    private func correctCalendarDisplayCurrentPage(startWorkingDate: Date?, endWorkingDate: Date?, currentPage: Date, withAnimation: Bool = true) {
        let offSet = self.correctMonthAdujstOffSet(startWorkingDate: startWorkingDate,
                                                   endWorkingDate: endWorkingDate,
                                                   currentPage: currentPage)
        let newPage = currentPage.adjust(.month, offset: offSet)
        self.calendar.setCurrentPage(newPage, animated: withAnimation)
        self.calendar.reloadData()
        self.timeSheetTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func createRequestButton() {
        floaty.addButton(title: LocalizationHelper.shared.localized("create_others_request"), hexColor: "#35F128")
        floaty.addButton(title: LocalizationHelper.shared.localized("create_request_leave"), hexColor: "#FA003F", image: nil, handler: { _ in
            let createOffVc = UIViewController.getStoryboardController(identifier: "CreateRequestOffViewController")
            self.navigationController?.pushViewController(createOffVc, animated: true)
        })
        floaty.addButton(title: LocalizationHelper.shared.localized("create_request_ot"), hexColor: "#1564C0")

        floaty.paddingX = floaty.paddingY
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.init(hexString: "#DB4336")
        floaty.buttonImage = UIImage(named: "ic_add")




        self.view.addSubview(floaty)
    }

    override func loadView() {
        super.loadView()
        createRequestButton()
    }

    func createFSCalendar(withToday: Date?) {
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300

        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: UIScreen.main.bounds.width,
                                        height: height))
        view.backgroundColor = UIColor.white

        let calendar = FSCalendar(frame: view.frame, with: Calendar.calendarUS)
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.accessibilityIdentifier = calenderIdentifier

        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.caseOptions = .headerUsesUpperCase

        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.headerTitleColor = UIColor.appBarTintColor
        calendar.appearance.weekdayTextColor = UIColor.appBarTintColor
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.titleSelectionColor = UIColor.darkText
        calendar.appearance.shouldRemovePlaceholderStyle(true)
        calendar.register(TimeSheetViewCell.self, forCellReuseIdentifier: calenderCellIdentifier)
        calendar.clipsToBounds = true // Remove top/bottom line
        calendar.placeholderType = .fillHeadTail
        calendar.appearance.titleTodayColor = UIColor.darkText

        calendar.scrollEnabled = false
        calendar.swipeToChooseGesture.isEnabled = false
        calendar.allowsMultipleSelection = false
        //        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        //        calendar.addGestureRecognizer(scopeGesture)

        //init pre and next button on header
        preMonthButton = UIButton(type: .roundedRect)
        preMonthButton.frame = CGRect(x: 0 + 8, y: 0 + 5, width: buttonHeaderWidth, height: 34)
        preMonthButton.backgroundColor = UIColor.clear
        preMonthButton.layer.cornerRadius = 8
        preMonthButton.layer.borderWidth = 1
        preMonthButton.layer.borderColor = UIColor.appBarTintColor.cgColor
        preMonthButton.setTitle("◀︎", for: .normal)
        preMonthButton.titleLabel?.adjustsFontSizeToFitWidth = true
        preMonthButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        preMonthButton.setTitleColor(UIColor.appBarTintColor, for: .normal)
        preMonthButton.addTarget(self, action: #selector(preMonthButtonClicked), for: .touchUpInside)
        view.addSubview(preMonthButton)

        nextMonthButton = UIButton(type: .roundedRect)
        nextMonthButton.frame = CGRect(x: self.view.frame.size.width - buttonHeaderWidth - 8, y: 0 + 5, width: buttonHeaderWidth, height: 34)
        nextMonthButton.backgroundColor = UIColor.clear
        nextMonthButton.layer.cornerRadius = 8
        nextMonthButton.layer.borderWidth = 1
        nextMonthButton.layer.borderColor = UIColor.appBarTintColor.cgColor
        nextMonthButton.setTitle("▶︎", for: .normal)
        nextMonthButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextMonthButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextMonthButton.setTitleColor(UIColor.appBarTintColor, for: .normal)
        nextMonthButton.addTarget(self, action: #selector(nextMonthButtonClicked), for: .touchUpInside)
        view.addSubview(nextMonthButton)

        if let withToday = withToday {
            calendar.today = withToday
        }

        timeSheetTableView.tableHeaderView = view
    }
}

extension TimeSheetViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        return calendar.dequeueReusableCell(withIdentifier: calenderCellIdentifier, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar,
                  willDisplay cell: FSCalendarCell,
                  for date: Date,
                  at monthPosition: FSCalendarMonthPosition) {

        guard let timeSheetCell = cell as? TimeSheetViewCell else {
            return
        }

        timeSheetCell.applyStyleAppearanceForCell(dateForCell: date,
                                                  dateStartWorking: self.workingTimeSheets?.startDate,
                                                  dateEndWorking: self.workingTimeSheets?.endDate,
                                                  displayDateSetting: self.workingTimeSheets?.timeSheetDays?.first(where: {
                                                    $0.date?.compare(.isSameDay(as: date)) ?? false }))

    }
}

extension TimeSheetViewController: FSCalendarDelegate {

    func numberOfHeadPlaceholders(forMonth month: Date) -> Int {
        var mustAddNumber = 0

        let dateStartOfMonth = month.dateFor(.startOfDay)
        if let dateStartWorking = workingTimeSheets?.startDate?.dateFor(.startOfDay) {

            if dateStartWorking.compare(.isEarlier(than: dateStartOfMonth)) {
                let daysMustAdd = gregorian.dateComponents([.day], from: dateStartWorking.dateFor(.startOfWeek), to: dateStartOfMonth).day
                mustAddNumber = daysMustAdd ?? 0
            }
        }

        if mustAddNumber == 0 {
            //if cannot get mustAddNumber or the case: dateStartOfMonth -> dateStartWorking, just fill the date of week containt dateStartOfMonth
            let currentWeekday = gregorian.component(.weekday, from: month)
            let number = ((currentWeekday - gregorian.firstWeekday) + 7) % 7
            mustAddNumber = number
        }

        return mustAddNumber
    }

    func numberOfRows(inMonth month: Date) -> Int {
        return 6
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedTimeSheetDay = self.workingTimeSheets?.timeSheetDays?.first(where: {
            $0.date?.compare(.isSameDay(as: date)) ?? false })

        self.shouldShowTimeSheetDayDetail = true
        self.timeSheetTableView.reloadData()
    }
}

extension TimeSheetViewController {

    func preMonthButtonClicked(sender: UIButton!) {
        fetchWorkingCalendarData(forDate: self.calendar.currentPage.adjust(.month, offset: -1), withAnimation: true)
    }

    func nextMonthButtonClicked(sender: UIButton!) {
        fetchWorkingCalendarData(forDate: self.calendar.currentPage.adjust(.month, offset: 1), withAnimation: true)
    }
}

extension TimeSheetViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            //data for selected date
            return self.shouldShowTimeSheetDayDetail && self.selectedTimeSheetDay != nil ? 1 : 0
        } else {
            return self.workingTimeSheets != nil ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.selectedTimeSheetDay != nil ? (self.selectedTimeSheetDay?.hoursOverTime ?? 0 > 0  ?  124 : 90) : 0
        } else {
            return 300
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            indexPath.section == 0 ?
                "TimeSheetDetailViewCell" : "TimeSheetSummaryViewCell", for: indexPath)

        if indexPath.section == 0,
            let cellDetail = cell as? TimeSheetDetailViewCell {
            cellDetail.setTimeSheetDayModel(timeSheet: self.selectedTimeSheetDay)
        } else if let cellInfo = cell as? TimeSheetSummaryViewCell {
            cellInfo.setTimeSheetInfo(timeSheet: self.workingTimeSheets)
        }
        
        return cell
    }
    
    
    
}

extension TimeSheetViewController: UITableViewDelegate {
}
