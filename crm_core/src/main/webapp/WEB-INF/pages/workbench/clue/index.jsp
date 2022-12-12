<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
		queryClueByConditionsForPages(1,10);

		$("#queryClueByConditionsForPagesBtn").click(function () {
			$("#hidden-fullname").val($.trim($("#query-fullname").val()));
			$("#hidden-company").val($.trim($("#query-company").val()));
			$("#hidden-phone").val($.trim($("#query-phone").val()));
			$("#hidden-source").val($("#query-source").val());
			$("#hidden-owner").val($.trim($("#query-owner").val()));
			$("#hidden-mphone").val($.trim($("#query-mphone").val()));
			$("#hidden-state").val($("#query-state").val());

			queryClueByConditionsForPages(1,$("#rowsPages").bs_pagination('getOption','rowsPerPage'));
		});
		//全选按钮
		$("#checkedAll").click(function () {
			$("#tbody input[type='checkbox']").prop("checked",this.checked)
		});
		$("#tbody").on("click","input[type='checkbox']",function () {
			if ($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkedAll").prop("checked",true);
			}else {
				$("#checkedAll").prop("checked",false);
			}
		});

		//创建线索
		$("#createClueBtn").click(function () {
			$("#saveCreateClueForm")[0].reset();
			$("#createClueModal").modal("show");
		});
		$("#saveCreateClueBtn").click(function () {
			var owner = $("#create-clueOwner").val();
			var company = $("#create-company").val();
			var appellation = $("#create-call").val();
			var fullname = $("#create-surname").val();
			var job = $("#create-job").val();
			var email = $("#create-email").val();
			var phone = $("#create-phone").val();
			var website = $("#create-website").val();
			var mphone = $("#create-mphone").val();
			var state = $("#create-status").val();
			var source = $("#create-source").val();
			var description = $("#create-describe").val();
			var contactSummary = $("#create-contactSummary").val();
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $("#create-address").val();
			if (owner==''){
				alert("所有者不能为空");
				return;
			}
			if (company==''){
				alert("公司不能为空");
				return;
			}
			if (appellation==''){
				alert("称呼不能为空");
				return;
			}
			if (fullname==''){
				alert("姓名不能为空");
				return;
			}
			if (!/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)){
				alert("邮箱不符合书写规范");
				return;
			}
			if (!/0\d{2,3}-\d{7,8}|\(?0\d{2,3}[)-]?\d{7,8}|\(?0\d{2,3}[)-]*\d{7,8}/.test(phone)){
				alert("座机号不符合书写规范");
				return;
			}
			if (!/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphone)){
				alert("手机号不符合书写规范");
				return;
			}
			if (!/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)){alert("网站域名不符合书写规范");
				return;}
			$.ajax({
				url:'workbench/clue/saveCreateClue.do',
				data:{fullname:fullname,appellation:appellation,owner:owner,company:company,job:job,email:email,phone:phone,website:website,mphone:mphone,state:state,source:source,description:description,contactSummary:contactSummary,nextContactTime:nextContactTime,address:address},
				type: 'post',
				dataType: 'json',
				success:function (data) {
					if (data.code=="1"){
						$("#createClueModal").modal("hide");
						queryClueByConditionsForPages(1,$("#rowsPages").bs_pagination("getOption","rowsPerPage"));
					}else {
						alert(data.message);
					}
				}
			});
		});

		//删除线索
		$("#deleteClueBtn").click(function () {
			var array = $("#tbody input[type='checkbox']:checked");
			if (array.size()==0){
				alert("至少选中一个选项");
				return;
			}
			if (confirm("是否确认删除？")){
				var ids = "";
				$.each(array, function (index, dom) {
					ids += "id=" + dom.value + "&";
				});
				$.ajax({
					url:"workbench/clue/deleteCluesByIds.do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if (data.code=="1"){
							queryClueByConditionsForPages(1,$("#rowsPages").bs_pagination('getOption','rowsPerPage'));
						}else {alert(data.message);}
					}
				});
			}
		});

		//修改线索
		$("#editClueBtn").click(function () {
			if ($("#tbody input[type='checkbox']:checked").size()>1){
				alert("选择项目不能超过一个");
				return;
			}
			if ($("#tbody input[type='checkbox']:checked").size()<1){
				alert("请选择一项线索");
				return;
			}
			var id=$("#tbody input[type='checkbox']:checked").val();
			$.ajax({
				url:"workbench/clue/queryClueById.do",
				data:{id:id},
				type:'post',
				dataType:'json',
				success:function (clue) {
					$("#hidden-id").val(clue.id);
					$("#edit-surname").val(clue.fullname);
					$("#edit-call").val(clue.appellation);
					$("#edit-clueOwner").val(clue.owner);
					$("#edit-company").val(clue.company);
					$("#edit-job").val(clue.job);
					$("#edit-email").val(clue.email);
					$("#edit-phone").val(clue.phone);
					$("#edit-website").val(clue.website);
					$("#edit-mphone").val(clue.mphone);
					$("#edit-status").val(clue.state);
					$("#edit-source").val(clue.source);
					$("#edit-describe").val(clue.description);
					$("#edit-contactSummary").val(clue.contactSummary);
					$("#edit-nextContactTime").val(clue.nextContactTime);
					$("#edit-address").val(clue.address);
					$("#editClueModal").modal("show");
				}
			})
		});
		$("#editClue").click(function () {
			var id=$("#hidden-id").val();
			var fullname=$("#edit-surname").val();
			var appellation=$("#edit-call").val();
			var owner=$("#edit-clueOwner").val();
			var company=$("#edit-company").val();
			var job=$("#edit-job").val();
			var email=$("#edit-email").val();
			var phone=$("#edit-phone").val();
			var website=$("#edit-website").val();
			var mphone=$("#edit-mphone").val();
			var state=$("#edit-status").val();
			var source=$("#edit-source").val();
			var description=$("#edit-describe").val();
			var contactSummary=$("#edit-contactSummary").val();
			var nextContactTime=$("#edit-nextContactTime").val();
			var address=$("#edit-address").val();
			if (owner==''){
				alert("所有者不能为空");
				return;
			}
			if (company==''){
				alert("公司不能为空");
				return;
			}
			if (appellation==''){
				alert("称呼不能为空");
				return;
			}
			if (fullname==''){
				alert("姓名不能为空");
				return;
			}
			if (!/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)){
				alert("邮箱不符合书写规范");
				return;
			}
			if (!/0\d{2,3}-\d{7,8}|\(?0\d{2,3}[)-]?\d{7,8}|\(?0\d{2,3}[)-]*\d{7,8}/.test(phone)){
				alert("座机号不符合书写规范");
				return;
			}
			if (!/^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphone)){
				alert("手机号不符合书写规范");
				return;
			}
			if (!/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)){alert("网站域名不符合书写规范");
				return;}
			$.ajax({
				url:"workbench/clue/editClue.do",
				data:{id:id,fullname:fullname,appellation:appellation,owner:owner,company:company,job:job,email:email,phone:phone,website:website,mphone:mphone,state:state,source:source,description:description,contactSummary:contactSummary,nextContactTime:nextContactTime,address:address},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.code=="1"){
						$("#editClueModal").modal("hide");
						queryClueByConditionsForPages($("#rowsPages").bs_pagination("getOption","currentPage"),$("#rowsPages").bs_pagination("getOption","rowsPerPage"));
					}else {alert(data.message)}
				}
			})
		});

	});
	function queryClueByConditionsForPages(pageNo,pageSize) {
		var fullname=$("#hidden-fullname").val();
		var company=$("#hidden-company").val();
		var phone=$("#hidden-phone").val();
		var source=$("#hidden-source").val();
		var owner=$("#hidden-owner").val();
		var mphone=$("#hidden-mphone").val();
		var state=$("#hidden-state").val();
		$.ajax({
			url:'workbench/clue/queryClueByConditionsForPages.do',
			data:{fullname:fullname,owner:owner,company:company,phone:phone,source:source,mphone:mphone,state:state,pageNo:pageNo,pageSize:pageSize},
			type:'post',
			dataType:'json',
			success:function (data) {
				var clueStr='';
				$.each(data.clueList,function (index,clue) {
					clueStr+="<tr>"
					clueStr+="<td><input type=\"checkbox\" value='"+clue.id+"'/></td>"
					clueStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/queryClueDetailById.do?id="+clue.id+"';\">"+clue.fullname+clue.appellation+"</a></td>"
					clueStr+="<td>"+clue.company+"</td>"
					clueStr+="<td>"+clue.phone+"</td>"
					clueStr+="<td>"+clue.mphone+"</td>"
					clueStr+="<td>"+clue.source+"</td>"
					clueStr+="<td>"+clue.owner+"</td>"
					clueStr+="<td>"+clue.state+"</td>"
					clueStr+="</tr>"
				})
				$("#tbody").html(clueStr);
				$("#checkedAll").prop('checked',false);//翻页时清空全选按钮
				var totalPages=Math.ceil(data.totalRows/pageSize);//计算页数，向上取整
				//设置分页插件
				$("#rowsPages").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,
					visiblePageLinks: 5,
					showGoToPage: true,//显示跳转的页数
					showRowsPerPage: true,//显示每页的条数
					showRowsInfo: true,//显示条目信息
					onChangePage:function (event, pageInfo) {
						queryClueByConditionsForPages(pageInfo.currentPage,pageInfo.rowsPerPage);
					}
				})
			}
		});
	}

