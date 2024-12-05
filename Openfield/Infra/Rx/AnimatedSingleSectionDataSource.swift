// This voodoo code was copied from https://gist.github.com/lm2343635/79419495dd691b9253bb326671019c55
// and https://github.com/RxSwiftCommunity/RxDataSources/issues/265#issuecomment-427602214
// It helps animate changes in tableviews with rx data sources

import RxDataSources

protocol AnimatableModel: IdentifiableType, Equatable {}
protocol SectionModel: SectionModelType {}
protocol AnimatedSectionModelType: AnimatableSectionModelType {}
