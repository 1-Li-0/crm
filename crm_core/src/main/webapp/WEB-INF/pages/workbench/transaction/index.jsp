<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>

<script type="text/javascript">
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
		$("#saveTranBtn").click(function () {
			window.location.href='workbench/transaction/save.do';
		});
		$("#editTranBtn").click(function () {
			window.location.href='workbench/transaction/edit.do';
		});

		//初始查询
		queryTranByConditionForPage(1,10);

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
		});
		//条件查询
		$("#queryTranByConditionBtn").click(function () {
			$("#hidden-name").val($("#search_owner").val());
			$("#hidden-owner").val($("#search_name").val());
			$("#hidden-customerName").val($("#customerName").val());
			$("#hidden-stage").val($("#stage").val());
			$("#hidden-type").val($("#type").val());
			$("#hidden-source").val($("#source").val());
			$("#hidden-contactsName").val($("#contactsName").val());

			queryTranByConditionForPage(1,$("#rowsAndPages").bs_pagination('getOption','rowsPerPage'));
		});
		//点击超链接查看详情
		$("#tbody").on("click","a",function () {
			var tranId=$(this).attr("tranId")
			window.location.href='workbench/transaction/toDetail.do?tranId='+tranId;
		})
		//修改按钮
		$("#editTranBtn").click(function () {
			if ($("#tbody input[type=checkbox]:checked").size()!=1){
				alert("只能选择一个进行修改");
				return;
			}else {
				var id = $("#tbody input[type=checkbox]:checked").val();
				window.location.href="workbench/transaction/edit.do?id="+id;
			}
		});

	});

	function queryTranByConditionForPage(pageNo,pageSize) {
		var owner=$("#hidden-owner").val();
		var name=$("#hidden-name").val();
		var customerName=$("#hidden-customerName").val();
		var stage=$("#hidden-stage").val();
		var type=$("#hidden-type").val();
		var source=$("#hidden-source").val();
		var contactsName=$("#hidden-contactsName").val();
		$.ajax({
			url:'workbench/transaction/queryTranListByConditionForPages.do',
			data:{name:name,owner:owner,customerName:customerName,stage:stage,type:type,source:source,contactsName:contactsName,pageNo:pageNo,pageSize:pageSize},
			type:'post',
			dataType:'json',
			success:function (data) {
				var tranStr='';
				$.each(data.tranList,function (index,obj) {
					tranStr+="<tr class=\"active\">"
					tranStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>"
					tranStr+="<td><a tranId=\""+obj.id+"\" style=\"text-decoration: none; cursor: pointer;\">"+obj.name+"</a></td>"
					tranStr+="<td>"+obj.customerId+"</td>"
					tranStr+="<td>"+obj.stage+"</td>"
					tranStr+="<td>"+obj.type+"</td>"
					tranStr+="<td>"+obj.owner+"</td>"
					tranStr+="<td>"+obj.source+"</td>"
					tranStr+="<td>"+obj.contactsId+"</td>"
					tranStr+="</tr>"
				})
				$("#tbody").html(tranStr);
				$("#checkedAll").prop('checked',false);//翻页时清空全选按钮
				var totalPages=Math.ceil(data.totalRows/pageSize);//计算页数，向上取整
				//设置分页插件
				$("#rowsAndPages").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,
					visiblePageLinks: 5,
					showGoToPage: true,//显示跳转的页数
					showRowsPerPage: true,//显示每页的条数
					showRowsInfo: true,//显示条目信息
					onChangePage:function (event, pageInfo) {
						queryTranByConditionForPage(pageInfo.currentPage,pageInfo.rowsPerPage);
					}
				})
			}
		})
	};
</script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-owner">
<input type="hidden" id="hidden-customerName">
<input type="hidden" id="hidden-stage">
<input type="hidden" id="hidden-type">
<input type="hidden" id="hidden-source">
<input type="hidden" id="hidden-contactsName">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>

	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="search_owner" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="search_name" class="form-control" type="text">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input id="customerName" class="form-control" type="text">
				    </div>
				  </div>

				  <br>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select id="stage" class="form-control">
					  	<option></option>
					  	<c:forEach items="${stageList}" var="stage">
							<option value="${stage.id}">${stage.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select id="type" class="form-control">
					  	<option></option>
					  	<c:forEach items="${tranTypeList}" var="type">
							<option value="${type.id}">${type.value}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input id="contactsName" class="form-control" type="text">
				    </div>
				  </div>

				  <button id="queryTranByConditionBtn" type="button" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="saveTranBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editTranBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkedAll"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="tbody">
					</tbody>
				</table>
				<div id="rowsAndPages"></div>
			</div>

		</div>

	</div>
</body>
</html>
