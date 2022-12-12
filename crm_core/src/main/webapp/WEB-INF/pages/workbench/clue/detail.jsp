<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;

	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});

		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#remarkDetail").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})

		$("#remarkDetail").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})

		$("#remarkDetail").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		})

		$("#remarkDetail").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		});

		//增加备注
		$("#saveRemarkBtn").click(function () {
			var noteContent=$.trim($("#remark").val());
			var clueId="${clue.id}"
			if (noteContent==""){
				alert("内容不能为空");
				return;
			}
			$.ajax({
				url:"workbench/clue/insertClueRemark.do",
				data:{noteContent:noteContent,clueId:clueId},
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.code=="1"){
						$("#remark").val("");
						var str="";
						str+="<div id=\"remark_"+data.retData.id+"\" class=\"remarkDiv\" style=\"height: 60px;\">"
						str+="<img title=\""+data.retData.createBy+"\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">"
						str+="<div style=\"position: relative; top: -40px; left: 40px;\" >"
						str+="<h5>"+data.retData.noteContent+"</h5>"
						str+="<font color=\"gray\">线索</font> <font color=\"gray\">-</font><b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style=\"color: gray;\"> "+data.retData.createTime+" 由${sessionScope.sessionUser.name}创建</small>"
						str+="<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">"
						str+="<a name='editA' clueRemarkId='"+data.retData.id+"' class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						str+="&nbsp;&nbsp;&nbsp;&nbsp;"
						str+="<a name='deleteA' clueRemarkId='"+data.retData.id+"'class=\"myHref\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>"
						str+="</div>"
						str+="</div>"
						str+="</div>"
						$("#remarkDiv").before(str);
					}else {
						alert(data.message);
					}
				}
			});
		});
		//删除备注
		$("#remarkDetail").on("click","a[name=deleteA]",function () {
			var remarkId = $(this).attr("clueRemarkId");
			$.ajax({
				url:"workbench/clue/deleteClueRemarkById.do",
				data:{id:remarkId},
				type:"post",
				dataType: "json",
				success:function (data) {
					if (data.code=="1"){
						$("#remark_"+remarkId).remove();
						$("#remarkDetail").load(location.href+" #remarkDetail>*","");
					}else {alert(data.message)}
				}
			});
		});
		//修改备注的模态窗口没做....

		//打开关联的模态窗口
		$("#addActivityRelation").click(function (){
			$("#queryActivity").val("");
			$("#tBody").html("");
			$("#bundModal").modal("show");
		});
		//全选按钮
		$("#checkedAll").click(function () {
			$("#tBody input[type='checkbox']").prop("checked",this.checked);
		});
		$("#tBody").on("click","input[type='checkbox']",function () {
			if ($("#tBody input[type='checkbox']").size()==$("#tBody input[type='checkbox']:checked").size()){
				$("#checkedAll").prop("checked",true);
			}else {
				$("#checkedAll").prop("checked",false);
			}
		})
		//关联市场活动
		$("#relationBtn").click(function () {
			var checked=$("#tBody input[type='checkbox']:checked");
			if (checked.size()==0){
				alert("请选择至少一项市场活动");
				return;
			};
			var ids="";
			$.each(checked,function (index,dom) {
				ids+="activityId="+dom.value+"&"
			});
			ids += "clueId=${clue.id}";
			$.ajax({
				url:"workbench/clue/saveBund.do",
				data: ids,
				type:"post",
				dataType:"json",
				success:function (data) {
					if (data.code=="1"){
						var str="";
						$.each(data.retData,function (index, activity) {
							str += "<tr id=\"activity_"+activity.id+"\">"
							str += "<td>"+activity.name+"</td>"
							str += "<td>"+activity.startDate+"</td>"
							str += "<td>"+activity.endDate+"</td>"
							str += "<td>"+activity.owner+"</td>"
							str += "<td><a name=\"deleteRelationBtn\" activityId=\""+activity.id+"\" href=\"javascript:void(0);\"  style=\"text-decoration: none;\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>"
							str += "</tr>"
						})
						$("#relation_tbody").append(str);
						$("#bundModal").modal("hide");
					}else {
						alert(data.message);
					}
				}
			});
		});
		$("#queryActivity").keyup(function () {
			var name = this.value;
			var clueId = "${clue.id}";
			$.ajax({
				url:"workbench/clue/queryActivityForDetailByName.do",
				data: {name:name,clueId:clueId},
				type:"post",
				dataType:"json",
				success:function (data) {
					var str = "";
					$.each(data,function (index, obj) {
						str += "<tr>"
						str += "<td><input value=\""+obj.id+"\" type=\"checkbox\"/></td>"
						str += "<td>"+obj.name+"</td>"
						str += "<td>"+obj.startDate+"</td>"
						str += "<td>"+obj.endDate+"</td>"
						str += "<td>"+obj.owner+"</td>"
						str += "</tr>"
					})
					$("#tBody").html(str);
					$("#checkedAll").prop('checked',false);

				}
			})
		});
		//解除关联
		$("#relation_tbody a[name='deleteRelationBtn']").click(function () {
			if (window.confirm("是否确认解除关联？")){
				var activityId = $(this).attr("activityId");
				var clueId = "${clue.id}";
				$.ajax({
					url: "workbench/clue/deleteRelation.do",
					data: {activityId: activityId, clueId: clueId},
					type: "post",
					dataType: "json",
					success: function (data) {
						if (data.code == "1") {
							$("#activity_" + activityId).remove();
						} else {
							alert(data.message)
						}
					}
				})
			}
		});
		//线索转换
		$("#convertClueBtn").click(function () {
			window.location.href='workbench/clue/toConvert.do?id=${clue.id}';
		});
	});
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="queryActivity" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input id="checkedAll" type="checkbox"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button id="relationBtn" type="button" class="btn btn-primary">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>

	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="convertClueBtn"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

		</div>
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${clue.contactSummary}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${clue.address}
				</b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>

	<div id="remarkDetail" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${clueRemarkList}" var="clueRemark">
			<div id="remark_${clueRemark.id}" class="remarkDiv" style="height: 60px;">
				<img title="${clueRemark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${clueRemark.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font><b>${clue.fullname}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${clueRemark.editFlag=="0"?clueRemark.createTime:clueRemark.editTime} 由${clueRemark.editFlag=="0"?clueRemark.createBy:clueRemark.editBy}${clueRemark.editFlag=="0"?"创建":"修改"}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a name='editA' clueRemarkId="${clueRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a name='deleteA' clueRemarkId="${clueRemark.id}" class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<div>
		<div id="relationDetail" style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="relation_tbody">
					<c:forEach items="${activityList}" var="activity">
						<tr id="activity_${activity.id}">
							<td>${activity.name}</td>
							<td>${activity.startDate}</td>
							<td>${activity.endDate}</td>
							<td>${activity.owner}</td>
							<td><a name="deleteRelationBtn" activityId="${activity.id}" href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
			</div>

			<div id="addRelation">
				<a href="javascript:void(0);" id="addActivityRelation" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>


	<div style="height: 200px;"></div>
</body>
</html>
