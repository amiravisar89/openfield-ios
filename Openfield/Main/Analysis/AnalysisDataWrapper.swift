//
//  AnalysisDataWrapper.swift
//  Openfield
//
//  Created by Daniel Kochavi on 22/12/2019.
//  Copyright © 2019 Prospera. All rights reserved.
//

import Dollar
import Foundation
import Resolver
import SwiftDate

class AnalysisDataWrapper {
    typealias DateIndex = Int
    public static let empty = AnalysisDataWrapper()
    public var field: Field
    public var isEmpty: Bool
    private var irrigationInsights: [IrrigationInsight]
    private var datesByLayer = [AppImageType: [DateIndex]]()
    private var layersByDate = [DateIndex: [LayerCell]]()
    public var dateCells = [DateCell]()
    private var defaultLayerCells: [LayerCell] = AppImageType.allCases.map { type in LayerCell(imageType: type, image: nil, isSelected: true) }
    private var firstDate: Date = .init()
    private var currentDateIndex: DateIndex = 0
    private var currentLayerCells: [LayerCell] {
        return layersByDate[currentDateIndex]?.map { layerCell in layerCell.with { $0.isSelected = layerCell.imageType == currentLayer }} ?? defaultLayerCells
    }

    private let dateProvider: DateProvider = Resolver.resolve()
    private var currentLayer: AppImageType
    private var imagesByDateIndex = [DateIndex: FieldImageGroup]()

    private var nextDateRange: [Int] {
        return Array(min(currentDateIndex + 1, dateCells.count - 1) ..< dateCells.count)
    }

    private var previousDateRange: [Int] {
        return (0 ... max(currentDateIndex - 1, 0)).reversed()
    }

    private let appImageTypesOrder: [AppImageType] = [AppImageType.rgb, AppImageType.ndvi, AppImageType.thermal]

    private init() {
        irrigationInsights = []
        currentLayer = .rgb
        field = Field.empty
        isEmpty = true
    }

    init(field: Field, initialInsights: [IrrigationInsight]?, initialDate: Date, initialLayer: AppImageType, insights: [IrrigationInsight], isEmpty: Bool) {
        self.isEmpty = isEmpty
        self.field = field
        irrigationInsights = insights
        currentLayer = initialLayer
        if let insights = initialInsights {
            _ = selectInsightById(ids: insights.map { $0.id })
        }
        initData(initialDate: initialDate)
        validateImageForDate()
        print("Wrapper adress init: %@", Unmanaged.passUnretained(self).toOpaque())
    }

    private func validateImageForDate() {
        // Check if the image is missing in the current date

        if let currentLayers = imagesByDateIndex[currentDateIndex]?.imagesByLayer.map({ $0.key }) {
            guard !currentLayers.contains(currentLayer), let layer = getFirstAvailableLayer(layers: currentLayers) else { return }

            // if missing go to the next layer

            changeLayer(layer: layer)

        } else if let latestLayerGroup = field.latestAvailableLayerFieldImageGroup() {
            // if no images available in any layer go
            currentDateIndex = getDateIndex(to: latestLayerGroup.date)
        } else {
            currentDateIndex = .zero
        }
        changeDate(to: currentDateIndex)
    }

    private func getFirstAvailableLayer(layers: [AppImageType]) -> AppImageType? {
        for layer in appImageTypesOrder {
            if layers.contains(layer) {
                return layer
            }
        }
        return nil
    }

