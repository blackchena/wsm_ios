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

    private enum MonthOffset: Int {
        case previousMonth = -1
        case currentMonth = 0
        case nextMonth = 1
    }

    // MARK: Properties
    @IBOutlet weak var helpFloaty: Floaty!
    
    fileprivate let requestFloaty = Floaty()
    fileprivate var calendar: FSCalendar!
    fileprivate let calendarCellIdentifier = "calendarCellIdentifier"
    fileprivate var workingTimeSheets: TimeSheetModel?
    fileprivate let gregorian = Calendar.calendarUS
    fileprivate var today = Calendar.calendarUS.todayOfCalendar
    private let buttonHeaderWidth: CGFloat = 40.0
    fileprivate var selectedTimeSheetDay: TimeSheetDayModel?
    fileprivate var shouldShowTimeSheetDayDetail = false
    fileprivate let refreshControl = UIRefreshControl()

    //MARK: IBOutlet
    @IBOutlet weak var timeSheetTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

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
        initCalendar()
        initDateForToday()
    }

    @objc private func pullToRefreshHandler(_: Any) {
        fetchWorkingCalendarData(forDate: self.calendar.currentPage)
    }

    private func initDateForToday() {
        AlertHelper.showLoading()
        guard let month = today.component(.month), let year = today.component(.year) else {
            return
        }
        TimesheetProvider.getUserTimeSheet(month: month, year: year)
            .then { userTimeSheet -> Void in
                guard let timeSheets = userTimeSheet.userTimeSheetData else {
                    return
                }
                self.workingTimeSheets = timeSheets
                let offset = self.adjustMonthOffset(startWorkingDate: timeSheets.startDate,
                    endWorkingDate: timeSheets.endDate, dateToCompare: self.today)
                if offset == .currentMonth {
                    self.updateCalendar(page: self.today, animated: false)
                    AlertHelper.hideLoading()
                } else {
                    self.fetchWorkingCalendarData(forDate: self.today.adjust(.month, offset: offset.rawValue),
                        animated: false)
                }
            }.catch { error in
                AlertHelper.showError(error: error)
            }
    }

    func fetchWorkingCalendarData(forDate date: Date, animated: Bool = true) {
        guard let month = date.component(.month), let year = date.component(.year) else {
            return
        }
        AlertHelper.showLoading()
        shouldShowTimeSheetDayDetail = false
        timeSheetTableView.reloadData()
        TimesheetProvider.getUserTimeSheet(month: month, year: year)
            .then { userTimeSheet -> Void in
                self.workingTimeSheets = userTimeSheet.userTimeSheetData
                self.updateCalendar(page: date, animated: animated)
            }.recover { error in
                AlertHelper.showErrorWithPromise(error: error)
            }.always {
                self.refreshControl.endRefreshing()
                AlertHelper.hideLoading()
            }
    }

    private func updateCalendar(page: Date, animated: Bool) {
        calendar.setCurrentPage(page, animated: animated)
        calendar.reloadData()
        timeSheetTableView.isHidden = false
        timeSheetTableView.reloadData()
    }

    private func adjustMonthOffset(startWorkingDate: Date?, endWorkingDate: Date?, dateToCompare: Date) -> MonthOffset {
        guard let startDate = startWorkingDate, let endDate = endWorkingDate else {
            return .currentMonth
        }
        if dateToCompare >= startDate, dateToCompare <= endDate {
            return .currentMonth
        } else if dateToCompare < startDate {
            return .previousMonth
        } else {
            return .nextMonth
        }
    }

    private func createRequestButton() {
        requestFloaty.addButton(title: LocalizationHelper.shared.localized("create_others_request"), hexColor: "#35F128", image: nil, handler: { _ in
            let createOffVc = getViewController(identifier: "CreateRequestLeaveViewController")
            self.navigationController?.pushViewController(createOffVc, animated: true)
        })

        if let userProfile = UserServices.getLocalUserProfile(), userProfile.isAbleCreateDayOffRequest() {
            requestFloaty.addButton(title: LocalizationHelper.shared.localized("create_request_leave"), hexColor: "#FA003F", image: nil, handler: { _ in
                let createOffVc = getViewController(identifier: "CreateRequestOffViewController")
                self.navigationController?.pushViewController(createOffVc, animated: true)
            })
        }
        requestFloaty.addButton(title: LocalizationHelper.shared.localized("create_request_ot"), hexColor: "#1564C0", image: nil, handler: { _ in
            let createOffVc = getViewController(identifier: "CreateRequestOtViewController")
            self.navigationController?.pushViewController(createOffVc, animated: true)
        })
        
        requestFloaty.paddingX = requestFloaty.paddingY
        requestFloaty.fabDelegate = self
        requestFloaty.buttonColor = UIColor.init(hexString: "#DB4336")
        requestFloaty.buttonImage = UIImage(named: "ic_add")

        self.view.addSubview(requestFloaty)
    }
    
    private func createHelpButton() {
        let object = HelpObject()
        let helpObjects = object.helpObjects
        for helpObject in helpObjects {
            helpFloaty.addButton(title: helpObject.title, hexColor: helpObject.color, image: helpObject.image, titlePosition: .right)
        }
        helpFloaty.fabDelegate = self
        helpFloaty.buttonColor = UIColor.white
    }

    override func loadView() {
        super.loadView()
        createRequestButton()
        createHelpButton()
    }

    private func initCalendar() {
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))

        calendar = FSCalendar(frame: view.frame, with: gregorian)
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.caseOptions = .headerUsesUpperCase
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.headerTitleColor = .appBarTintColor
        calendar.appearance.weekdayTextColor = .appBarTintColor
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.appearance.titleSelectionColor = .darkText
        calendar.appearance.shouldRemovePlaceholderStyle(true)
        calendar.register(TimeSheetViewCell.self, forCellReuseIdentifier: calendarCellIdentifier)
        calendar.clipsToBounds = true
        calendar.placeholderType = .fillHeadTail
        calendar.appearance.titleTodayColor = .darkText
        calendar.scrollEnabled = false
        calendar.swipeToChooseGesture.isEnabled = false
        calendar.allowsMultipleSelection = false

        let preMonthButton = UIButton(type: .roundedRect)
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

        let nextMonthButton = UIButton(type: .roundedRect)
        nextMonthButton.frame = CGRect(x: view.frame.size.width - buttonHeaderWidth - 8, y: 0 + 5,
            width: buttonHeaderWidth, height: 34)
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

        calendar.today = today
        timeSheetTableView.tableHeaderView = view
        timeSheetTableView.isHidden = true
    }
}

