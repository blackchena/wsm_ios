//
//  TimeSheetViewCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

private enum TimeSheetCellStyleAppearance {
    case none
    case today
    case ot
    case morning(withColor: UIColor?)
    case afternoon(withColor: UIColor?)
}

class TimeSheetViewCell: FSCalendarCell {
    private weak var morningLayer: CAShapeLayer!
    private weak var afternoonLayer: CAShapeLayer!
    private weak var todayLayer: CAShapeLayer!
    private weak var otLayer: CAShapeLayer!
    private weak var borderLayer: CAShapeLayer!

    //MARK: color define
    private let otColor = UIColor(hexString: "#1C2D7A")
    private let borderColor = UIColor.lightGray
    private let todayColor = UIColor(hexString: "#359190")
    private let morningDefaultColor = UIColor(hexString: "#3CCB3E")
    private let afternoonDefaultColor = UIColor(hexString: "#3CCB3E")

    private var appearancesStyleMustApply: [TimeSheetCellStyleAppearance] = [.none] {
        didSet {
            setNeedsLayout()
        }
    }

    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }

    override init!(frame: CGRect) {
        super.init(frame: frame)

        let morningLayer = CAShapeLayer()
        let afternoonLayer = CAShapeLayer()
        let todayLayer = CAShapeLayer()
        let otLayer = CAShapeLayer()
        let borderLayer = CAShapeLayer()

        morningLayer.fillColor = morningDefaultColor.cgColor
        morningLayer.lineWidth = 1
        morningLayer.strokeColor = morningDefaultColor.cgColor

        afternoonLayer.fillColor = afternoonDefaultColor.cgColor
        afternoonLayer.lineWidth = 1
        afternoonLayer.strokeColor = afternoonDefaultColor.cgColor

        todayLayer.fillColor = todayColor.cgColor

        otLayer.fillColor = UIColor.clear.cgColor
        otLayer.lineWidth = 3
        otLayer.strokeColor = otColor.cgColor

        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = borderColor.cgColor

        self.shapeLayer.isHidden = true

        self.contentView.layer.insertSublayer(morningLayer,
                                              below: self.titleLabel.layer)
        self.contentView.layer.insertSublayer(afternoonLayer,
                                              below: self.titleLabel.layer)
        self.contentView.layer.insertSublayer(otLayer,
                                              below: self.titleLabel.layer)

        self.contentView.layer.insertSublayer(borderLayer,
                                              below: self.titleLabel.layer)

        self.contentView.layer.insertSublayer(todayLayer,
                                              below: self.titleLabel.layer)

        self.morningLayer = morningLayer
        self.afternoonLayer = afternoonLayer
        self.todayLayer = todayLayer
        self.otLayer = otLayer
        self.borderLayer = borderLayer
    }

    private func getCurrentDimensions() -> (titleHight: CGFloat, diameter: CGFloat) {
        let titleHeight = self.bounds.size.height * 5.0 / 6.0
        var diameter = min(self.bounds.size.height * 5.0 / 6.0, self.bounds.size.width)
        diameter = diameter > FSCalendarStandardCellDiameter ?
            (diameter - (diameter-FSCalendarStandardCellDiameter) * 0.5) : diameter

        return (titleHeight, diameter)
    }

    private func applyAppearanceStyles(style: TimeSheetCellStyleAppearance) {

        let (titleHeight, diameter) = getCurrentDimensions()

        switch style {
        case .today:
            todayLayer.isHidden = false

            todayLayer.frame = CGRect(x: (self.bounds.size.width) / 2,
                                      y: ((titleHeight - diameter) / 2) + (borderLayer.lineWidth * 2),
                                      width: self.shapeLayer.bounds.width / 5,
                                      height: self.shapeLayer.bounds.width / 5)

            todayLayer.path = UIBezierPath(arcCenter: CGPoint(x: 0,
                                                              y: todayLayer.frame.height / 2),
                                           radius: self.todayLayer.bounds.width * 0.5,
                                           startAngle: .pi / 2,
                                           endAngle: 2.5 * .pi,
                                           clockwise: true).cgPath
        case .ot:
            otLayer.isHidden = false
            borderLayer.isHidden = true

            otLayer.frame = CGRect(x: (self.bounds.size.width - diameter) / 2,
                                   y: (titleHeight - diameter) / 2,
                                   width: diameter,
                                   height: diameter)

            otLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.shapeLayer.bounds.width / 2,
                                                           y: self.shapeLayer.bounds.height / 2),
                                        radius: self.shapeLayer.bounds.width * 0.5,
                                        startAngle: .pi / 2,
                                        endAngle: 2.5 * .pi,
                                        clockwise: true).cgPath
        case .morning(let withColor):
            morningLayer.isHidden = false

            morningLayer.frame = CGRect(x: CGFloat(ceilf(Float((self.bounds.size.width - diameter) / 2))),
                                        y: (titleHeight - diameter) / 2,
                                        width: diameter,
                                        height: diameter)

            morningLayer.path = UIBezierPath(arcCenter: CGPoint(x: morningLayer.frame.width / 2,
                                                                y: morningLayer.frame.height / 2),
                                             radius: self.shapeLayer.bounds.width * 0.5,
                                             startAngle: .pi / 2,
                                             endAngle: (.pi / 2) + .pi,
                                             clockwise: true).cgPath
            if let withColor = withColor {
                morningLayer.fillColor = withColor.cgColor
                morningLayer.strokeColor = withColor.cgColor
            }

        case .afternoon(let withColor):
            afternoonLayer.isHidden = false

            afternoonLayer.frame =  CGRect(x: CGFloat(floorf(Float((self.bounds.size.width - diameter) / 2))),
                                           y: (titleHeight - diameter) / 2,
                                           width: diameter,
                                           height: diameter)

            afternoonLayer.path = UIBezierPath(arcCenter: CGPoint(x: afternoonLayer.frame.width / 2,
                                                                  y: afternoonLayer.frame.height / 2),
                                               radius: self.shapeLayer.bounds.width * 0.5,
                                               startAngle: .pi / 2,
                                               endAngle: (.pi / 2) + .pi,
                                               clockwise: false).cgPath

            if let withColor = withColor {
                afternoonLayer.fillColor = withColor.cgColor
                afternoonLayer.strokeColor = withColor.cgColor
            }

        default:
            break
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let (titleHeight, diameter) = getCurrentDimensions()

        //reset -> hide all layer
        todayLayer.isHidden = true
        morningLayer.isHidden = true
        afternoonLayer.isHidden = true
        otLayer.isHidden = true
        borderLayer.isHidden = false

        borderLayer.frame = CGRect(x: (self.bounds.size.width - diameter) / 2,
                                   y: (titleHeight - diameter) / 2,
                                   width: diameter + borderLayer.lineWidth,
                                   height: diameter + borderLayer.lineWidth)

        borderLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.shapeLayer.bounds.width / 2,
                                                           y: self.shapeLayer.bounds.height / 2),
                                        radius: self.shapeLayer.bounds.width * 0.5,
                                        startAngle: .pi / 2,
                                        endAngle: 2.5 * .pi,
                                        clockwise: true).cgPath

        for style in appearancesStyleMustApply {
            applyAppearanceStyles(style: style)
        }
    }

    func applyStyleAppearanceForCell(dateForCell: Date, dateStartWorking: Date?, dateEndWorking: Date?, displayDateSetting: TimeSheetDayModel?) {
        self.isHidden = false
        if let dateStartWorking = dateStartWorking?.dateFor(.startOfDay),
            let dateEndWorking = dateEndWorking?.dateFor(.startOfDay) {

            switch monthPosition {
            case .current:
                //date for current month will display on calendar

                // dateForCell > dateEndWorking || dateForCell < dateStartWorking
                // hide
                if (dateForCell.compare(.isLater(than: dateEndWorking)) &&
                    !dateForCell.compare(.isSameDay(as: dateEndWorking))) ||
                    (dateForCell.compare(.isEarlier(than: dateStartWorking)) &&
                    !dateForCell.compare(.isSameDay(as: dateStartWorking))) {
                    self.isHidden = true
                }
            case .next:
                //date for next month will display on calendar -> hide all
                self.isHidden = true
            case .previous:
                //date for previous month will display on calendar

                // dateForCell < dateStartWorking
                // hide
                if dateForCell.compare(.isEarlier(than: dateStartWorking)) &&
                    !dateForCell.compare(.isSameDay(as: dateStartWorking)) {
                    self.isHidden = true
                }
            default:
                self.isHidden = false;
            }
        }

        resetStyleAppearance()

        if Calendar.current.isDateInToday(dateForCell) {
            applyTodayStyleAppearance()
        }

        guard let displayDateSetting = displayDateSetting else {
            return
        }

        //set color for morning and afternoon if this is a dayoff or normal day
        applyMorningStyleAppearance(withColor: displayDateSetting.morningColorDisplay)
        applyAfternoonStyleAppearance(withColor: displayDateSetting.afternoonColorDisplay)

        if displayDateSetting.hoursOverTime ?? 0 > 0 {
            applyOTStyleAppearance()
        }

        if displayDateSetting.isSpecialCase {
            appearancesStyleMustApply += [.none]
        }

    }

    private func resetStyleAppearance() {
        appearancesStyleMustApply = [.none]
    }

    private func applyOTStyleAppearance() {
        appearancesStyleMustApply += [.ot]
    }
    
    private func applyTodayStyleAppearance() {
        appearancesStyleMustApply += [.today]
    }
    
    private func applyMorningStyleAppearance(withColor: UIColor?) {
        appearancesStyleMustApply += [.morning(withColor: withColor)]
    }
    
    private func applyAfternoonStyleAppearance(withColor: UIColor?) {
        appearancesStyleMustApply += [.afternoon(withColor: withColor)]
    }
}
