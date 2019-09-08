<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
    // 出入库记录查询参数
    search_type = 'all'
    search_repositoryID = ''
    search_pcID = ''
    search_pcType = '0'
    search_start_date = null
    search_end_date = null

    $(function(){
        optionAction();
        repositoryOptionInit();
        datePickerInit();
        storageListInit();
        searchAction();
    })

    // 仓库下拉框数据初始化
	function repositoryOptionInit(){
		$.ajax({
			type : 'GET',
			url : 'repositoryManage/getRepositoryList',
			dataType : 'json',
			contentType : 'application/json',
			data:{
				searchType : "searchAll",
				keyWord : "",
				offset : -1,
				limit : -1
			},
			success : function(response){
				$.each(response.rows,function(index,elem){
					$('#search_repository_ID').append("<option value='" + elem.id + "'>" + elem.id +"号仓库</option>");
				})
			},
			error : function(response){
				// do nothing 
			}
		});
	}

	// 日期选择器初始化
	function datePickerInit(){
		$('.form_date').datetimepicker({
			format:'yyyy-mm-dd',
			language : 'zh-CN',
			endDate : new Date(),
			weekStart : 1,
			todayBtn : 1,
			autoClose : 1,
			todayHighlight : 1,
			startView : 2,
			forceParse : 0,
			minView:2
		});
	}

	// 表格初始化
	function storageListInit() {
		$('#stockRecords')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'recordID',
										title : '记录ID'
									//sortable: true
									},
									{
										field : 'supplierOrCustomerName',
										title : '供应商/客户名称'
									},
									{
										field : 'goodsName',
										title : '商品名称'
									},
									{
										field : 'repositoryID',
										title : '出/入库仓库ID',
										//visible : false
									},
									{
										field : 'number',
										title : '数量',
										//visible : false
									},
									{
										field : 'time',
										title : '日期'
									},
									{
										field : 'personInCharge',
										title : '经手人'
									},
									{
										field : 'type',
										title : '记录类型'
									}
									<!--,-->
									<!--{-->
										<!--field : 'operation',-->
										<!--title : '操作',-->
										<!--formatter : function(value, row, index) {-->
											<!--var s = '<button class="btn btn-info btn-sm edit"><span>编辑</span></button>';-->
											<!--var d = '<button class="btn btn-danger btn-sm delete"><span>删除</span></button>';-->
											<!--var fun = '';-->
											<!--return s + ' ' + d;-->
										<!--},-->
										<!--events : {-->
											<!--// 操作列中编辑按钮的动作-->
											<!--'click .edit' : function(e, value,-->
													<!--row, index) {-->
												<!--//selectID = row.id;-->
												<!--rowEditOperation(row);-->
											<!--},-->
											<!--'click .delete' : function(e,-->
													<!--value, row, index) {-->
												<!--select_goodsID = row.goodsID;-->
												<!--select_repositoryID = row.repositoryID-->
												<!--$('#deleteWarning_modal').modal(-->
														<!--'show');-->
											<!--}-->
										<!--}-->
									<!--}-->
									 ],
							url : 'stockRecordManage/searchStockRecord',
							onLoadError:function(status){
								handleAjaxError(status);
							},
							method : 'GET',
							queryParams : queryParams,
							sidePagination : "server",
							dataType : 'json',
							pagination : true,
							pageNumber : 1,
							pageSize : 5,
							pageList : [ 5, 10, 25, 50, 100 ],
							clickToSelect : true
						});
	}

	// 表格刷新
	function tableRefresh() {
		$('#stockRecords').bootstrapTable('refresh', {
			query : {}
		});
	}

    // 下拉框選擇動作
    function optionAction() {
        $(".dropOption").click(function() {
            var type = $(this).text();
            $("#search_input").val("");
            if (type == "全部查询") {
                $("#search_input_type").attr("readOnly", "true");
                search_pcType = "0";
            } else if (type == "供应商") {
                $("#search_input_type").removeAttr("readOnly");
                search_pcType = "1";
            }else if (type == "客户") {
                $("#search_input_type").removeAttr("readOnly");
                search_pcType = "2";
            }else if (type == "商品名称") {
                $("#search_input_type").removeAttr("readOnly");
                search_pcType = "3";
            }
            $("#search_type1").text(type);
            $("#search_input_type").attr("placeholder", type);
        })
    }

	// 分页查询参数
	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type,
			repositoryID : search_repositoryID,
            pcType : search_pcType,
            pcID : search_pcID,
			startDate : search_start_date,
			endDate : search_end_date
		}
		return temp;
	}

	// 查询操作
	function searchAction(){
	    $('#search_button').click(function(){
	        search_repositoryID = $('#search_repository_ID').val();
	        search_type = $('#search_type').val();
            search_pcID = $('#search_input_type').val();
	        search_start_date = $('#search_start_date').val();
	        search_end_date = $('#search_end_date').val();
            var type = "error";
            var msg;
            var append = '';
            if ("1" == search_pcType && search_pcID.match(/^[ ]*$/)){
                msg = "请输入供应商信息！";
                showMsg(type, msg, append);
                return;
            }else if ("2" == search_pcType && search_pcID.match(/^[ ]*$/)){
                msg = "请输入客户信息！";
                showMsg(type, msg, append);
                return;
            }else if ("3" == search_pcType && search_pcID.match(/^[ ]*$/)){
                msg = "请输入商品名称！";
                showMsg(type, msg, append);
                return;
            }
	        tableRefresh();
	    })
	}
