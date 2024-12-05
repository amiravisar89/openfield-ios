//
//  InsightFaker.swift
//  Openfield
//
//  Created by amir avisar on 01/05/2022.
//  Copyright © 2022 Prospera. All rights reserved.
//

import Fakery
import Foundation
import GEOSwift
import SwiftDate

struct InsightFaker: FakerProvider {
    let faker: Faker
    let fieldFaker: FieldsFaker

    private let insightTimeAgo: Date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
    private let insightFutureTime: Date = Calendar.current.date(byAdding: .day, value: 4, to: Date())!
    private let insightNow: Date = .init()

    init(faker: Faker, fieldFaker: FieldsFaker) {
        self.faker = faker
        self.fieldFaker = fieldFaker
    }

    func createInsight() -> Insight {
        if faker.number.randomInt() % 2 == .zero {
            return createIrrigationInsight()
        } else {
            return createLocationInsight()
        }
    }

    func createBasicInsight() -> Insight {
        let date = faker.date.between(insightTimeAgo, insightNow)
        let field = randomElement(list: fieldFaker.createFields())
        let id = faker.number.randomInt(min: 0, max: 1_000_000)
        let mainImageUrlSmall = randomElement(list: urls)

        return Insight(id: id, uid: "\(faker.number.increasingUniqueId())", type: "type_test", subject: faker.company.bs(), fieldId: field.id, fieldName: field.name, farmName: field.farmName, farmId: 0, description: faker.lorem.words(amount: 10), publishDate: date, affectedArea: faker.number.randomDouble(min: 12.3, max: 34.8), affectedAreaUnit: "Acres", isRead: faker.number.randomBool(), tsFirstRead: Date(), timeZone: nil, thumbnail: mainImageUrlSmall, category: "irrigation", subCategory: "detection", displayName: "weeds", highlight: nil, cycleId: 1, publicationYear: 2024)
    }

    func createIrrigationInsight() -> IrrigationInsight {
        let insight = createBasicInsight()
        let mainImageUrlSmall = randomElement(list: urls)
        let mainImageUrlLarge = mainImageUrlSmall.replacingOccurrences(of: "_600", with: "_1600")
        let decoder = JSONDecoder()
        let data = tag.data(using: .utf8)!
        let geoJSON = try? decoder.decode(GeoJSON.self, from: data)

        let mainImage = InsightImage(date: insight.publishDate, id: insight.id, bounds: tagBounds, type: .rgb, issue: Issue(comment: "", isHidden: false, issue: IssueType.clouds), previews: [PreviewImage(url: mainImageUrlSmall, height: 50, width: 50, imageId: 0, issue: Issue(comment: "", isHidden: true, issue: .empty)), PreviewImage(url: mainImageUrlLarge, height: 50, width: 50, imageId: 0, issue: Issue(comment: "", isHidden: true, issue: .empty))], sourceType: .plane)

        return IrrigationInsight(id: insight.id, uid: insight.uid, type: insight.type, subject: insight.subject, fieldId: insight.fieldId, fieldName: insight.fieldName, farmName: insight.farmName, farmId: nil, description: insight.description, publishDate: insight.publishDate, affectedArea: insight.affectedArea, affectedAreaUnit: insight.affectedAreaUnit, isRead: insight.isRead, tsFirstRead: insight.tsFirstRead, timeZone: insight.timeZone, imageDate: insight.publishDate, thumbnail: insight.thumbnail!, images: nil, mainImage: mainImage, review: nil, feedback: Feedback(insightId: insight.id), isSelected: faker.number.randomBool(), tag: InsightTag(id: 890, tag: geoJSON!), dateRegion: SwiftDate.defaultRegion, category: "irrigation", subCategory: "detection", displayName: "Irrigation", highlight: "Non-uniform vegetation", cycleId: nil, publicationYear: 2023
)
    }

