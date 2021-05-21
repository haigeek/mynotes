### 参数传递

问题：在一个流水线，希望步骤2可以使用步骤1获取到的环境变量

实现方式如下：

```
stage ('Compile') {
            steps {
                script {
                    env.version='latest'
                    env.version =  sh script: 'mvn help:evaluate -Dexpression=project.version -q -DforceStdout', returnStdout: true
                }
                echo "project version is '${version}'"
            }
        }
stage("build"){
            echo "project version is '${version}'"
        }
```

[参考stackoverflow的一个回答](https://stackoverflow.com/questions/53541489/updating-environment-global-variable-in-jenkins-pipeline-from-the-stage-level)

> You can't override the environment variable defined in the `environment {}` block. However, there is one trick you might want to use. You can refer to `ACC` environment variable in two ways:
>
> - explicitly by `env.ACC`
> - implicitly by `ACC`
>
> The value of `env.ACC` cannot be changed once set inside `environment {}` block, but `ACC` behaves in the following way: when the variable `ACC` is not set then the value of `env.ACC` gets accessed (if exists of course). But when `ACC` variable gets initialized in any stage, `ACC` refers to this newly set value in any stage. Consider the following example:

大意是：

如果使用`environment {}`来定义的变量，不管怎么修改都不能被改变，但是使用env.xxx的形式来定义话，xxx在任意一个阶段被初始化之后，在下一个阶段都可以被使用

### 跳过阶段

当一个阶段失败，希望直接跳到另外一个阶段

```
warnError('Script failed!') {
  sh('false')
}
```

例如清理多个机器的none镜像

```
pipeline {
    agent any
    stages {
        stage ('clean') {
            steps {
                warnError('Script failed!') {
                sh '''
                  docker rmi $(docker images | grep "none" | awk '{print $3}') 
                ''' 
                    }
                }
            }
        stage ('clean xxx') {
             agent {
            node {label "xxx"}
                }
            steps {
                sh '''
                  docker rmi $(docker images | grep "none" | awk '{print $3}') 
                ''' 
            }
        }
    }
}
```

