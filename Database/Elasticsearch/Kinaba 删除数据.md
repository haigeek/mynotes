打开kinaba 的 dev tools

执行查询

```
GET _search
{
  "query": {
    "match": {
      "ip": "xxx"
    }
  }
}
```

 执行删除

```
POST _all/_delete_by_query
{
  "query": {
    "match": {
      "ip": "xxx"
    }
  }
}
```

 参考链接：https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docs-delete-by-query.html