    func createLocationInsight() -> EnhancedLocationInsight {
        let insight = createBasicInsight()
        let coveImage = SpatialImage(height: 500, width: 500, url: urls.first(where: { !$0.isEmpty }) ?? "", bounds: tagBounds)
        let items = createList(count: faker.number.randomInt(min: 1, max: 5), creator: createLocationInsightItem)

        return EnhancedLocationInsight(id: insight.id, uid: insight.uid, type: insight.type, subject: insight.subject, fieldId: insight.fieldId, fieldName: insight.fieldName, farmName: insight.farmName, farmId: insight.farmId, description: insight.description, publishDate: insight.publishDate, affectedArea: insight.affectedArea, affectedAreaUnit: insight.affectedAreaUnit, isRead: insight.isRead, tsFirstRead: insight.tsFirstRead, timeZone: insight.timeZone, thumbnail: "https://vi-apps.prospera.ag/assets/canopy_cover_feed_item.png", startDate: insightNow, endDate: insightFutureTime, scannedAreaPercent: 25, taggedImagesPercent: 34, relativeToLastReport: 24, coverImage: [coveImage], items: items, aggregationUnit: nil, region: SwiftDate.defaultRegion, enhanceData: createLocationEnhancedData(), category: "", subCategory: "detection", displayName: "weeds", summery: "summery", highlight: nil, cycleId: 1, publicationYear: 2024)
    }

    func createLocationInsightItem() -> LocationInsightItem {
        return LocationInsightItem(id: faker.number.randomInt(min: 0, max: 1000), name: "", description: nil, taggedImagesPercent: 0, displayedValue: nil, minRange: 20, maxRange: 40, enhanceData: createLocationEnhancedData())
    }

    func createLocationEnhancedData() -> LocationInsightEnhanceData {
        let levels = createList(count: faker.number.randomInt(min: 1, max: 5), creator: createLocatioEnhanceDataLevel)
        let range = LocationInsightRange(title: "Progress -", midtitle: "% of scan", subtitle: "", levels: levels)
        return LocationInsightEnhanceData(title: "Broadleaves", subtitle: "", locationsAggValue: "~4%", locationsAggName: "Locations with findings", isSeverity: true, ranges: range)
    }

    func createLocatioEnhanceDataLevel() -> LocationInsightLevel {
        return LocationInsightLevel(order: faker.number.randomInt(min: 0, max: 10), color: .red, value: faker.number.randomInt(min: 1, max: 100), name: "", relativeToLastReport: nil, locationIds: [], id: faker.number.randomInt(min: 1, max: 1000))
    }

    let tag = """
    {"type": "Feature", "geometry": {"type": "Polygon", "coordinates": [[[-119.14165796712037, 46.354544738284254], [-119.13947733119127, 46.35291214796353], [-119.1386354528367, 46.3537051926133], [-119.14128832519049, 46.35647555182296], [-119.14165796712037, 46.354544738284254]]]}, "properties": {"srid": 3857, "type": "Polygon"}}
    """

    let tagBounds = ImageBounds(boundsLeft: -119.14249813755185,
                                boundsBottom: 46.35238884964525,
                                boundsRight: -119.1354891148103,
                                boundsTop: 46.35724123319537)

