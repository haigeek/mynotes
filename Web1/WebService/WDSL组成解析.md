# webservice之WSDL组成解析
## types
types指定了这个webservice使用了哪些类型
## message
message指明一个操作所用到的数据类型
例如：
```xml
<wsdl:message name="downloadMaterialResponse">
<wsdl:part name="return" type="xsd:string"> </wsdl:part>
</wsdl:message>
<wsdl:message name="downloadArchiveResponse">
<wsdl:part name="return" type="xsd:string"> </wsdl:part>
</wsdl:message>
```
downloadMaterialResponse和downloadArchiveResponse就是两个操作的数据类型，他们对于的子元素：
<wsdl:part name="return" type="xsd:string"> </wsdl:part>
指明了具体的类型
## portType
指出这个webservice支持哪些操作，哪些操作可以调用，例如：
```xml
<wsdl:portType name="PlanningMaterialWebService">
<wsdl:operation name="getAttachmentsByKeyword">
<wsdl:input message="tns:getAttachmentsByKeyword" name="getAttachmentsByKeyword"> </wsdl:input>
<wsdl:output message="tns:getAttachmentsByKeywordResponse" name="getAttachmentsByKeywordResponse"> </wsdl:output>
</wsdl:operation>
</wsdl:portType>
```
里面配置了相关的输入和输出
## binding
soap:binding元素的transport指明传输协议，这里是rpc协议。
operation 指明要暴露给外界调用的操作。
use属性指定输入输出的编码方式。
```xml
<wsdl:binding name="PlanningMaterialWebServiceServiceSoapBinding" type="tns:PlanningMaterialWebService">
<soap:binding style="rpc" transport="http://schemas.xmlsoap.org/soap/http"/>
<wsdl:operation name="getAttachmentsByKeyword">
<soap:operation soapAction="" style="rpc"/>
<wsdl:input name="getAttachmentsByKeyword">
<soap:body namespace="http://www.dist.com.cn/dap" use="literal"/>
</wsdl:input>
<wsdl:output name="getAttachmentsByKeywordResponse">
<soap:body namespace="http://www.dist.com.cn/dap" use="literal"/>
</wsdl:output>
</wsdl:operation>
</wsdl:binding>
```
service
主要是指定服务的一些信息，主要是指定服务的路径，例如：
```xml
<wsdl:service name="PlanningMaterialWebServiceService">
<wsdl:port binding="tns:PlanningMaterialWebServiceServiceSoapBinding" name="PlanningMaterialWebServicePort">
<soap:address location="http://192.168.1.188:8082/DapService/ws/PlanningMaterialWebService"/>
</wsdl:port>
</wsdl:service>
```

service 对应服务名称
portbinding 对应站点的名称