    private func initData(initialDate: Date) {
        let dates: [Date] = field.imageGroups.map { imageGroup in imageGroup.date }.sorted()
        guard !dates.isEmpty else {
            log.warning("Couldn't find dates with flights for field: \(field.id)")
            return
        }
        firstDate = dates.first! // dates isn't empty

        for fieldImageGroup in field.imageGroups {
            let availableImageTypes = Array(fieldImageGroup.imagesByLayer.keys) // image types in current image group
            let index = getDateIndex(to: fieldImageGroup.date) // index for the date cell

            imagesByDateIndex[index] = fieldImageGroup // set the image group to the date index

            for imageType in availableImageTypes { // add the index to each layer
                var dates: [DateIndex] = datesByLayer[imageType] ?? [DateIndex]()
                dates.append(index)
                datesByLayer[imageType] = dates
            }

            let layers: [LayerCell] = createLayerCells(from: availableImageTypes, in: fieldImageGroup) // create layer cells from available layers
            layersByDate[index] = layers // add the layers to the date index
        }
        if datesByLayer[currentLayer] == nil {
            currentLayer = .thermal
            if datesByLayer[currentLayer] == nil {
                currentLayer = .ndvi
            }
        }

        dateCells = createDateCells(from: firstDate,
                                    datesForLayer: datesByLayer[currentLayer]!,
                                    layerForDate: layersByDate,
                                    selectedDate: getDateIndex(to: initialDate), imagesByDateIndex: imagesByDateIndex)
        currentDateIndex = dateCells.filter { $0.isSelected }.first?.index ?? 0 // createDateCells marks a single cell with isSelected
    }

    private func getThumbnailImageFor(type: AppImageType, from fieldImageGroup: FieldImageGroup) -> String? {
        let previews = fieldImageGroup.imagesByLayer[type]
        let lowResolutionPreview = previews?.first
        return lowResolutionPreview?.url
    }

    private func getIssueImageFor(type: AppImageType, from fieldImageGroup: FieldImageGroup) -> Issue? {
        let previews = fieldImageGroup.imagesByLayer[type]
        let lowResolutionPreview = previews?.first
        return lowResolutionPreview?.issue
    }

    @discardableResult
    public func changeDate(to: DateIndex) -> ([LayerCell], [DateCell]) {
        if let layersInDate = layersByDate[to] {
            dateCells[currentDateIndex].isSelected = false
            dateCells[to].isSelected = true

            currentDateIndex = to

            let layers = layersInDate.map { layerCell in layerCell.with { $0.isSelected = layerCell.imageType == currentLayer }}
            return (layers, dateCells)
        }

        log.error("Couldn't find layers for field: \(field.id) in date \(dateCells[to].date)")
        return (currentLayerCells, dateCells)
    }

    public func changeLayer(layer: AppImageType) {
        guard let currentDates = datesByLayer[currentLayer],
              let updatedDates = datesByLayer[layer]
        else {
            log.error("Couldn't change layer to \(layer.name()) for field: \(field.id) in date \(dateCells[currentDateIndex].date)")
            return
        }

        currentLayer = layer

        enableDates(dateIndexes: currentDates, enable: false)
        enableDates(dateIndexes: updatedDates, enable: true)
    }

    public func getCurrentDateCell() -> DateCell {
        return dateCells[currentDateIndex]
    }

    public func getCurrentLayer() -> LayerCell {
        return currentLayerCells.filter { $0.isSelected }.first! // wrapper is initalised with a selected layer
    }

    public func getCurrentLayers() -> [LayerCell] {
        return currentLayerCells
    }

    /**
      Returns an array with 2 image previews
     */
    public func getCurrentImage() -> [PreviewImage] {
        guard let fieldImageGroup = imagesByDateIndex[currentDateIndex] else {
            log.warning("Found no images for field: \(field.id) on date: \(dateCells[currentDateIndex].date)")
            return []
        }

        guard let imagesForLayer = fieldImageGroup.imagesByLayer[currentLayer] else {
            log.warning("Found no images for field: \(field.id) on date: \(dateCells[currentDateIndex].date) for layer: \(currentLayer)")
            return []
        }

        return imagesForLayer
    }

    public func getCurrentIssue() -> Issue? {
        return getCurrentImage()[0].issue
    }

    public func getCurrentImageBounds() -> ImageBounds {
        guard let fieldImageGroup = imagesByDateIndex[currentDateIndex] else {
            log.warning("Found no images for field: \(field.id) on date: \(dateCells[currentDateIndex].date)")
            return ImageBounds(boundsLeft: 0, boundsBottom: 0, boundsRight: 0, boundsTop: 0)
        }

        return fieldImageGroup.bounds
    }

