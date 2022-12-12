<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>

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
	var rsc_bs_pag = {
		go_to_page_title: '跳转到',
		rows_per_page_title: '每页显示',
		current_page_label: '页',
		current_page_abbr_label: 'p.',
		total_pages_label: 'of',
		total_pages_abbr_label: '/',
		total_rows_label: 'of',
		rows_info_records: '记录',
		go_top_text: '首页',
		go_prev_text: '上一页',
		go_next_text: '下一页',
		go_last_text: '尾页'
	};
	//入口函数
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
		$("#editActivityBtn").click(function () {
			var checkedIds=$("#tbody input[type='checkbox']:checked");
			if(checkedIds.size()==1){
				var id = checkedIds.val();
				$.ajax({
					url:'workbench/activity/queryActivityById.do',
					data:{id:id},
					type:'post',
					dataType:'json',
					success:function (activity) {
						$("#hidden-id").val(activity.id);
						$("#edit-marketActivityOwner").val(activity.owner);
						$("#edit-marketActivityName").val(activity.name);
						$("#edit-startTime").val(activity.startDate);
						$("#edit-endTime").val(activity.endDate);
						$("#edit-cost").val(activity.cost);
						$("#edit-describe").val(activity.description);
					}
				})
				$("#editActivityModal").modal("show");
				$("#editActivity").click(function () {
					var id = $("#hidden-id").val()
					var owner = $("#edit-marketActivityOwner").val();
					var name = $("#edit-marketActivityName").val();
					var startDate = $("#edit-startTime").val();
					var endDate = $("#edit-endTime").val();
					var cost = $("#edit-cost").val();
					var description = $("#edit-describe").val();
					if (owner==""){
						alert("所有者不能为空");
						return;
					}
					if(name==""){
						alert("名称不能为空");
						return;
					}
					if (startDate!="" && endDate!=""){
						if (startDate>endDate){
							alert("结束日期不能比开始日期小");
							return;
						}
					}
					if (!/^(([1-9]\d*)|0)$/.test(cost)){
						alert("成本只能为非负整数");
						return;
					}
					$.ajax({
						url:'workbench/activity/saveEditActivityById.do',
						data:{
							id:id,
							owner:owner,
							name:name,
							startDate:startDate,
							endDate:endDate,
							cost:cost,
							description:description
						},
						type:'post',
						dataType:'json',
						success:function (data) {
							if (data.code=='1'){
								$("#editActivityModal").modal("hide");
								queryActivityByConditionForPage($("#rows_and_pages").bs_pagination('getOption','currentPage'),$("#rows_and_pages").bs_pagination('getOption','rowsPerPage'));
							}else {alert(data.message)}
						}
					})
				})
			}else {
				alert("只能选中一条数据！");
				return;}
		})
		$("#deleteActivityBtn").click(function () {
			var checkedIds=$("#tbody input[type='checkbox']:checked");
			if (checkedIds.size()==0){
				alert("请选择想要删除的活动！");
				return;
			}
			if (window.confirm("是否确认删除？")){
				var ids=''
				$.each(checkedIds,function (index,dom) {
					ids+='id='+dom.value+'&'
				})
				$.ajax({
					url:'workbench/activity/deleteActivitiesByIds.do',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (data) {
						if (data.code=='1'){
							queryActivityByConditionForPage(1,$("#rows_and_pages").bs_pagination('getOption','rowsPerPage'));
						}else {
							alert(data.message);
						}
					}
				})
			}else {return;}
		})
		//全选按钮
		$("#checkedAll").click(function () {
			$("#tbody input[type='checkbox']").prop('checked',this.checked);
		})
		$("#tbody").on("click","input[type='checkbox']",function () {
			if ($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkedAll").prop('checked',true);
			}else {
				$("#checkedAll").prop('checked',false);
			}
		})

		$("#createActivityBtn").click(function () {
			//重置模态窗口，然后展示窗口
			$("#createActivityForm")[0].reset();
			$("#createActivityModal").modal("show");
		});
		$("#saveCreateActivity").click(function () {
				var owner = $("#create-marketActivityOwner").val();
				var name = $.trim($("#create-marketActivityName").val());
				var startDate = $("#create-startDate").val();
				var endDate = $("#create-endDate").val();
				var cost = $.trim($("#create-cost").val());
				var description = $.trim($("#create-describe").val());
				if (owner==""){
					alert("所有者不能为空");
					return;
				}
				if(name==""){
					alert("名称不能为空");
					return;
				}
				if (startDate!="" && endDate!=""){
					if (startDate>endDate){
						alert("结束日期不能比开始日期小");
						return;
					}
				}
				if (!/^(([1-9]\d*)|0)$/.test(cost)){
					alert("成本只能为非负整数");
					return;
				}
				$.ajax({
					url:"workbench/activity/saveCreateActivity.do",
					type:"post",
					data:{
						owner:owner,
						name:name,
						startDate:startDate,
						endDate:endDate,
						cost:cost,
						description:description
					},
					dataType:"json",
					success:function (data) {
						if (data.code=="1"){
							$("#createActivityModal").modal("hide");
							//刷新列表
							queryActivityByConditionForPage(1,$("#rows_and_pages").bs_pagination('getOption','rowsPerPage'));
						}else {
							alert(data.message);
							//$("#createActivityModal").modal("show");//可以不写，默认不隐藏窗口
						}
					}
				})
			}
		)
		//打开市场活动页面就立即查询最近的十条活动记录
		queryActivityByConditionForPage(1,10);
		//点击查询按钮进行查询第一页的n条数据
		$("#queryActivityBtn").click(function () {
			$("#hidden-name").val($("#query-name").val());
			$("#hidden-owner").val($("#query-owner").val());
			$("#hidden-startDate").val($("#query-startDate").val());
			$("#hidden-endDate").val($("#query-endDate").val());

			queryActivityByConditionForPage(1,$("#rows_and_pages").bs_pagination('getOption','rowsPerPage'));
			});

		$("#exportActivityAllBtn").click(function () {
			window.location.href="workbench/activity/exportAllActivity.do";
		})
		$("#exportActivityXzBtn").click(function () {
			var checked = $("#tbody input[type='checkbox']:checked")
			if (checked.size()==0){
				alert("请至少选择一条活动！")
			}else {
				var str="?";
				$.each(checked,function (index,dom) {
					str += 'id='+dom.value+'&'
				})
				window.location.href="workbench/activity/exportXzActivity.do"+str;
			}
		})
		$("#importActivityBtn").click(function () {
			var activityFileName = $("#activityFile").val();
			var activityFile = $("#activityFile").get(0).files[0];
			var xls = activityFileName.substring(activityFileName.lastIndexOf(".")+1);
			if (xls.toLocaleLowerCase() != "xls"){
				alert("只能上传xls文件");
				return;
			}
			if (activityFile.size>5*1024*1024){
				alert("文件大小不能超过5mb");
				return;
			}
			//ajax提供的接口，模拟键值对的方式向后台提交数据，可以提交二进制数据和文本数据
			var formData = new FormData();
			formData.append("activityFile",activityFile);
			$.ajax({
				url:"workbench/activity/importActivityByList.do",
				data:formData,
				processData:false,//默认true，表示将参数统一转换成字符串
				contentType:false,//默认true，表示将参数统一进行urlencoded编码
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.code=="1"){
						alert("成功增加"+data.retData+"条记录");
						$("#importActivityModal").modal("hide");
						queryActivityByConditionForPage(1,$("#rows_and_pages").bs_pagination("getOption","rowsPerPage"));
					}else {
						alert(data.message);
						$("#importActivityModal").modal("show");
					}
				}
			});
		})
	});
	function queryActivityByConditionForPage(pageNo,pageSize) {
		var name=$("#hidden-name").val();
		var owner=$("#hidden-owner").val();
		var startDate=$("#hidden-startDate").val();
		var endDate=$("#hidden-endDate").val();
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{name:name,owner:owner,startDate:startDate,endDate:endDate,pageNo:pageNo,pageSize:pageSize},
			type:'post',
			dataType:'json',
			success:function (data) {
				//$("#totalRowsB").text(data.totalRows);
				var activityStr='';
				$.each(data.activityList,function (index,obj) {
					activityStr+="<tr class=\"active\" >";
					activityStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					activityStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/activityDetail.do?id="+obj.id+"';\">"+obj.name+"</a></td>";
					activityStr+="<td>"+obj.owner+"</td>";
					activityStr+="<td>"+obj.startDate+"</td>";
					activityStr+="<td>"+obj.endDate+"</td>";
					activityStr+="</tr>"
				})
				$("#tbody").html(activityStr);
				$("#checkedAll").prop('checked',false);//翻页时清空全选按钮
				var totalPages=Math.ceil(data.totalRows/pageSize);//计算页数，向上取整
				//设置分页插件
				$("#rows_and_pages").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,
					visiblePageLinks: 5,
					showGoToPage: true,//显示跳转的页数
					showRowsPerPage: true,//显示每页的条数
					showRowsInfo: true,//显示条目信息
					onChangePage:function (event, pageInfo) {
						queryActivityByConditionForPage(pageInfo.currentPage,pageInfo.rowsPerPage);
					}
				})
			}
		})
	}
</script>
</head>
<body>
	<!-- 隐藏域 -->
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="createActivityForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-startDate" readonly>
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="create-endDate" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="saveCreateActivity" class="btn btn-primary">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">
						<input type="hidden" id="hidden-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-startTime" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control myDate" id="edit-endTime" readonly>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="editActivity" class="btn btn-primary">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>


	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control myDate" type="text" id="query-startDate" name="startDate"/>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control myDate" type="text" id="query-endDate">
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tbody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="rows_and_pages"></div>
			</div>

			<%--<div style="height: 50px; position: relative;top: 30px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB"></b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>

		</div>

	</div>
</body>
</html>
