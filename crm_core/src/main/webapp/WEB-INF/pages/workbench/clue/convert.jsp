<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
	<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	(function($){
		$.fn.datetimepicker.dates['zh-CN'] = {
			days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"],
			daysShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "周日"],
			daysMin:  ["日", "一", "二", "三", "四", "五", "六", "日"],
			months: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			monthsShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
			today: "今天",
			suffix: [],
			meridiem: ["上午", "下午"],
			clear:["清空"]
		};
	}(jQuery));

	$(function(){
		$(".myDate").datetimepicker({
			language:'zh-CN',	//选择中文
			format:'yyyy-mm-dd',	//日期格式
			minView:'month',	//最小视图为月份下的日期（精确到“日”）
			initialDate:new Date(),	//初始化显示当前日期
			autoclose:true,	//开启时间选择完毕后自动关闭日历
			todayBtn:true,	//添加选定当前时间的按钮
			clearBtn:true  //给日历添加清空按钮
		})

		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});
		//打开模态窗口查询活动列表
		$("#searchActivity").click(function () {
			$("#searchActivityModal").modal("show");
		});
		$("#queryActivityTxt").keyup(function () {
			var name = this.value;
			var id = "${clue.id}";
			$.ajax({
				url:"workbench/clue/queryActivityForConvertByName.do",
				data:{name:name,id:id},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr="";
					$.each(data,function (index, obj) {
						htmlStr+="<tr>"
						htmlStr+="<td><input type=\"radio\" name=\"activity\" value=\""+obj.id+"\" activityName=\""+obj.name+"\"/></td>"
						htmlStr+="<td>"+obj.name+"</td>"
						htmlStr+="<td>"+obj.startDate+"</td>"
						htmlStr+="<td>"+obj.endDate+"</td>"
						htmlStr+="<td>"+obj.owner+"</td>"
						htmlStr+="</tr>"
					});
					$("#activityList_tBody").html(htmlStr);
				}
			});
		});
		//获取选定活动的id和name，并且显示在文本中
		$("#activityList_tBody").on("click","input[type='radio']",function () {
			$("#hidden_activity_id").val(this.value);
			$("#activity_name").val($(this).attr("activityName"));
			$("#searchActivityModal").modal("hide");
		});
		//转换
		$("#convertBtn").click(function () {
			var clueId = "${clue.id}";
			var flag = $("#isCreateTransaction").prop("checked");
			var money = $.trim($("#amountOfMoney").val());
			var name = $.trim($("#tradeName").val());
			var expectedDate = $("#expectedClosingDate").val();
			var stage = $("#stage").val();
			var activityId = $("#hidden_activity_id").val();
			if (flag==true) {
				if (!/^(([1-9]\d*)|0)$/.test(money)) {
					alert("金额只能是非负整数");
					return;
				}
			}
			$.ajax({
				url:"workbench/clue/saveConvertClue.do",
				data: {
					clueId:clueId,
					flag:flag,
					money:money,
					name:name,
					expectedDate:expectedDate,
					stage:stage,
					activityId:activityId,
					source:"${clue.source}",
					description:"${clue.description}",
					contactSummary:"${clue.contactSummary}",
					nextContactTime:"${clue.nextContactTime}"
				},
				type: "post",
				dataType: "json",
				success:function (data) {
					if (data.code=="1"){
						window.location.href="workbench/clue/index.do";
					}else {
						alert(data.message);
					}
				}
			});
		});
	});
</script>

</head>
<body>

	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="queryActivityTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList_tBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >

		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control myDate" id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity_name">市场活动源&nbsp;&nbsp;<a id="searchActivity" href="javascript:void(0);" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="hidden_activity_id">
		    <input type="text" class="form-control" id="activity_name" placeholder="点击上面搜索" readonly>
		  </div>
		</form>

	</div>

	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input id="convertBtn" class="btn btn-primary" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>
