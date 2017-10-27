//
//  StatictisHeaderView.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Charts
import InAppLocalize

class StatictisHeaderView: UIView {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var yearTextField: UITextField!

    let yearPicker = UIPickerView()
    var yearSelectedAction: ((_ year: Int) -> Void)?

    var years = [Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Performs the initial setup.
    private func setupView() {
        if let view = Bundle.main.loadNibNamed("StatictisHeaderView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            // Auto-layout stuff.
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Show the view.
            addSubview(view)

            setupYearPicker()
            chartView.noDataText = ""
            chartView.setScaleEnabled(false)
        }
    }

    func updateChart(yearData: [StatisticOfYearModel]) {

        let requestOffData = yearData[0].data
        let requestOtherData = yearData[1].data
        let requestOtData = yearData[2].data
        let formater = LineChartFormatter()
        let xAxis = XAxis()

        var lineOffEntry = [ChartDataEntry]()
        var lineOtherEntry = [ChartDataEntry]()
        var lineOtEntry = [ChartDataEntry]()

        for i in 0..<requestOffData.count {

            let offVal = ChartDataEntry(x: Double(i), y: requestOffData[i])
            lineOffEntry.append(offVal)

            let otherVal = ChartDataEntry(x: Double(i), y: requestOtherData[i])
            lineOtherEntry.append(otherVal)

            let otVal = ChartDataEntry(x: Double(i), y: requestOtData[i])
            lineOtEntry.append(otVal)
        }

        xAxis.valueFormatter = formater

        let lineOff = LineChartDataSet(values: lineOffEntry, label: LocalizationHelper.shared.localized("request_off_approved"))
        lineOff.colors = [.blue]
        lineOff.circleColors = [.blue]
        lineOff.mode = .linear

        let lineOther = LineChartDataSet(values: lineOtherEntry, label: LocalizationHelper.shared.localized("request_leave_legend"))
        lineOther.colors = [.darkGray]
        lineOther.circleColors = [.darkGray]
        lineOther.mode = .linear

        let lineOt = LineChartDataSet(values: lineOtEntry, label: LocalizationHelper.shared.localized("request_ot_approved"))
        lineOt.colors = [.green]
        lineOt.circleColors = [.green]
        lineOt.mode = .linear

        let chartData = LineChartData()
        chartData.addDataSet(lineOff)
        chartData.addDataSet(lineOther)
        chartData.addDataSet(lineOt)
        chartData.setDrawValues(false)

        chartView.data = chartData
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chartView.xAxis.valueFormatter = xAxis.valueFormatter
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.animate(xAxisDuration: 1)
    }

    func setupYearPicker() {
        let currentYear = Date().getComponent(.year)
        if years.count == 0 {
            for year in 2000...currentYear {
                years.append(year)
            }
        }

        yearPicker.delegate = self
        yearPicker.selectRow(years.count - 1, inComponent: 0, animated: false)
        yearTextField.layer.borderColor = UIColor.appBarTintColor.cgColor
        yearTextField.layer.borderWidth = 1.0
        yearTextField.layer.cornerRadius = 5.0
        yearTextField.text = "\(currentYear)"
        yearTextField.inputView = yearPicker
        yearTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onYearSelected))
    }

    @objc func onYearSelected() {
        endEditing(true)
        let year = years[yearPicker.selectedRow(inComponent: 0)]
        yearTextField.text = "\(year)"
        yearSelectedAction?(year)
    }
}

extension StatictisHeaderView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(years[row])"
    }
}

@objc(BarChartFormatter)
public class LineChartFormatter: NSObject, IAxisValueFormatter{
    var months = [LocalizationHelper.shared.localized("jan"),
                  LocalizationHelper.shared.localized("feb"),
                  LocalizationHelper.shared.localized("mar"),
                  LocalizationHelper.shared.localized("apr"),
                  LocalizationHelper.shared.localized("may"),
                  LocalizationHelper.shared.localized("jun"),
                  LocalizationHelper.shared.localized("jul"),
                  LocalizationHelper.shared.localized("aug"),
                  LocalizationHelper.shared.localized("sep"),
                  LocalizationHelper.shared.localized("oct"),
                  LocalizationHelper.shared.localized("nov"),
                  LocalizationHelper.shared.localized("dec")]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return months[Int(value)]
    }
}
