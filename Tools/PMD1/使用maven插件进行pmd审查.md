在pom文件引入

```xml
<build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-pmd-plugin</artifactId>
                <version>3.13.0</version>
                <configuration>
                    <sourceEncoding>${project.build.sourceEncoding}</sourceEncoding>
                    <targetJdk>${maven.compiler.target}</targetJdk>
                    <printFailingErrors>true</printFailingErrors>
                    <linkXRef>true</linkXRef>
                    <!--<rulesets>-->
                    <!--<ruleset>-->
                    <!--${project.basedir}/code-check/quickstart-dist.xml-->
                    <!--</ruleset>-->
                    <!--</rulesets>-->
                    <!-- failOnViolation is actually true by default, but can be disabled -->
                    <failOnViolation>true</failOnViolation>
                    <!-- printFailingErrors is pretty useful -->
                    <printFailingErrors>true</printFailingErrors>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>
                                check
                            </goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```



打包命令

```
mvn clean package pmd:pmd -Pdev-docker -pl com.dist.xdata.dus:dus-union -am
```

在jenkins使用插件进行数据统计

```
stage('code-check') {
			steps{
                
			    //sh '/opt/pmd/pmd-bin-6.16.0/bin/run.sh pmd -d /data/jenkins/worspace/BackEnd_base/${JOB_NAME}/ -f xml -R /opt/pmd/pmd-bin-6.16.0/template/quickstart-dist.xml > /data/jenkins/worspace/BackEnd_base/${JOB_NAME}/pmd.xml || date'
			    //generate pmd check report
			    recordIssues enabledForFailure: true, tool: pmdParser(), sourceCodeEncoding: 'UTF-8'
			    
			}
		}
```

