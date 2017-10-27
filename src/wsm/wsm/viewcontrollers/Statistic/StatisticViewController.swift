//
//  StatisticViewControllerl.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class StatisticViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    private let headerView = StatictisHeaderView()
    private var statisticData: StatisticApiOutputModel?
    fileprivate var listStatistic = [StatisticItemModel]()
    fileprivate var listStatisticGroup = [GroupStatisticsModel]()
    fileprivate var isYear = false
    fileprivate let sectionGroupRowHeight: CGFloat = 70.0
    fileprivate let sectionRowHeight: CGFloat = 35.0
    fileprivate let sectionHeight: CGFloat = 50.0

    override func viewDidLoad() {
        super.viewDidLoad()

        //table header view
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: tableView.frame.width)
        headerView.yearSelectedAction = { [weak self] (year) in
            self?.getStatisticUser(year: year)
        }
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        getStatisticUser()
    }

    func getStatisticUser(year: Int? = nil) {
        AlertHelper.showLoading()
        StatisticProvider.getStatisticUser(year: year)
            .then { apiOutput -> Void in
                self.statisticData = apiOutput
                self.headerView.updateChart(yearData: apiOutput.listStatisticOfYear)
                self.reloadTableView()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }

    func reloadTableView() {
        listStatisticGroup.removeAll()
        listStatistic.removeAll()
        getStatisticData()
        getStatisticGroupData()
        tableView.reloadData()
    }

    func getStatisticGroupData() {
        let leavesData = statisticData?.statisticOfMonth?.numberLeaveTimes
        let offData = statisticData?.statisticOfMonth?.numberDaysOff
        listStatisticGroup.append(GroupStatisticsModel(title: LocalizationHelper.shared.localized("number_of_il_lo_le_forgot_to_swipe_forget_card"),
                                                       detail: [StatisticItemModel(title: LocalizationHelper.shared.localized("approved"),
                                                                                   value: isYear ? leavesData?.approvedInYear : leavesData?.approvedInMonth),
                                                                StatisticItemModel(title: LocalizationHelper.shared.localized("number_of_penalties"),
                                                                                   value: isYear ? leavesData?.rejectedInYear : leavesData?.rejectedInMonth)]))
        listStatisticGroup.append(GroupStatisticsModel(title: LocalizationHelper.shared.localized("number_of_days_off_have_salary"),
                                                       detail: [StatisticItemModel(title: LocalizationHelper.shared.localized("pay_by_company"),
                                                                                   value: isYear ? offData?.haveSalaryPayByCompanyInYear : offData?.haveSalaryPayByCompanyInMonth),
                                                                StatisticItemModel(title: LocalizationHelper.shared.localized("pay_by_insurance"),
                                                                                   value: isYear ? offData?.haveSalaryPayByInsuranceInYear : offData?.haveSalaryPayByInsuranceInMonth)]))
    }

    func getStatisticData() {
        let reaminingData = statisticData?.statisticOfMonth?.numberRemainingDaysOff
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("number_of_days_off_have_not_salary"),
                                                value: isYear ? statisticData?.statisticOfMonth?.numberDaysOff?.noSalaryInYear : statisticData?.statisticOfMonth?.numberDaysOff?.noSalaryInMonth))
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("number_of_overtime"),
                                                value: isYear ? statisticData?.statisticOfMonth?.numberOtHours?.approvedInYear : statisticData?.statisticOfMonth?.numberOtHours?.approvedInMonth))
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("the_number_of_rest_days_previous_year"),
                                                value: reaminingData?.previousYear))
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("the_number_of_rest_days_in_year"),
                                                value: reaminingData?.inYear))
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("number_of_days_off_added_in_this_year"),
                                                value: reaminingData?.bonusInYear))
        listStatistic.append(StatisticItemModel(title: LocalizationHelper.shared.localized("total_of_days_off_remaining_in_year"),
                                                value: reaminingData?.totalRemainInYear))
    }
}

extension StatisticViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticGroupCell", for: indexPath)
                as? StatisticGroupCell else {
                    return UITableViewCell()
            }
            cell.updateCell(group: listStatisticGroup[indexPath.row])
            return cell

        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatisticCell", for: indexPath)
                as? StatisticCell else {
                    return UITableViewCell()
            }
            cell.updateCell(item: listStatistic[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? listStatisticGroup.count : listStatistic.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? sectionGroupRowHeight : sectionRowHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = Bundle.main.loadNibNamed("StatisticSectionHeaderView", owner: self, options: nil)?.first
            as? StatisticSectionHeaderView, section == 0, listStatisticGroup.count > 0 {
            headerCell.setSegmentSelected(index: isYear ? 1 : 0)
            headerCell.sectionChangedAction = { [weak self] (index) in
                self?.isYear = index == 1
                self?.reloadTableView()
            }
            return headerCell
        } else {
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? sectionHeight : 0.0
    }
}

struct StatisticItemModel {
    var title: String?
    var value: Float?
}

struct GroupStatisticsModel {
    var title: String?
    var detail = [StatisticItemModel]()
}