    let urls: [String] = [
        "https://thumbs-us.o.prospera.ag/109453/8c502545bb6841c6bc2617c5e21fb072_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/111648/c5ffc76f31fd4fcd9c687d5fe7f59d4e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/129819/788812ada20b4a349eee0b9c1c25931d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/116306/115ca0ec1c7a4fa8801a30abffd0ce69_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117406/c41dd062d5b44b80b10a91171ec14d9e_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/101646/9c72ce3ee188422bbeac234ce30b5940_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117453/bef7911bd43f43d8a2ef6d83bae71996_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/132007/83c46732d0ab4965951c491414cbcdd7_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/139468/3e93e33d6426425987c29234eaac2476_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117363/0aa35df0a21f4eb2ac2d23e52c4b6d19_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/118611/aa42ad3620f34d459928be33ae4236ae_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/114176/bf032eed89eb4ec98c30c9845b31d627_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99988/e6352815548f4a37bf8ad4500b4061ec_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/137056/9f6dc7f12b184472bd9b1563c5c14775_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/129395/46fc328abcb841718015befa922d266d_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109661/a5ca0d880a1c4b219001e28e38b4f782_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/105074/abbda050a51a4c9684af8786c83f1b12_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/105074/e295614fe56542feb207d002e7f0bd01_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130717/5b568ab7524f4fb4a37a078a10583d68_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108227/34d515b36bd54434bde6d4b2723855f6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108264/b8b7b44a90434ac08d15f65d12fa6cd2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108264/3bdc96309ac24f1183f0fee79c762c89_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130129/f59dc476ddd849379dec309c9b1e1489_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108344/53fb5c16a3234bef9a18d9dd07530eb0_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130126/af99f6282dff453eb51598571e62599a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108345/00a01a9b2941400a86cdded8e5cceaa6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/112577/0c6f6bc5b625490999fe26eb48ab1112_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130384/ee61bf01fef446208df4945ba46814f5_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/16420/2d758947d7794237bc3e57ac2b2f7bb0_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/102414/2a207ec8906a43e58a979ba97e8c5a10_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/114757/a2491ff11c2b4828b5e1d25845aca64b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/128893/c78fab5c46aa43f4aff962d7998095f7_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103072/1b15f064ee5246d5b989c0ca21732b62_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103072/a3bb7b34e7b24e308f279423f9d73e90_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/e1f2678b636940be9a0b631cddf392ee_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/5e8212e5e1cf4f9ab670332e7118f565_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/4e28767ec95949d194d8b0c5f72e0950_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122974/a288cd36af6b4536a7001025f2ab7417_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122921/dad7d2fd33bd4857af84be63157b3df2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122920/888589529e244a90a2a2492f904bda6a_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122920/37d0ba491cf5476195285b2cf88533e6_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122951/8e7fbe63088849dfa99d966e10d30928_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122951/112279788c5a40dfac9eb2e021197e3e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122997/ffc8bb62c3144faf9b314a9a89520ccb_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99930/3383acae35fa4ffd8de80d97ef7eeb6f_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99726/e12d55c27ecd43969524aab253b83880_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127616/7f1f5fad897445aca04862ecdb8063b9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127600/35508cb8acd44ca7a93b92a8fc896c4b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127721/d3f4db4d77744c3a969b1f830289107c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/149110/bfa5a9946e7c4c46b957aab2e894d3ec_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/98559/f159fb4cbf2c477ba6458d1f26584f3b_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/100020/5866721a88874cb69edb049051c05dc9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99773/9ad34baba15147a380666d1f036741c2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99773/e02a106c0aef4fd7b1e35471940595c8_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127838/120b5d419c69445fb4aef4887f798c04_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99844/1906797f041942fa8639bfc58554b252_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99844/48fc1e9bb6be4c19b6e5c389ec8f5da1_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127847/6d84d98b175746828bb8e23f771308e9_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/149248/7ff0074fe26d42369aa5e9fbfe0f4117_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124079/11dba2c11bd94329a1631177b9a7e837_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124079/ca69fad9f2854e0ebc7287c6c17ff0cc_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124076/cd9abc0ba468411ea032652dc8cf7418_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124076/7f9982354dcd4c5fb0fbdb4d50ac1a11_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124093/9a11c125b13445e3b551b959e1cde430_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124184/6d3ca4e8b2234863b4abede44bf241f3_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124182/2775502236944169b333c0e38fc9592d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124127/a285858e515a4c989d793612b7a1c700_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124127/a0ccc1cd44724b4f96b153d00e39787a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124186/6401eff0b4674fbe8700a5d690753493_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124149/c0aac057d60c47dcae5d6a38aa1cb79e_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124155/98884620f3444a579208afedabf77f1a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144522/e7ebc9d765a34bb99abd8fc70b27742c_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127002/861a0bbdf94a4fbfba7a2480dc30cd23_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127002/c64716ecef7e4feb8da7fa43a7eca382_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127038/232e7b360f634d4ea0758b5c8435dfbf_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144533/e7c07ad6ae5244fd877cd5d39d32b535_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144550/2517ae0ce7e64cab82c5342cf104c29e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103792/d8690f11a4384a8c870a9c612c9a158c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144590/faabb3601c854ff1bef4e526e4135ff1_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144584/5087ce3770fa4204a3fc5bcd11a368d2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144584/9b1c166872f444359274704f19c651b9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/19926/62607e3b7927421bbc79b7270526be2d_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/19926/b47e5c195197438a9164c881858cd091_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144597/139425646956412f8d40bb1210471ebd_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99687/dd871aec97cb4d46b72202b772393739_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99687/d07718db2dfb4e50b82dafda007e1ea7_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124214/00131ba84953462fa5466c08ce9b3e88_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144633/11649a5e188e47179e2d562e0a9fea2a_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144603/6a13f73d7f9f4a14b69ddf8ce4224c91_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144600/0c6fcf246bc3486c8d8e798c4ba99a1a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144622/13bcbb111ff74d7583ae91fa6fcf3b8a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144637/c243a762e8254bbfb2dcade758b5823c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/111555/747455d69aac496698c0a1c33dc13f3b_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109937/695e9974d86b4f6e9bb4016713dfd7a1_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109937/e9ca2128966b4330a72301221c6abc7d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103853/a33d1a5f8cb9482e98bb6854eb99df3c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127161/1ed89a2e4177460e9a49e0bbd6afeeca_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144662/5c31626593f14d88a28f5924327b5aea_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144666/6bef0ad2d8764f09bb25f60674982ed3_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144686/28b3bc8067504693a6811cdfbe29f608_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144686/c2a4cc0180f14f2e849b83f91fdc7e16_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144733/2b93d57c6cad445ea06c85a84a22330b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144698/a90c137ec4a343d4b3f70bf895e2f396_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144698/eb7343b72d8a41dbad361a0bf905ec25_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127202/d600e260d8124daf9d98757d5cca4d13_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127200/6fd4ca132db64a03bb5b86f67a28ce47_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144799/6106b1e5044f481b87949f6d7bc209c4_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/104070/f2070590fb30455c9651ce58a042b0c6_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144867/3564a5e4ae2645fdad39d46a51d461b6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127372/3376b0695d5b4d9790c31ea2811b085e_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/5da4ee1b70f54a0eb484b18ec8c048c8_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/73c08d3b5e254a258b44d56113377057_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/eeeb1b092f26410aaef9106ad40bb93a_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109453/8c502545bb6841c6bc2617c5e21fb072_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/111648/c5ffc76f31fd4fcd9c687d5fe7f59d4e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/129819/788812ada20b4a349eee0b9c1c25931d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/116306/115ca0ec1c7a4fa8801a30abffd0ce69_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117406/c41dd062d5b44b80b10a91171ec14d9e_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/101646/9c72ce3ee188422bbeac234ce30b5940_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117453/bef7911bd43f43d8a2ef6d83bae71996_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/132007/83c46732d0ab4965951c491414cbcdd7_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/139468/3e93e33d6426425987c29234eaac2476_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/117363/0aa35df0a21f4eb2ac2d23e52c4b6d19_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/118611/aa42ad3620f34d459928be33ae4236ae_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/114176/bf032eed89eb4ec98c30c9845b31d627_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99988/e6352815548f4a37bf8ad4500b4061ec_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/137056/9f6dc7f12b184472bd9b1563c5c14775_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/129395/46fc328abcb841718015befa922d266d_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109661/a5ca0d880a1c4b219001e28e38b4f782_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/105074/abbda050a51a4c9684af8786c83f1b12_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/105074/e295614fe56542feb207d002e7f0bd01_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130717/5b568ab7524f4fb4a37a078a10583d68_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108227/34d515b36bd54434bde6d4b2723855f6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108264/b8b7b44a90434ac08d15f65d12fa6cd2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108264/3bdc96309ac24f1183f0fee79c762c89_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130129/f59dc476ddd849379dec309c9b1e1489_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108344/53fb5c16a3234bef9a18d9dd07530eb0_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130126/af99f6282dff453eb51598571e62599a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/108345/00a01a9b2941400a86cdded8e5cceaa6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/112577/0c6f6bc5b625490999fe26eb48ab1112_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/130384/ee61bf01fef446208df4945ba46814f5_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/16420/2d758947d7794237bc3e57ac2b2f7bb0_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/102414/2a207ec8906a43e58a979ba97e8c5a10_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/114757/a2491ff11c2b4828b5e1d25845aca64b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/128893/c78fab5c46aa43f4aff962d7998095f7_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103072/1b15f064ee5246d5b989c0ca21732b62_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103072/a3bb7b34e7b24e308f279423f9d73e90_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/e1f2678b636940be9a0b631cddf392ee_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/5e8212e5e1cf4f9ab670332e7118f565_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122940/4e28767ec95949d194d8b0c5f72e0950_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122974/a288cd36af6b4536a7001025f2ab7417_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122921/dad7d2fd33bd4857af84be63157b3df2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122920/888589529e244a90a2a2492f904bda6a_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122920/37d0ba491cf5476195285b2cf88533e6_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122951/8e7fbe63088849dfa99d966e10d30928_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122951/112279788c5a40dfac9eb2e021197e3e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/122997/ffc8bb62c3144faf9b314a9a89520ccb_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99930/3383acae35fa4ffd8de80d97ef7eeb6f_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99726/e12d55c27ecd43969524aab253b83880_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127616/7f1f5fad897445aca04862ecdb8063b9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127600/35508cb8acd44ca7a93b92a8fc896c4b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127721/d3f4db4d77744c3a969b1f830289107c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/149110/bfa5a9946e7c4c46b957aab2e894d3ec_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/98559/f159fb4cbf2c477ba6458d1f26584f3b_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/100020/5866721a88874cb69edb049051c05dc9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99773/9ad34baba15147a380666d1f036741c2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99773/e02a106c0aef4fd7b1e35471940595c8_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127838/120b5d419c69445fb4aef4887f798c04_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99844/1906797f041942fa8639bfc58554b252_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99844/48fc1e9bb6be4c19b6e5c389ec8f5da1_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127847/6d84d98b175746828bb8e23f771308e9_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/149248/7ff0074fe26d42369aa5e9fbfe0f4117_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124079/11dba2c11bd94329a1631177b9a7e837_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124079/ca69fad9f2854e0ebc7287c6c17ff0cc_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124076/cd9abc0ba468411ea032652dc8cf7418_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124076/7f9982354dcd4c5fb0fbdb4d50ac1a11_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124093/9a11c125b13445e3b551b959e1cde430_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124184/6d3ca4e8b2234863b4abede44bf241f3_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124182/2775502236944169b333c0e38fc9592d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124127/a285858e515a4c989d793612b7a1c700_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124127/a0ccc1cd44724b4f96b153d00e39787a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124186/6401eff0b4674fbe8700a5d690753493_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124149/c0aac057d60c47dcae5d6a38aa1cb79e_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124155/98884620f3444a579208afedabf77f1a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144522/e7ebc9d765a34bb99abd8fc70b27742c_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127002/861a0bbdf94a4fbfba7a2480dc30cd23_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127002/c64716ecef7e4feb8da7fa43a7eca382_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127038/232e7b360f634d4ea0758b5c8435dfbf_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144533/e7c07ad6ae5244fd877cd5d39d32b535_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144550/2517ae0ce7e64cab82c5342cf104c29e_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103792/d8690f11a4384a8c870a9c612c9a158c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144590/faabb3601c854ff1bef4e526e4135ff1_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144584/5087ce3770fa4204a3fc5bcd11a368d2_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144584/9b1c166872f444359274704f19c651b9_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/19926/62607e3b7927421bbc79b7270526be2d_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/19926/b47e5c195197438a9164c881858cd091_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144597/139425646956412f8d40bb1210471ebd_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99687/dd871aec97cb4d46b72202b772393739_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/99687/d07718db2dfb4e50b82dafda007e1ea7_ndvi_600.jpeg",
        "https://thumbs-us.o.prospera.ag/124214/00131ba84953462fa5466c08ce9b3e88_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144633/11649a5e188e47179e2d562e0a9fea2a_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144603/6a13f73d7f9f4a14b69ddf8ce4224c91_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144600/0c6fcf246bc3486c8d8e798c4ba99a1a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144622/13bcbb111ff74d7583ae91fa6fcf3b8a_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144637/c243a762e8254bbfb2dcade758b5823c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/111555/747455d69aac496698c0a1c33dc13f3b_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109937/695e9974d86b4f6e9bb4016713dfd7a1_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/109937/e9ca2128966b4330a72301221c6abc7d_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/103853/a33d1a5f8cb9482e98bb6854eb99df3c_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127161/1ed89a2e4177460e9a49e0bbd6afeeca_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144662/5c31626593f14d88a28f5924327b5aea_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144666/6bef0ad2d8764f09bb25f60674982ed3_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144686/28b3bc8067504693a6811cdfbe29f608_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144686/c2a4cc0180f14f2e849b83f91fdc7e16_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144733/2b93d57c6cad445ea06c85a84a22330b_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144698/a90c137ec4a343d4b3f70bf895e2f396_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144698/eb7343b72d8a41dbad361a0bf905ec25_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127202/d600e260d8124daf9d98757d5cca4d13_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127200/6fd4ca132db64a03bb5b86f67a28ce47_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144799/6106b1e5044f481b87949f6d7bc209c4_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/104070/f2070590fb30455c9651ce58a042b0c6_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144867/3564a5e4ae2645fdad39d46a51d461b6_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/127372/3376b0695d5b4d9790c31ea2811b085e_rgb_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/5da4ee1b70f54a0eb484b18ec8c048c8_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/73c08d3b5e254a258b44d56113377057_thermal_600.jpeg",
        "https://thumbs-us.o.prospera.ag/144879/eeeb1b092f26410aaef9106ad40bb93a_thermal_600.jpeg",
    ]
}