    public func changeToNextDate() {
        chageToNextDateInRange(range: nextDateRange)
    }

    public func changeToPreviousDate() {
        chageToNextDateInRange(range: previousDateRange)
    }

    public func hasNextDate() -> Bool {
        return hasNextDateInRange(range: nextDateRange)
    }

    public func hasPreviousDate() -> Bool {
        return hasNextDateInRange(range: previousDateRange)
    }

    public func getInsights() -> [IrrigationInsight] {
        return irrigationInsights
    }

    public func changeInsightSelectionState(index: Int) -> IrrigationInsight {
        irrigationInsights[index].isSelected = !irrigationInsights[index].isSelected
        return irrigationInsights[index]
    }

    private func selectInsightById(ids: [Int]) -> [IrrigationInsight] {
        for index in 0 ... irrigationInsights.count - 1 {
            irrigationInsights[index].isSelected = ids.contains(irrigationInsights[index].id)
        }
        return irrigationInsights
    }

    private func hasNextDateInRange(range: [Int]) -> Bool {
        for index in range {
            if dateCells[index].isEnabled == true, index != currentDateIndex {
                return true
            }
        }
        return false
    }

    @discardableResult
    private func chageToNextDateInRange(range: [Int]) -> ([LayerCell], [DateCell]) {
        for index in range {
            if dateCells[index].isEnabled == true {
                return changeDate(to: index)
            }
        }
        return (currentLayerCells, dateCells)
    }

    private func enableDates(dateIndexes: [DateIndex], enable: Bool) {
        for index in dateIndexes {
            dateCells[index].isEnabled = enable
        }
    }

    private func getDateIndex(to: Date) -> Int {
        return firstDate.difference(in: .day, from: to)!
    }

    private func createLayerCells(from types: [AppImageType], in fieldImageGroup: FieldImageGroup) -> [LayerCell] {
        // if fieldImageGroup source type is satellite, we filter the thermal layer
        let mappingArray = fieldImageGroup.sourceType == ImageSourceType.satellite ?
            appImageTypesOrder.filter { $0 != .thermal } :
            appImageTypesOrder

        return mappingArray.map { type in LayerCell(imageType: type, image: getThumbnailImageFor(type: type, from: fieldImageGroup), isEnabled: types.contains(type), issue: getIssueImageFor(type: type, from: fieldImageGroup)) }
    }

    private func removeTimeFromDate(date: Date) -> Date {
        return date.dateTruncated(from: .hour)!
    }

    private func createDateCells(from: Date, datesForLayer: [DateIndex], layerForDate: [DateIndex: [LayerCell]], selectedDate: DateIndex, imagesByDateIndex: [DateIndex: FieldImageGroup]) -> [DateCell] {
        let cells = createTrunketDated(date: from).enumerated().map { index, date -> DateCell in
            var isCloudy = false
            let currentlayers = layerForDate[index] // get layers for date
            let cloudyLayers = currentlayers?.filter { layerCell -> Bool in
                let didFitType = (layerCell.issue?.issue == .clouds || layerCell.issue?.issue == .shadow)
                let isCloudHidden = layerCell.issue?.isHidden ?? true
                return didFitType == true && isCloudHidden == false
            } // filtered only cloudy / shadow
            if cloudyLayers != nil, cloudyLayers!.count > 0 {
                isCloudy = true
            }

            let cellDate = date // imagesByDateIndex[index]?.date ?? date

            return DateCell(
                index: index,
                isCloudy: isCloudy,
                date: cellDate,
                region: field.region,
                isEnabled: datesForLayer.contains(index),
                isSelected: index == selectedDate,
                sourceType: imagesByDateIndex[index]?.sourceType ?? .plane
            )
        }

        return cells
    }

    func createTrunketDated(date: Date) -> [Date] {
        let now = Date()
        let trunckedDate = removeTimeFromDate(date: date)
        let daysFromDate = Int(trunckedDate.getInterval(toDate: now, component: .day))
        let dates = Array(1 ... (daysFromDate + 1)).map { number in
            trunckedDate + number.days
        }
        return dates
    }
}