</script>

<div class="panel panel-default">
    <ol class="breadcrumb">
        <li>业务流水</li>
    </ol>
    <div class="panel-body">
        <div class="row">
            <div class="col-md-1  col-sm-2">
                <div class="btn-group">
                    <button class="btn btn-default dropdown-toggle"
                            data-toggle="dropdown">
                        <span id="search_type1">查询方式</span> <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="javascript:void(0)" class="dropOption">全部查询</a></li>
                        <li><a href="javascript:void(0)" class="dropOption">供应商</a></li>
                        <li><a href="javascript:void(0)" class="dropOption">客户</a></li>
                        <li><a href="javascript:void(0)" class="dropOption">商品名称</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-md-4  col-sm-1">
                <div class="col-md-6 col-sm-6">
                    <input id="search_input_type" type="text" class="form-control"
                           placeholder="全部查询" readOnly="true">
                </div>
                <form action="" class="form-inline">
                    <div class="form-group">
                        <select class="form-control" id="search_repository_ID">
                            <option value="">所有仓库</option>
                        </select>
                    </div>
                </form>
            </div>
                <div class="col-md-3">
                    <select name="" id="search_type" class="form-control">
                        <option value="all">显示所有</option>
                        <option value="stockInOnly">仅显示入库记录</option>
                        <option value="stockOutOnly">仅显示出库记录</option>
                    </select>
                    <%--<form action="" class="form-inline">
                    </form>--%>
                </div>
            <div class="col-md-2">
                <button class="btn btn-success" id="search_button">
                    <span class="glyphicon glyphicon-search"></span> <span>查询</span>
                </button>
            </div>
        </div>
        <div class="row" style="margin-top:20px">
            <div class="col-md-6">
                <form action="" class="form-inline">
                    <label class="form-label">日期范围：</label>
                    <input class="form_date form-control" value="" id="search_start_date" name="" placeholder="开始日期">
                    <label class="form-label">&nbsp;&nbsp;-&nbsp;&nbsp;</label>
                    <input class="form_date form-control" value="" id="search_end_date" name="" placeholder="结束日期">
                </form>
            </div>
        </div>
        <div class="row" style="margin-top:50px">
            <div class="col-md-12">
                <table id="stockRecords" class="table table-striped"></table>
            </div>
        </div>
    </div>
</div>