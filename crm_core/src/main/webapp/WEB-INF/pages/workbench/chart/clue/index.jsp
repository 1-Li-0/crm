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
                url:"workbench/chart/clue/queryClueCountByOwner.do",
                type:"post",
                dataType:"json",
                success:function (data) {
                    var chartDom = document.getElementById('main');
                    var myChart = echarts.init(chartDom);
                    var option = {
                        title: {
                            text: '客户和联系人表',
                            subtext:'每个销售员拥有的线索数量'
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
                        series: [
                            {
                                name: 'Expected',
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
                                        formatter: '{b}: {c}'
                                    }
                                },
                                data: data
                            }
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
