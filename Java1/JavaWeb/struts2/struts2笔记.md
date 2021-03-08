# struts笔记一
## action的访问
- 使用method方法
- 使用通配符实现
1. 在action标签里面name属性，name属性值写符号 * ，表示匹配任何内容
- 动态访问
## 结果页面配置
### 全局结果页面
1. 如果多个action，方法里面返回相同值的时候，可以使用全局结果界面配置
### 局部结果页面配置
1. 当存在全局结果页面配置时，依旧以局部结果页面配置为准
### result便签的type属性
1. type属性：如何到路径里
2. type属性值：
    - 默认值：转发操作，值是dispatcher
    - 重定向：redirect
    - chain：转发到action
    - redirectAction：重定向到action
## Action获取表单提交数据
### 获取表单提交数据的三种主要方式
#### 使用ActionContext
Map<String,Object>getParameters() 返回一个包含所有HttpServletRequest参数信息
1. 因为方法不是静态的方法，需要创建ActionContext类的对象
2. ActionContext对象不是new出来的 static ActionContext getContext() 获取当前线程的ActionContext对象
3. 实例
```java
	public String execute() throws Exception {
		//第一种方式：使用ActionContext类获取
		//获取ActionContext对象
		ActionContext context=ActionContext.getContext();
		//调用方法得到表单数据
		Map<String, Object> map = context.getParameters();
		Set<String> keys=map.keySet();
		//根据key得到vaule，使用数组形式是因为输入项可能有复选框
		for(String key:keys){
			Object[] obj=(Object[]) map.get(key);
			System.out.println(Arrays.toString(obj));
		}
		return NONE;
	}
```
#### 使用ServletActionContext类
```java
public String execute() throws Exception {
		//使用ServletActionContext获取request对象
		HttpServletRequest request=ServletActionContext.getRequest();
		//调用request里面的方法得到结果
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		String address=request.getParameter("address");
		System.out.println(username+" "+password+" "+address);
		return NONE;
	}
```
#### 使用接口注入方式
### 在action操作域对象
```java
        //操作三个域对象
		//1.request域
		HttpServletRequest request=ServletActionContext.getRequest();
		request.setAttribute("req","reqvalue" );
		//2.session域
		HttpSession session=request.getSession();
		session.setAttribute("sess", "sessValue");
		//3ServletContext域
		ServletContext context=ServletActionContext.getServletContext();
		context.setAttribute("contextname", "contextValue");
```
## struts2提供获取表单数据方式
### 原始方式获取表单封装到实体类对象
```java
public String execute() throws Exception {
		HttpServletRequest request=ServletActionContext.getRequest();
		String username=request.getParameter("username");
		String password=request.getParameter("password");
		String address=request.getParameter("address");
		//封装到实体类
		User user=new User();
		user.setUsername(username);
		user.setPassword(password);
		user.setAddress(address);
		System.out.println(user);
		return NONE;
	}
```
### 属性封装
1. 直接把表单提交属性封装到action属性中
2. 实现步骤
    1. 在action成员变量位置定义变量，变量名称和表单输入项的name属性值一样
    2. 生成变量的get和set方法
3. 使用属性封装获取表单数据到属性里面，不能直接把数据封装到实体类对象里面
### 模型驱动封装
1. 可以直接把表单数据封装到实体类对象
2. 实现步骤
    1. action实现接口ModelDriven
    2. 实现接口里面的方法getModel方法
    3. 在action里面创建实体类对象
    4. 实例
        ```java
        public class DataDemo2Action extends ActionSupport implements ModelDriven<User>{
        //创建对象
        private User user=new User();
        public User getModel() {
            // 返回创建的对象
            return user;
        }
        public String execute() throws Exception {
            
            return NONE;
        }
    }
    ```
### 表达式封装
## 封装数据到集合
### 封装数据到list集合
1. 在action声明List
2. 生成list变量的get和set方法
3. 在表单输入项写表达式
### 封装数据到map集合
1. 在action声明map集合
2. 生成list变量的get和set方法
3. 在表单输入项写表达式