// MARK: - FSCalendarDataSource

extension TimeSheetViewController: FSCalendarDataSource {

    func numberOfRows(inMonth month: Date) -> Int {
        if !calendar.currentPage.compare(.isSameMonth(as: month)) {
            return 0
        }
        guard let startDate = workingTimeSheets?.startDate, let endDate = workingTimeSheets?.endDate else {
            return (month.numberOfDaysInMonth() / 7) + 1
        }
        let startOfMonth = month.dateFor(.startOfMonth)
        let endOfMonth = month.dateFor(.endOfMonth)
        let startCountDate = startDate.compare(.isEarlier(than: startOfMonth)) ? startDate : startOfMonth
        let endCountDate = endDate.compare(.isEarlier(than: endOfMonth)) ? endDate : endOfMonth
        let days = gregorian.dateComponents([.day], from: startCountDate, to: endCountDate).day ?? 0
        let weeks = (days / 7) + 1
        return weeks
    }

    func numberOfHeadPlaceholders(forMonth month: Date) -> Int {
        let startOfMonth = month.dateFor(.startOfDay)
        guard let startDate = workingTimeSheets?.startDate?.dateFor(.startOfDay),
              startDate.compare(.isEarlier(than: startOfMonth)) else {
            return 0
        }
        return gregorian.dateComponents([.day], from: startDate.dateFor(.startOfWeek), to: startOfMonth).day ?? 0
    }

    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        return calendar.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: date, at: position)
    }

}

// MARK: - FSCalendarDelegate

extension TimeSheetViewController: FSCalendarDelegate {

    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date,
                  at monthPosition: FSCalendarMonthPosition) {
        guard let cell = cell as? TimeSheetViewCell else {
            return
        }
        let startDate = workingTimeSheets?.startDate
        let endDate = workingTimeSheets?.endDate
        let timesheet = workingTimeSheets?.timeSheetDays?.first(where: {
            $0.date?.compare(.isSameDay(as: date)) == true
        })
        cell.applyStyleAppearanceForCell(dateForCell: date, dateStartWorking: startDate, dateEndWorking: endDate,
            displayDateSetting: timesheet)
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedTimeSheetDay = workingTimeSheets?.timeSheetDays?.first(where: {
            $0.date?.compare(.isSameDay(as: date)) == true
        })
        shouldShowTimeSheetDayDetail = true
        timeSheetTableView.reloadData()
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(origin: calendar.frame.origin, size: bounds.size)
    }

}

extension TimeSheetViewController {

    func preMonthButtonClicked(sender: UIButton!) {
        fetchWorkingCalendarData(forDate: calendar.currentPage.adjust(.month, offset: -1))
    }

    func nextMonthButtonClicked(sender: UIButton!) {
        fetchWorkingCalendarData(forDate: calendar.currentPage.adjust(.month, offset: 1))
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
