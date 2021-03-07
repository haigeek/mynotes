# Dubbo-参数验证

## 介绍

Dubbo中的参数验证基于JSR-303，它是JAVA EE 6中的一项子规范，通过注解的方式用来对 Java Bean中字段的值进行简单验证。Consumer端要调用Provider端的接口，调用接口的话就会有参数用于传递数据，这里的验证指的就是对这个参数进行验证

这个JSR基于注释的JavaBeanTM验证定义一个元数据模型和API，通过使用XML验证描述符覆盖和扩展元数据。

## 准备

```
<dependency>
    <groupId>javax.validation</groupId>
    <artifactId>validation-api</artifactId>
    <version>1.0.0.GA</version>
</dependency>
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-validator</artifactId>
    <version>4.2.0.Final</version>
</dependency>
```



### 代码示例

------

1. 参数验证主要在实体类和接口上进行设置

   ```
   package com.dist.entity;
   
   import java.io.Serializable;
   import java.util.Date;
   
   import javax.validation.constraints.Future;
   import javax.validation.constraints.Max;
   import javax.validation.constraints.Min;
   import javax.validation.constraints.NotNull;
   import javax.validation.constraints.Past;
   import javax.validation.constraints.Pattern;
   import javax.validation.constraints.Size;
   
   /**
    * demo
    * @author changzhi
    *
    */
   public class ValidationParameter implements Serializable {
   
       private static final long serialVersionUID = 1119411448459221069L;
   
       @NotNull // 不允许为空
       @Size(min = 2, max = 10) // 长度或大小范围
       private String name;
   
   	@NotNull(groups = ValidationService.Save.class) // 保存时不允许为空，更新时允许为空 ，表示不更新该字段 （此处配合分组验证一起使用）
       @Pattern(regexp = "^\\s*\\w+(?:\\.{0,1}[\\w-]+)*@[a-zA-Z0-9]+(?:[-.][a-zA-Z0-9]+)*\\.[a-zA-Z]+\\s*$")
       private String email;
   
       @Min(18) // 最小值
       @Max(30) // 最大值
       private int age;
   
       @Past // 必须为一个过去的时间
       private Date loginDate;
   
       @Future // 必须为一个未来的时间
       private Date expiryDate;
   
       public String getName() {
           return name;
       }
   
       public void setName(String name) {
           this.name = name;
       }
   
       public String getEmail() {
           return email;
       }
   
       public void setEmail(String email) {
           this.email = email;
       }
   
       public int getAge() {
           return age;
       }
   
       public void setAge(int age) {
           this.age = age;
       }
   
       public Date getLoginDate() {
           return loginDate;
       }
   
       public void setLoginDate(Date loginDate) {
           this.loginDate = loginDate;
       }
   
       public Date getExpiryDate() {
           return expiryDate;
       }
   
       public void setExpiryDate(Date expiryDate) {
           this.expiryDate = expiryDate;
       }
   
       @Override
       public String toString() {
           return "ValidationParameter [name=" + name + ", email=" + email
                   + ", age=" + age + ", loginDate=" + loginDate + ", expiryDate="
                   + expiryDate + "]";
       }
   
   
   }
   ```

2. 接口

   ```java
   package com.dist;
   
   import com.dist.entity.ValidationParameter;
   
   import javax.validation.GroupSequence;
   import javax.validation.constraints.Min;
   import javax.validation.constraints.NotNull;
   import javax.validation.constraints.Pattern;
   import javax.validation.constraints.Size;
   
   /**
    * service
    * @author changzhi
    *
    */
   public interface ValidationService {
   
   
       void save(ValidationParameter parameter);
   
       void update(ValidationParameter parameter);
   
       void delete(
               @Min(value=1,message="id must bigger than 1") long id,
               @NotNull @Size(min = 2, max = 16) @Pattern(regexp = "^[a-zA-Z]+$") String operator);
       
   }
   ```

3. 测试

   ```
   public static void saveErrorAge() {
           ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext(
                   "META-INF/spring/spring-common.xml");
           context.start();
           try {
               ValidationService validationService = (ValidationService) context
                       .getBean("validationService");
               ValidationParameter parameter = new ValidationParameter();
               parameter.setName("qxn");  //not null
               parameter.setEmail("192404@qq.com"); //email格式正确
               parameter.setAge(99);  //error [18,100]
               parameter.setLoginDate(new Date(System.currentTimeMillis() - 1000000)); //时间必须是过去的时间
               parameter.setExpiryDate(new Date(System.currentTimeMillis() + 1000000));//时间必须是未来的时间
               validationService.save(parameter); //save
               System.out.println("Validation Save OK");
           } catch (Exception e) {
               ConstraintViolationException ve = (ConstraintViolationException) e.getCause(); // 里面嵌了一个ConstraintViolationException
               Set<ConstraintViolation<?>> violations = ve.getConstraintViolations(); // 可以拿到一个验证错误详细信息的集合
               System.out.println(violations);
           } finally {
               context.close();
           }
   ```

4. 结果

   ```
   [ConstraintViolationImpl{interpolatedMessage='最大不能超过30', propertyPath=age, rootBeanClass=class com.dist.entity.ValidationParameter, messageTemplate='{javax.validation.constraints.Max.message}'}]
   ```

   

![1564474103249](C:\Users\chang\AppData\Roaming\Typora\typora-user-images\1564474103249.png)

5. 除此之外，参数验证可以指定某个方法进行验证，而不是全部验证了。应用场景：比如说保存的时候，年龄只能在18-30岁之间，但修改的时候不需要这个筛选条件，这个可以通过**分组验证**来实现，用于区分验证场景。

```
package com.dist;

import com.dist.entity.ValidationParameter;

import javax.validation.GroupSequence;
import javax.validation.constraints.*；

public interface ValidationService {

    @interface Save{} // 与方法同名接口，首字母大写，用于区分验证场景
    void save(ValidationParameter parameter);

    void update(ValidationParameter parameter);

}
```

6. 然后是关联验证，应用场景不多，它的意思是 假设我的保存和修改是两种不同的验证机制。但是保存的时候需要全部进行验证，而修改的时候只需要验证特定部分机制即可，举个例子：年龄字段，保存的时候不能为空并且在18-30岁之间，而更新的时候只要不为空即可。这块可以这么实现，这个非空验证注解单独用于update，年龄范围的注解单独用于save。那么在调用的保存的时候，就需要把修改的验证机制关联上去，代表验证完save机制在去验证update机制。而修改的时候只需要验证自身的update机制 即可。

   ```
   import javax.validation.GroupSequence;
    
   public interface ValidationService {   
       @GroupSequence(Update.class) // 同时验证Update组规则
       @interface Save{}
       void save(ValidationParameter parameter);
    
       @interface Update{} 
       void update(ValidationParameter parameter);
   }
   ```

7. 配置文件，需要设置 validation="true"

   ```
   <dubbo:service interface="com.dist.ValidationService" ref="validationServiceImpl"
                      validation="true" version="dgpdemo"/>
   ```

   

### 总结

------

优点

1. 任何场景都能用到
