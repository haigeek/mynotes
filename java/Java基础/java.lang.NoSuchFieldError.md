# jar版本不一致导致的java.lang.NoSuchFieldError

```
java.lang.NoSuchFieldError: RESULT_CODE_SUCCESS
	at com.dist.sso.client.filter.JwtFilter.doFilter(JwtFilter.java:85)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:166)


```



```
if (responseData.getCode() == ResponseData.RESULT_CODE_SUCCESS) {
                        HttpUtil.writeToResponse(response, responseData);
                        return;
                    }
```



```
public static final int RESULT_CODE_SUCCESS = 1000;
```

```
public static final Integer RESULT_CODE_SUCCESS = 1000;
```

![image-20200402180217527](images/image-20200402180217527.png)