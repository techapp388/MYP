//
//  JobSpreadSheetCell.swift
//  MyProHelper
//
//

import UIKit
import SpreadsheetView

class JobSpreadSheetCell: Cell {

    static let ID = String(describing: JobSpreadSheetCell.self)
    
    private let label = UILabel()

    override var frame: CGRect {
        didSet {
            label.frame = bounds.insetBy(dx: 4, dy: 0)
        }
    }

    override func prepareForReuse() {
        resetCell()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundView = UIView()

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left

        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func resetCell() {
        label.text = ""
        label.textColor = .black
        backgroundColor = .white
    }

    func bindCell(text: String?, cellColor: String, textColor: String) {
        if let text = text {
            label.text = text
            label.textColor = UIColor(hex: textColor)
            backgroundColor = UIColor(hex: cellColor)
        }
    }
}
