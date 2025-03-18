//
//  SaveInputTableViewCellDelegate.swift
//  CellPractice3
//
//  Created by admin29 on 12/03/25.
//


protocol SaveInputTableViewCellDelegate: AnyObject {
    func saveInputCellDidUpdateValue(_ cell: SaveInputTableViewCell, value: String)
}
