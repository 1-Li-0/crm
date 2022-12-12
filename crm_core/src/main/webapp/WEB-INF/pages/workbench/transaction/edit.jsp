<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

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

		$(function () {
			$(".myDate").datetimepicker({
				language:'zh-CN',	//选择中文
				format:'yyyy-mm-dd',	//日期格式
				minView:'month',	//最小视图为月份下的日期（精确到“日”）
				initialDate:new Date(),	//初始化显示当前日期
				autoclose:true,	//开启时间选择完毕后自动关闭日历
				todayBtn:true,	//添加选定当前时间的按钮
				clearBtn:true  //给日历添加清空按钮
			})

			$("#activitySourceA").click(function () {
				$("#queryActivityTxt").val("");
				$("#activity_tBody").html("");
				$("#findMarketActivityModal").modal("show");
			});
			$("#queryActivityTxt").keyup(function () {
				var name= $.trim(this.value);
				$.ajax({
					url:"workbench/transaction/queryActivityByName.do",
					data:{name:name},
					type:"post",
					dataType:"json",
					success:function (activityList) {
						var htmlStr="";
						if (activityList!=null){
							$.each(activityList,function (index,obj) {
								htmlStr += "<tr>"
								htmlStr += "<td><input activityId=\""+obj.id+"\" type=\"radio\" name=\"activity\"/></td>"
								htmlStr += "<td>"+obj.name+"</td>"
								htmlStr += "<td>"+obj.startDate+"</td>"
								htmlStr += "<td>"+obj.endDate+"</td>"
								htmlStr += "<td>"+obj.owner+"</td>"
								htmlStr += "</tr>"
							});
						}
						$("#activity_tBody").html(htmlStr);
					}
				});
			});
			$("#activity_tBody").on("click","input[type=radio]",function () {
				$("#hidden_activityId").val(this.value);
				$("#activitySrcTxt").val($(this).attr("activityId"));
				$("#findMarketActivityModal").modal("hide");
			});

			$("#contactsFullNameA").click(function () {
				$("#queryContactsTxt").val("");
				$("#contacts_tBody").html("");
				$("#findContactsModal").modal("show");
			});
			$("#queryContactsTxt").click(function () {
				var name= $.trim(this.value);
				$.ajax({
					url:"workbench/transaction/queryContactsByName.do",
					data:{name:name},
					type:"post",
					dataType:"json",
					success:function (contactsList) {
						var htmlStr="";
						if (contactsList!=null){
							$.each(contactsList,function (index,obj) {
								htmlStr += "<tr>"
								htmlStr += "<td><input contactsId=\""+obj.id+"\" type=\"radio\" name=\"activity\"/></td>"
								htmlStr += "<td>"+obj.fullname+"</td>"
								htmlStr += "<td>"+obj.email+"</td>"
								htmlStr += "<td>"+obj.mphone+"</td>"
								htmlStr += "</tr>"
							});
						}
						$("#contacts_tBody").html(htmlStr);
					}
				});
			});
			$("#contacts_tBody").on("click","input[type=radio]",function () {
				$("#hidden_contactsId").val(this.value);
				$("#contactsNameTxt").val($(this).attr("contactsId"));
				$("#findContactsModal").modal("hide");
			});
			//根据阶段查询可能性
			$("#create-transactionStage").change(function () {
				var stage = $("#create-transactionStage option:selected").text();
				if (stage==""){
					return;
				}
				$.ajax({
					url:"workbench/transaction/getPossibilityByStage.do",
					data:{stage:stage},
					type:"post",
					dataType:"json",
					success:function (data) {
						$("#create-possibility").val(data+"%");
					}
				});
			});
			//模糊查询客户名称
			$("#create-accountName").typeahead({
				source:function (jquery, process) {
					$.ajax({
						url:"workbench/transaction/queryCustomerNameForCreateByName.do",
						data:{name:jquery},
						type:"post",
						dataType:"json",
						success:function (data) {
							process(data);
						}
					});
				}
			});
			//保存
			$("#editTranBtn").click(function () {
				var owner=$("#create-transactionOwner").val();
				var money=$("#create-amountOfMoney").val();
				var name=$("#create-transactionName").val();
				var expectedDate=$("#create-expectedClosingDate").val();
				var cusName=$("#create-accountName").val();
				var stage=$("#create-transactionStage").val();
				var type=$("#create-transactionType").val();
				var source=$("#create-clueSource").val();
				var activityId=$("#hidden_activityId").val();
				var contactsId=$("#hidden_contactsId").val();
				var description=$("#create-describe").val();
				var contactSummary=$("#create-contactSummary").val();
				var nextContactTime=$("#create-nextContactTime").val();
				var id = $("#hidden_tranId").val();
				if (owner==""){
					alert("必须填写所有者");
					return;
				}
				if (name==""){
					alert("必须填写交易名称");
					return;
				}
				if (expectedDate==""){
					alert("必须填写交付日期");
					return;
				}
				if (cusName==""){
					alert("必须填写客户名称");
					return;
				}
				if (stage==""){
					alert("必须填写阶段");
					return;
				}
				$.ajax({
					url:"workbench/transaction/editTran.do",
					data:{
						id:id,
						owner:owner,
						money:money,
						name:name,
						expectedDate:expectedDate,
						cusName:cusName,
						stage:stage,
						type:type,
						source:source,
						activityId:activityId,
						contactsId:contactsId,
						description:description,
						contactSummary:contactSummary,
						nextContactTime:nextContactTime
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.code=="1"){
							window.location.href="workbench/transaction/index.do"
						}else {
							alert(data.message);
						}
					}
				});
			});
			//打开修改页面立即显示当前交易信息
			queryTranById();

		});

		function queryTranById() {
			var id = $("#hidden_tranId").val();
			$.ajax({
				url:"workbench/transaction/queryTranById.do",
				data:{id:id},
				type:"post",
				dataType:"json",
				success:function (map) {
					$("#create-transactionOwner").val(map.tran.owner);
					$("#create-amountOfMoney").val(map.tran.money);
					$("#create-transactionName").val(map.tran.name);
					$("#create-expectedClosingDate").val(map.tran.expectedDate);
					$("#create-accountName").val(map.tran.customerId);
					$("#create-transactionStage").val(map.tran.stage);
					$("#create-transactionType").val(map.tran.type);
					$("#create-possibility").val(map.possibility);
					$("#create-clueSource").val(map.tran.source);
					$("#hidden_activityId").val(map.tran.activityId);
					$("#activitySrcTxt").val(map.activityName);
					$("#hidden_contactsId").val(map.tran.contactsId);
					$("#contactsNameTxt").val(map.contactsName);
					$("#create-describe").val(map.tran.description);
					$("#create-contactSummary").val(map.tran.contactSummary);
					$("#create-nextContactTime").val(map.tran.nextContactTime);
				}
			})
		}
	</script>

</head>
<body>
<input type="hidden" id="hidden_tranId" value="${tranId}">
	<!-- 查找市场活动 -->
	<div class="modal fade" id="findMarketActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
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
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activity_tBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->
	<div class="modal fade" id="findContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="queryContactsTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contacts_tBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>


	<div style="position:  relative; left: 30px;">
		<h3>修改交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="editTranBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>

		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" id="create-expectedClosingDate">
			</div>
		</div>

		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="stage">
					  <option value="${stage.id}">${stage.value}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>

		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${tranTypeList}" var="type">
						<option value="${type.id}">${type.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>

		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="activitySrcTxt" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="activitySourceA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden_activityId">
				<input type="text" class="form-control" id="activitySrcTxt">
			</div>
		</div>

		<div class="form-group">
			<label for="contactsNameTxt" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="contactsFullNameA"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="hidden_contactsId">
				<input type="text" class="form-control" id="contactsNameTxt">
			</div>
		</div>

		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label myDate">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" id="create-nextContactTime">
			</div>
		</div>

	</form>
</body>
</html>
