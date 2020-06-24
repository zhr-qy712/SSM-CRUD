<%--
  Created by IntelliJ IDEA.
  User: 84448
  Date: 2020-06-18
  Time: 11:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <%-- web路径
    APP_PATH对应的值是request.getContextPath(),存的是服务器路径,这种路径找资源的方式不容易出错
    服务器路径:http://localhost:3306/crud
    --%>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<%--员工修改的模态框--%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名</label>
                        <div class="col-sm-4">
                            <%--                            部门提交部门id就行，部门是要从数据库里查出来的--%>
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>
<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工姓名</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="emp">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">员工邮箱</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@163.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">性别</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">部门名</label>
                        <div class="col-sm-4">
<%--                            部门提交部门id就行，部门是要从数据库里查出来的--%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>
<%--    搭建显示页面--%>
<div class="container">
    <%--标题SSM-CRUD--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-3 col-md-offset-9">
            <button class="btn btn-primary" id="emp_add_model_btn">新增</button>
            <button class="btn btn-danger" id="emp_del_all_btn">删除</button>
        </div>
    </div>
    <%--            显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all"/>
                        </th>
                        <th>ID</th>
                        <th>员工姓名</th>
                        <th>性别</th>
                        <th>邮箱</th>
                        <th>部门名</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--            显示分页信息--%>
    <div class="row">
        <%--            分页文字信息--%>
        <div class="col-md-6" id="page_info_area">

        </div>
        <%--            分页条信息--%>
        <div class="col-md-6" id="page_nav_area">

        </div>
    </div>
</div>
<script type="text/javascript">
<%--    定义一个全局总记录变量，之后跳转最后一页的时候用--%>
    var totalRecord;
//      定义一个全局当前页的变量，之后做更新操作完毕后跳转到当前页会用
    var currentPage;
//1.页面加载完成以后，直接去发送一个ajax请求，要到分页数据
    $(function () {
        //去首页
        to_page(1);
    });
    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"get",
            success:function (result) {
                //    console.log(result);
                //    成功之后我们需要做的
                //    1.解析并显示员工数据
                build_emps_table(result);
                //    2.解析并显示分页信息
                build_page_info(result);
                //    3.解析并显示分页条
                build_page_nav(result);
            }
        });
    }
    function build_emps_table(result) {
        //每次构造之前先清空，要不然查找下一页数据的时候，会接着添加数据，就不能保证一页五条数据了
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            //为编辑按钮添加一个自定义的属性，来表示当前员工的id
            editBtn.attr("edit-id",item.empId)
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            //为删除按钮添加一个自定义的属性，来表示当前员工的id
            delBtn.attr("del-id",item.empId)
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }
    function build_page_info(result) {
        //清空，原因同上
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总共"+result.extend.pageInfo.pages+"页，总共"+result.extend.pageInfo.total+"条记录");
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
    }
    //解析显示分页条，点击分页要能去下一页...
    function build_page_nav(result) {
        //清空，原因同上
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            firstPageLi.click(function () {
                to_page(1);
            })
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            })
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            })
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            })
        }

        //添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //item是页码号,例如1,2,3,4,5
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            })
            ul.append(numLi);
        })
    //    添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把ul添加到nav中
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
    //清空表单样式及内容
    function reset_form(ele){
        //清空表单数据
        $(ele)[0].reset("(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)");
    //    清空表单样式
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }
    //点击新增按钮弹出模态框
    $("#emp_add_model_btn").click(function () {
        //清除表单数据（表单重置，包括表单数据和样式）
        reset_form("#empAddModal form");
        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#dept_add_select");
        //弹出模态框
        $("#empAddModal").modal({
            backdrop:'static'
        })
    })
    //查出所有的部门信息并显示在下拉列表中
    function getDepts(ele) {
        $(ele).empty();
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"get",
            success:function (result) {
                // console.log(result)
                // {"code":100,"msg":"处理成功！","extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
            //    显示部门信息在下拉列表中
            //     $("#c").append(" ")
                $.each(result.extend.depts,function () {
                    //this指当前遍历的数组的一个元素（一个{}里的）
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo(ele);
                })
            }
        })
    }
