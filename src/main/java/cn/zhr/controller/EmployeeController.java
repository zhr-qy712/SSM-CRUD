package cn.zhr.controller;


import cn.zhr.bean.Employee;
import cn.zhr.bean.Msg;
import cn.zhr.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.nio.channels.Pipe;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/*
* 处理员工CRUD请求
* */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;


    /*单个批量二合一删除
    批量删除：1-2-3（ids）
    单个删除：1（id）
    * */
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("ids")String ids){
        if (ids.contains("-")){
//            批量删除
            ArrayList<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
//            组装id的集合
            for(String string:str_ids){
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deleteBatch(del_ids);
        }else {
//            单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    /*
    * 保存更新的员工
    * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
    * 要在web.xml中配置上HttpPutFormContentFilter（将请求体中的数据解析包装成一个map，request.getParameter()被重写
    * ，就会从自己封装的map中取数据）
    * */
//    因为empId是要封装到emploee里的，所以不能用id，要用emplee里的字段名empId
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee){
        employeeService.updateEmp(employee);
        return Msg.success();
    }
    /*
    * 根据id查询员工数据
    * */
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id")Integer id){
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }
/*
* 检验用户名是否可用
* */
    @RequestMapping("/checkuser")
    @ResponseBody
    public Msg checkuser(@RequestParam("empName") String empName){
//        先判断用户名是否是合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)";
        if (!(empName.matches(regx))){
            return Msg.fail().add("va_msg","用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }
        boolean b = employeeService.checkUser(empName);
        if(b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }
    /*
    * @ResponseBody该注释要能正常工作要导入jackson包
    * */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn){
//        引入Pagehelper分页插件
//        在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
//        startPage后面紧跟的这个查询j就是一个分页查询
        List<Employee> emps = employeeService.getAll();
//        使用pageinfo包装查询后的结果，只需要将pageinfo交给页面就行了（每页下面显示的页数信息等，都包含在pageinfo中）
//        封装了详细的分页信息,包括有我们查询出来的数据,5是下面连续显示的页数
        PageInfo page = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }
    /*
    * 查询员工数据(分页查询)
    * */
    //@RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn, Model model){
//        引入Pagehelper分页插件
//        在查询之前只需要调用，传入页码，以及每页的大小
        PageHelper.startPage(pn,5);
//        startPage后面紧跟的这个查询j就是一个分页查询
        List<Employee> emps = employeeService.getAll();
//        使用pageinfo包装查询后的结果，只需要将pageinfo交给页面就行了（每页下面显示的页数信息等，都包含在pageinfo中）
//        封装了详细的分页信息,包括有我们查询出来的数据,5是下面连续显示的页数
        PageInfo page = new PageInfo(emps,5);
        model.addAttribute("pageInfo",page);
        return "list";
    }
    /*
     * 由于是rest风格的uri，我们可以规定
     * /emp/{id} GET 查询员工
     * /emp      POST 保存员工
     * /emp/{id} PUT 修改员工
     * /emp/{id} DELETE 删除员工*/
//    员工保存
    /*
    * 1.支持JSR303校验
    * 2.导入Hibernate-Validator(去maven中央仓库导入坐标)
    * */
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if(result.hasErrors()){
//            校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<Object, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors){
                System.out.println("错误的字段名："+fieldError.getField());
                System.out.println("错误信息:"+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else{
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }
}
