# struts2核心配置文件struts.xml详解
## struts.xml文件示例
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE struts PUBLIC
    "-//Apache Software Foundation//DTD Struts Configuration 2.3//EN"
    "http://struts.apache.org/dtds/struts-2.3.dtd">

<struts>

    <constant name="struts.enable.DynamicMethodInvocation" value="false" />
    <constant name="struts.devMode" value="true" />

    <package name="default" namespace="/" extends="struts-default">

        <default-action-ref name="index" />

        <global-results>
            <result name="error">/WEB-INF/jsp/error.jsp</result>
        </global-results>

        <global-exception-mappings>
            <exception-mapping exception="java.lang.Exception" result="error"/>
        </global-exception-mappings>

        <action name="index">
            <result type="redirectAction">
                <param name="actionName">HelloWorld</param>
                <param name="namespace">/example</param>
            </result>
        </action>
    </package>

    <include file="example.xml"/>

    <!-- Add packages here -->

</struts>
```
## constant
<constant>包含一些属性设置，他可以改变struts框架的一些行为。例如示例中的 struts.enable.DynamicMethodInvocation 设为true，表示设置动态方法调用为真，而 struts.devMode 表示是否启用开发者模式。
## package
在struts中，package用来管理action、result、interceptor、interceptor-stack等配置信息
- name：必须唯一，这样其他package如果引用本package的话，才能找得到。
- extends：当本package继承其他package的时候，会继承父package的所有配置属性（例如action、result等等）；由于package的信息获取是按照struts.xml文件中的先后顺序进行的，因此父package必须在子package之前先定义。通常情况下，继承一个“struts-default.xml”的package，这是 Struts2 默认的package。
namespace：namespace的配置会改变项目的url访问地址，主要是针对比较大型的项目以方便管理action，因为不同namespace中的action可以同名，从而解决action重名的问题。如果没有指定namespace，则默认为“”。
## action
- name：action的名称
- class：action对应的java类
- method：在该class中对应执行Action的函数方法，默认是execute()。
- converter：类型转换器
## result
- name：具体来说，就是根据某个返回结果，指定响应逻辑，默认是success。
- type：返回结果的类型，默认为dispatcher。
## default-action-ref
如果找不到项目请求的action，就会报出404错误，而且这种错误不可避免，所以我们可以使用 default-action-ref 来指定一个默认的action，如果系统出现找不到action的情况，就会来调用这个默认的action。
## global-results
设置package范围内的全局响应结果。在多个action都返回同一个逻辑视图（通常为某个jsp页面）的情况下，可以通过该标签来统一配置。
## global-exception-mapping
配置发生异常时的视图信息。exception-mapping是控制action范围内的，而global-exception-mapp是控制package范围内的。两个都配置时，exception-mapping的优先级更高。
## include
使用include引入外部配置文件，直接给出url即可
```
<include file="**/**/***.xml" />
```
使用 include 的好处在于，例如当我们开发一个比较大型的项目的时候，配置文件肯定会写一大堆。如果写在一个配置文件里就不好查看和修改，不便于维护；所以使用 include 后可以根据模块、也可以根据功能来划分，这样就比较清晰，方便管理和维护。

其他较为常用的还有 <interceptor>拦截器等等。

来源：实验楼 https://www.shiyanlou.com/courses/32/labs/920/document