//    校验表单数据
    function validate_add_form(){
        // 1.拿到表单数据，使用正则表达式（jquery文档里有常用的正则表达式）
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/
        if(!(regName.test(empName))){
            // alert("姓名可以是2-5位中文或者6-16位英文数字的组合");
            show_validate_msg("#empName_add_input","error","姓名可以是2-5位中文或者6-16位英文数字的组合");
            return false;
        }else {
            show_validate_msg("#empName_add_input","success","");
        }
        //校验邮箱信息
        var empEmail = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!(regEmail.test(empEmail))){
            // alert("邮箱格式不正确");
            show_validate_msg("#email_add_input","error","邮箱格式不正确");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
        }
        return true;
    }
    //把成功和错误信息提示提取出一个函数，否则再次输入时class方法会在上次输入的基础上接着添加
    function show_validate_msg(ele,status,msg){
        //把父元素的addclass清空
        $(ele).parent().removeClass("has-success has-error");
        if(status=="success"){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if (status=="error"){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }
//    检验用户名是否可用
    $("#empName_add_input").change(function () {
        var empName = this.value;
    //    发送ajax请求检验用户名是否可用
        $.ajax({
            url:"${APP_PATH}/checkuser",
            type:"get",
            data:"empName="+empName,
            success:function (result) {
                if(result.code==100){
                    show_validate_msg("#empName_add_input","success","用户名可用")
                    $("#emp_save_btn").attr("ajax-va","success")
                }else {
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg)
                    $("#emp_save_btn").attr("ajax-va","error")
                }
            }
        })
    })
//    模态框中的员工数据提交给服务器进行保存
    $("#emp_save_btn").click(function () {
        //1.先要对提交给服务器的数据进行前端校验
        if(!validate_add_form()){
            return false;
        }
        //判断之前的ajax用户名校验是否成功。如果成功
        if($(this).attr("ajax-va")=="error"){
            return false;
        }
        //该模态框id值为empAddModal，由于里面只有一个form表单，所以可以这样提取#empAddModal form或者给form表单添加一个id值直接调用也可
        //↓serialize();为jquery里的方法，可以把表单中的数据序列化为字符串
        //alert($("#empAddModal form").serialize());例子测试结果:empName=aaa&email=aaa%40163.com&gender=M&dId=1
        $("#empAddModal form").serialize()
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data:$("#empAddModal form").serialize(),
            success:function (result) {
                // alert(result.msg);
                if(result.code==100){
                    // 员工保存成功之后
                    // 1.关闭模态框
                    $("#empAddModal").modal('hide');
                    // 2.来到最后一页，显示刚才保存的数据
                    // 发送ajax请求显示最后一页数据即可
                    //分页插件规定了如果页码比总页码大，那么总查最后一页数据，总记录数肯定比总页数大，从而来跳转到最后一页
                    to_page(totalRecord);
                }else {
                //    显示失败信息
                //     console.log(result);
                //    undefined表示该输入没问题
                    if(undefined!=result.extend.errorFields.email){
                    //    显示邮箱错误信息
                        show_validate_msg("#email_add_input","error",result.extend.errorFields.email)
                    }
                    if(undefined!=result.extend.errorFields.empName){
                    //    显示姓名错误信息
                        show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName)
                    }
                }

            }

        })
    })
//    为编辑按钮添加点击事件，由于我们时按钮创建之前就绑定了click时间，所以直接绑是不成功的
//    解决方法：可以用live方法来解决，但是新版jquery没有live，所以我们使用on来进行替代
//    故，这样写
    $(document).on("click",".edit_btn",function () {
        // alert("edit");
        //    1.查出部门信息，并显示部门列表
        getDepts("#dept_update_select")
        //    2.查出员工信息，显示员工信息
        getEmp($(this).attr("edit-id"));
        //把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"))
        $("#empUpdateModal").modal({
            backdrop:'static'
        })
    })
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function (result) {
                // console.log(result)
                var empData = result.extend.emp
                $("#empName_update_static").text(empData.empName)
                $("#email_update_input").val(empData.email)
                $("#empUpdateModal input[name=gender]").val([empData.gender])
                $("#empUpdateModal select").val([empData.dId])
            }
        })
    }
//    点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
    //     校验邮箱信息
        var empEmail = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if(!(regEmail.test(empEmail))){
            show_validate_msg("#email_update_input","error","邮箱格式不正确");
            return false;
        }else {
            show_validate_msg("#email_update_input","success","");
        }
    //     发送ajax请求保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            success:function (result) {
                // alert(result.msg)
            //    1.关闭模态框
                $("#empUpdateModal").modal("hide")
            //    2.回到本页面
                to_page(currentPage)
            }
        })
    })
    //单个删除
    $(document).on("click",".delete_btn",function () {
    //    1.弹出是否删除对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del-id");
        if (confirm("确认删除【"+empName+"】吗？")){
        //    确认，发送ajax请求即可
            $.ajax({
                url:"${APP_PATH}/emp/"+empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg)
                    to_page(currentPage)
                }
            })
        }
    })
    $("#check_all").click(function () {
        $(".check_item").prop("checked",$(this).prop("checked"))
    })
    $(document).on("click",".check_item",function () {
    //    判断当前选择中的元素是不是5个
        var flag = $(".check_item:checked").length==$(".check_item").length
        $("#check_all").prop("checked",flag)
    })
//    点击全部删除，就批量删除
    $("#emp_del_all_btn").click(function () {
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"),function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text()+","
        //    组装员工id字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-"
        })
        //去掉empNames最后多余的逗号，进行字符串截取
        empNames = empNames.substring(0,empNames.length-1)
        //去掉empNames最后多余的-，进行字符串截取
        del_idstr = del_idstr.substring(0,del_idstr.length-1)
        if(confirm("确认删除【"+empNames+"】吗？")){
        //    发ajax请求删除
            $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg)
                //    回到当前页面
                    to_page(currentPage)
                }
            })
        }
    })
</script>
</body>
</html>
