<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/echars/echarts.min.js"></script>
<script type="text/javascript">
    $(function () {
        $.ajax({
            url:"workbench/chart/transaction/queryCountOfTranByStage.do",
            type:"post",
            dataType:"json",
            success:function (data) {
                var chartDom = document.getElementById('main');
                var myChart = echarts.init(chartDom);
                var option = {
                    title: {
                        text: '交易数据统计',
                        subtext:'根据阶段分组统计交易数量'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: '{a} <br/>{b} : {c}'
                    },
                    toolbox: {
                        feature: {
                            dataView: { readOnly: false },
                            restore: {},
                            saveAsImage: {}
                        }
                    },
                    /* 图例
                    legend: {
                        data: ['Show', 'Click', 'Visit', 'Inquiry', 'Order']
                    },*/
                    series: [
                        {
                            name: '数据量',
                            type: 'funnel',
                            left: '10%',
                            width: '80%',
                            label: {
                                show:true,
                                formatter: '{b}'
                            },
                            labelLine: {
                                show: false
                            },
                            itemStyle: {
                                opacity: 0.7
                            },
                            emphasis: {
                                label: {
                                    position: 'inside',
                                    formatter: '{b}数量: {c}'
                                }
                            },
                            data: data
                        },
                    ]
                };
                option && myChart.setOption(option);

            }
        })
    })
</script>
</head>
<body>
    <div id="main" style="width: 600px;height: 400px;"></div>
</body>
</html>
