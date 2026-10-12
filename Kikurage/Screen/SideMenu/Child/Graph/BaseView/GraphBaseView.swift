//
//  GraphBaseView.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2021/1/11.
//  Copyright © 2021 shusuke. All rights reserved.
//

import DGCharts
import SwiftUI

enum GraphDataType {
    case temperature
    case humidity
}

struct GraphBaseView: View {
    @StateObject var state: GraphState

    init(state: GraphState) {
        _state = StateObject(wrappedValue: state)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                graphSection(
                    title: R.string.localizable.side_menu_graph_temperature_subtitle(),
                    datas: state.temperatureGraphDatas,
                    graphDataType: .temperature
                )

                graphSection(
                    title: R.string.localizable.side_menu_graph_humidity_subtitle(),
                    datas: state.humidityGraphDatas,
                    graphDataType: .humidity
                )
            }
            .padding(.top, 40)
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .alert(state.errorMessage, isPresented: $state.hasError) {
            Button(R.string.localizable.common_alert_ok_btn_ok(), role: .cancel) {}
        }
    }

    private func graphSection(title: String, datas: [Int], graphDataType: GraphDataType) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .padding(.horizontal, 20)

            ZStack {
                LineChartViewRepresentable(datas: datas, graphDataType: graphDataType)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .padding(.horizontal, 10)

                if state.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

private struct LineChartViewRepresentable: UIViewRepresentable {
    let datas: [Int]
    let graphDataType: GraphDataType

    private let chartViewHelper = ChartViewHelper()

    func makeUIView(context: Context) -> LineChartView {
        let view = LineChartView()
        view.noDataText = ""
        return view
    }

    func updateUIView(_ uiView: LineChartView, context: Context) {
        guard !datas.isEmpty else { return }

        let entries = datas.enumerated().map { ChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        uiView.leftAxis.removeAllLimitLines()

        switch graphDataType {
        case .temperature:
            let dataSet = LineChartDataSet(entries: entries, label: "[℃]")
            dataSet.colors = [R.color.subColor()!]
            dataSet.circleColors = [R.color.subColor()!]
            uiView.data = LineChartData(dataSet: dataSet)
            uiView.xAxis.labelPosition = .bottom

            let temperatureLimitLine = ChartLimitLine(limit: 20.0)
            temperatureLimitLine.lineDashLengths = [4.0]
            uiView.leftAxis.addLimitLine(temperatureLimitLine)
            uiView.xAxis.valueFormatter = chartViewHelper
        case .humidity:
            let dataSet = LineChartDataSet(entries: entries, label: "[%]")
            dataSet.colors = [R.color.subColor()!]
            dataSet.circleColors = [R.color.subColor()!]
            uiView.data = LineChartData(dataSet: dataSet)
            uiView.xAxis.labelPosition = .bottom

            let humidityLimitLine = ChartLimitLine(limit: 80.0)
            humidityLimitLine.lineDashLengths = [4.0]
            uiView.leftAxis.addLimitLine(humidityLimitLine)
            uiView.xAxis.valueFormatter = chartViewHelper
        }
    }
}

#Preview {
    let state = GraphState()
    state.temperatureGraphDatas = [18, 19, 21, 20, 22, 23, 21]
    state.humidityGraphDatas = [70, 72, 75, 78, 80, 77, 74]
    return GraphBaseView(state: state)
}
