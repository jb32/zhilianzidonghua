//
//  LineCharts.swift
//  WeexDemo
//
//  Created by zzzl on 2018/11/2.
//  Copyright © 2018 zzzl. All rights reserved.
//

import Foundation
import Charts

extension LineCharts {
    var chartView: LineChartView {
        return view as! LineChartView
    }
}

extension LineCharts {
    
    open override func loadView() -> UIView {
        let lineChartView = LineChartView()
        return lineChartView
    }
    
    open override func viewDidLoad() {
        chartView.delegate = self
        chartView.noDataText = "暂无数据"
        
        //设置交互样式
        chartView.scaleYEnabled = false //取消Y轴缩放
        chartView.doubleTapToZoomEnabled = true //双击缩放
        chartView.dragEnabled = true //启用拖动手势
        chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView.dragDecelerationFrictionCoef = 0.9  //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //设置X轴样式
        let xAxis = chartView.xAxis
        xAxis.axisLineWidth = 1.0 / UIScreen.main.scale //设置X轴线宽
        xAxis.labelPosition = .bottom //X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = false//不绘制网格线
        xAxis.forceLabelsEnabled = false
        xAxis.spaceMin = 1 //设置label间隔
//        xAxis.labelCount = 10
        xAxis.axisMinimum = 0
        xAxis.labelTextColor = UIColor.blue//label文字颜色
//        let xValueFormatter = NumberFormatter()  //自定义格式
//        let xformat = DefaultAxisValueFormatter(formatter: xValueFormatter)//自定义格式
//        xAxis.valueFormatter = xformat
        
        //设置Y轴样式
        chartView.rightAxis.enabled = false  //不绘制右边轴
        
        let leftAxis = chartView.leftAxis
//        leftAxis.labelCount = 16 //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
//        leftAxis.forceLabelsEnabled = false //不强制绘制指定数量的label
//        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = false //从0开始绘制
        //leftAxis.axisMaximum = 1000 //设置Y轴的最大值
        leftAxis.inverted = false //是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 1.0 / UIScreen.main.scale //设置Y轴线宽
        leftAxis.axisLineColor = UIColor.cyan//Y轴颜色
        
        let leftValueFormatter = NumberFormatter()  //自定义格式
//        leftValueFormatter.numberStyle = .decimal
        leftValueFormatter.positiveSuffix = "℃"  //数字后缀单位℃
        leftValueFormatter.maximumFractionDigits = 1
        let yformat = DefaultAxisValueFormatter(formatter: leftValueFormatter)//自定义格式
        leftAxis.valueFormatter = yformat
        
        leftAxis.labelPosition = .outsideChart//label位置
        leftAxis.labelTextColor = UIColor.blue//文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)//文字字体
        
        //设置网格样式
        leftAxis.gridLineDashLengths = [3.0, 3.0]  //设置虚线样式的网格线
        leftAxis.gridColor = UIColor(red: 200 / 255.0, green: 200 / 255.0, blue: 200 / 255.0, alpha: 1) //网格线颜色
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
        
        //添加限制线
//        let litmitLine = ChartLimitLine(limit: 260, label: "限制线")
//        litmitLine.lineWidth = 2
//        litmitLine.lineColor = UIColor.green
//        litmitLine.lineDashLengths = [5.0, 5.0] //虚线样式
//        litmitLine.labelPosition = .rightTop  // 限制线位置
//        litmitLine.valueTextColor = UIColor.brown
//        litmitLine.valueFont = UIFont.systemFont(ofSize: 12)
//
//        leftAxis.addLimitLine(litmitLine)
//        leftAxis.drawLimitLinesBehindDataEnabled = true  //设置限制线绘制在折线图的后面
        
        //设置折线图描述及图例样式
        chartView.chartDescription?.text = "曲线图" //折线图描述
        chartView.chartDescription?.textColor = UIColor.cyan  //描述字体颜色
        chartView.legend.form = .line  // 图例的样式
        chartView.legend.formSize = 20  //图例中线条的长度
        chartView.legend.textColor = UIColor.darkGray
        deal(datas: datas)
    }
    
