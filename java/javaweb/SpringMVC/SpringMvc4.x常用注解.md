# SpringMvc4.x常用注解

- controller

Controller控制器是通过服务接口定义的提供访问应用程序的一种行为，他解释用户的输入，将其转换为一个模型然后将视图献给用户，使用@Controller定义控制器，Spring使用扫描机制来找到应用程序中所有基于注解的控制器类，需要在SpringMVC的配置文件声明spring-context如下：

``` xml
<?xml version="1.0" encoding="UTF-8"?><beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="
        http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context.xsd">
    <context:component-scan base-package="org.springframework.samples.petclinic.web"/>
 
    <!-- ... --></beans>
```

- @Autowired

  将依赖注入到SpringMVC最简单的方法是通过注解@Autowired到字段或者方法

- RequestMapping

将@RequestMapping注解类似将/favsoft这样的URL映射到整个类或特定的处理方法上，类级别的注解映射到特定的请求路径到表单控制器上，而方法级别的注解只是映射一个特定的http方法请求或者http请求参数；

```
@Controller
@RequestMapping("/favsoft")
public class AnnotationController {
    @RequestMapping(method=RequestMethod.GET)
    public String get(){
        return "";
    }
    @RequestMapping(value="/getName", method = RequestMethod.GET)
    public String getName(String userName) {
        return userName;
    }
    @RequestMapping(value="/{day}", method=RequestMethod.GET)
    public String getDay(Date day){
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        return df.format(day);
    }
    @RequestMapping(value="/addUser", method=RequestMethod.GET)
    public String addFavUser(@Validated FavUser favUser,BindingResult result){
        if(result.hasErrors()){
            return "favUser";
        }
        //favUserService.addFavUser(favUser);
        return "redirect:/favlist";
    }

    @RequestMapping("/test")
    @ResponseBody
    public String test(){
        return "aa";
    }
}
```

@RequestMapping可以使用@validated与BindingResult联合验证输入的参数，在验证通过和失败的情况下，分别返回不同的视图

@RequestMapping支持使用URI模板访问URL。URI模板像是URL模样的字符串，由一个或多个变量名字组成，当这些变量有值的时候，它就变成了URI

除了在请求路径中使用URI 模板，定义变量之外，@RequestMapping 中还支持通配符“* ”

- pathVariable

使用@pathVariable注解方法参数并将其绑定到URI模版变量的值上，表示该参数的值将使用URI 模板中对应的变量的值来赋值。

```
@Controller
@RequestMapping ( "/test/{variable1}" )
public class MyController {
 
    @RequestMapping ( "/showView/{variable2}" )
    public ModelAndView showView( @PathVariable String variable1, @PathVariable ( "variable2" ) int variable2) {
       ModelAndView modelAndView = new ModelAndView();
       modelAndView.setViewName( "viewName" );
       modelAndView.addObject( " 需要放到 model 中的属性名称 " , " 对应的属性值，它是一个对象 " );
       return modelAndView;
    }
}
```

- RequestParam

@RequestParam将请求的参数绑定到方法中的参数上

```
  @RequestMapping ( "requestParam" )
   public String testRequestParam( @RequestParam(required=false) String name, @RequestParam ( "age" ) int age) {
       return "requestParam" ;
    }
```

- RequestBody

  @RequestBody是指方法参数应该被绑定到HTTP请求Body上。

```
@RequestMapping(value = "/something", method = RequestMethod.PUT)
public void handle(@RequestBody String body, Writer writer) throws IOException {
    writer.write(body);
}
```

- ResponseBody

​    @ResponseBody与@RequestBody类似，它的作用是将返回类型直接输入到HTTP response body中。@ResponseBody在输出JSON格式的数据时，会经常用到

```
@RequestMapping(value = "/something", method = RequestMethod.PUT)
@ResponseBody
public String helloWorld() {    
return "Hello World";
}
```

- RestController

 一些控制器实现了REST的API，只为服务于JSON，XML或其它自定义的类型内容，@RestController用来创建REST类型的控制器，与@Controller类型。@RestController就是这样一种类型，它避免了你重复的写@RequestMapping与@ResponseBody。

```
@RestController
public class FavRestfulController {

	@RequestMapping(value="/getUserName",method=RequestMethod.POST)
	public String getUserName(@RequestParam(value="name") String name){
		return name;
	}
}
```

- HttpEntity

  HttpEntity除了能获得request请求和response响应之外，它还能访问请求和响应头，如下所示

  ```java
  @RequestMapping("/something")
  public ResponseEntity<String> handle(HttpEntity<byte[]> requestEntity) throws UnsupportedEncodingException {
      String requestHeader = requestEntity.getHeaders().getFirst("MyRequestHeader"));    byte[] requestBody = requestEntity.getBody();    // do something with request header and body
      HttpHeaders responseHeaders = new HttpHeaders();
      responseHeaders.set("MyResponseHeader", "MyValue");    
    return new ResponseEntity<String>("Hello World", responseHeaders, HttpStatus.CREATED);
  }
  ```

- @ModelAttribute与@SessionAttributes

  SpringMVC 支持使用 @ModelAttribute 和 @SessionAttributes 在不同的模型和控制器之间共享数据。 

  @ModelAttribute 主要有两种使用方式，一种是标注在方法上，一种是标注在 Controller 方法参数上。

  当 @ModelAttribute 标记在方法上的时候，该方法将在处理器方法执行之前执行，然后把返回的对象存放在 session 或模型属性中，属性名称可以使用 @ModelAttribute(“attributeName”) 在标记方法的时候指定，若未指定，则使用返回类型的类名称（首字母小写）作为属性名称。关于 @ModelAttribute 标记在方法上时对应的属性是存放在 session 中还是存放在模型中，我们来做一个实验，看下面一段代码。