</script>
</head>
<body>
	<!-- 隐藏域 -->
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-state">

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="saveCreateClueForm" class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
									<c:forEach items="${users}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>

						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
								  <c:forEach items="${appellations}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>

						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>

						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>

						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
								  <c:forEach items="${clueStates}" var="clueState">
									  <option value="${clueState.id}">${clueState.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${sources}" var="source">
									  <option value="${source.id}">${source.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>


						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" id="create-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<input type="hidden" id="hidden-id">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <c:forEach items="${users}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${appellations}" var="appellation">
										<option value="${appellation.id}">${appellation.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${clueStates}" var="clueState">
										<option value="${clueState.id}">${clueState.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${sources}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime">
								</div>
							</div>
						</div>

						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="editClue">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" id="query-fullname" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" id="query-company" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="query-phone" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="query-source">
					  	  <option></option>
						  <c:forEach items="${sources}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="query-owner" type="text">
				    </div>
				  </div>



				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" id="query-mphone" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="query-state">
					  	<option></option>
						  <c:forEach items="${clueStates}" var="clueState">
							  <option value="${clueState.id}">${clueState.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" id="queryClueByConditionsForPagesBtn" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="createClueBtn" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editClueBtn" class="btn btn-default"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deleteClueBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tbody">

					</tbody>
				</table>
				<div id="rowsPages"></div>
			</div>

			<%--<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
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