    open override func updateAttributes(_ attributes: [AnyHashable : Any] = [:]) {
        if let _datas = attributes["values"], let datas = _datas as? [String : Any] {
            deal(datas: datas)
            chartView.notifyDataSetChanged()
        }
    }
    
    open override func updateBindingData(_ data: [AnyHashable : Any]) {
        if let _datas = attributes["values"], let datas = _datas as? [String : Any] {
            deal(datas: datas)
            chartView.notifyDataSetChanged()
        }
    }
    
    open override func addEvent(_ eventName: String) {
        if eventName == "toSelect" {
            selectEvent = true
        }
    }
    
    open override func removeEvent(_ eventName: String) {
        if eventName == "toSelect" {
            selectEvent = false
        }
    }
}

extension LineCharts: ChartViewDelegate {
    public func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        [self fireEvent:@"change" params:@{@"index":@(index)} domChanges:@{@"attrs": @{@"index": @(index)}}];
        if selectEvent {
            let values = datas["values"] as! [[String: Any]]
            let value = values[Int(entry.x)]
            let ys = value["y"] as? [Double]
            var y = 0
            
            ys?.enumerated().forEach({ (item) in
                if item.element == entry.y {
                    y = item.offset
                }
            })
            fireEvent("toSelect", params: ["indexX": entry.x, "indexY": y, "y": entry.y], domChanges: ["attrs": ["y": entry.y]])
        }
    }
}

extension LineCharts {
    @objc func reload(datas: [String : Any]) -> Void {
        self.datas = datas
        deal(datas: datas)
    }
    
    @objc func select(index: Int, y: Double) {
        if let dataSets = chartView.data?.dataSets, dataSets.count > 0 {
            chartView.highlightValue(x: Double(index), y: y, dataSetIndex: 1)
        }
    }
    /// //设置折线图的数据
    ///
    /// - Parameter datas: datas description
    func deal(datas: [String : Any]) -> Void {
        var xValues = [Double]()
        var yDatas = [[Double]]()
        
        let titles = datas["titles"] as! [String]
        let values = datas["values"] as! [[String: Any]]
        
        guard values.count != 0 else {
            return
        }
        
        for value in values {
            if let x = value["x"] as? Double {
                xValues.append(x)
            }
            
            if let entrys = value["y"] as? [Double] {
                yDatas.append(entrys)
            }
        }
        guard yDatas.count != 0 else {
            return
        }
        var dataSets = [LineChartDataSet]()
        
        for i in 0 ..< yDatas[0].count {
            let yValues = yDatas.enumerated().map({ ChartDataEntry(x: Double($0.offset), y: $0.element[i]) })
            
            var dataSet: LineChartDataSet?
            let color = UIColor.random
            
            if chartView.data != nil && chartView.data!.dataSets.count > 0  {
                dataSet = chartView.data?.dataSets[i] as? LineChartDataSet
                dataSet?.values = yValues
                dataSet?.drawHorizontalHighlightIndicatorEnabled = false //不显示横向十字线
            } else {
                dataSet = LineChartDataSet(values: yValues, label: titles[i])
                dataSet?.colors = [color]
                dataSet?.drawCirclesEnabled = false
                dataSet?.lineWidth = 1.0
                dataSet?.mode = .horizontalBezier  //设置曲线是否平滑
                dataSets.append(dataSet!)
                
                let valueFormatter = NumberFormatter()  //自定义格式
                valueFormatter.maximumFractionDigits = 1
                let format = DefaultValueFormatter(formatter: valueFormatter)//自定义格式
                dataSet?.valueFormatter = format
            }
        }
        chartView.xAxis.valueFormatter = ChartAxisValueFormatter(xValues)

        if chartView.data == nil {
            let datas = LineChartData(dataSets: dataSets)
            chartView.data = datas
        } else {
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        }
//        chartView.animate(xAxisDuration: 0.2)  //设置动画时间
    }
}
