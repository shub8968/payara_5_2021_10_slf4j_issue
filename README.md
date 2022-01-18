# Test project for https://github.com/payara/Payara/issues/5554

This repository is used to reproduce the issue with Payara 5.2021.10 related to SLF4J logging when Apache Santuario is
used in the application. 

See also: https://github.com/payara/Payara/issues/5554

## Usage:

1. Build the project with Java 8 using Maven: `mvn clean package`
2. Run the docker container: `docker-compose up`
3. Execute the test:
   1. Successful request
    ```bash
    # Call the endpoint without Apache Santuario included => request should be successful. This means
    # you receive a 200 status code and in the logs you find some info log messages.
    $ curl http://localhost:8080/sample-app/no-santuario
    ```
   2. Failing request
    ```bash
    # Call the endpoint which tries to initialize Apache Santuario => request should fail. This means
    # you receive a 501 status code and in the logs you find the error log with the stack trace below.
    $ curl http://localhost:8080/sample-app/santuario
    ```
   
### Stack Trace of failing request:

```text
sample-app_1  | 15:08:22.384 [http-thread-pool::http-listener-1(2)] WARN  javax.enterprise.web._vs.server - StandardWrapperValve[de.gessnerfl.payara.slf4j.JAXRSConfiguration]: Servlet.service() for servlet de.gessnerfl.payara.slf4j.JAXRSConfiguration threw exception
sample-app_1  | java.lang.LinkageError: loader constraint violation: when resolving method "org.slf4j.impl.StaticLoggerBinder.getLoggerFactory()Lorg/slf4j/ILoggerFactory;" the class loader (instance of org/apache/felix/framework/BundleWiringImpl$BundleClassLoader) of the current class, org/slf4j/LoggerFactory, and the class loader (instance of sun/misc/Launcher$ExtClassLoader) for the method's defining class, org/slf4j/impl/StaticLoggerBinder, have different Class objects for the type org/slf4j/ILoggerFactory used in the signature
sample-app_1  | 	at org.slf4j.LoggerFactory.getILoggerFactory(LoggerFactory.java:423)
sample-app_1  | 	at org.slf4j.LoggerFactory.getLogger(LoggerFactory.java:362)
sample-app_1  | 	at org.slf4j.LoggerFactory.getLogger(LoggerFactory.java:388)
sample-app_1  | 	at org.apache.xml.security.Init.<clinit>(Init.java:57)
sample-app_1  | 	at de.gessnerfl.payara.slf4j.TestResource.testLoggingWithSantuario(TestResource.java:35)
sample-app_1  | 	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
sample-app_1  | 	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
sample-app_1  | 	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
sample-app_1  | 	at java.lang.reflect.Method.invoke(Method.java:498)
sample-app_1  | 	at org.glassfish.jersey.server.model.internal.ResourceMethodInvocationHandlerFactory.lambda$static$0(ResourceMethodInvocationHandlerFactory.java:52)
sample-app_1  | 	at org.glassfish.jersey.server.model.internal.AbstractJavaResourceMethodDispatcher$1.run(AbstractJavaResourceMethodDispatcher.java:124)
sample-app_1  | 	at org.glassfish.jersey.server.model.internal.AbstractJavaResourceMethodDispatcher.invoke(AbstractJavaResourceMethodDispatcher.java:167)
sample-app_1  | 	at org.glassfish.jersey.server.model.internal.JavaResourceMethodDispatcherProvider$ResponseOutInvoker.doDispatch(JavaResourceMethodDispatcherProvider.java:176)
sample-app_1  | 	at org.glassfish.jersey.server.model.internal.AbstractJavaResourceMethodDispatcher.dispatch(AbstractJavaResourceMethodDispatcher.java:79)
sample-app_1  | 	at org.glassfish.jersey.server.model.ResourceMethodInvoker.invoke(ResourceMethodInvoker.java:475)
sample-app_1  | 	at org.glassfish.jersey.server.model.ResourceMethodInvoker.apply(ResourceMethodInvoker.java:397)
sample-app_1  | 	at org.glassfish.jersey.server.model.ResourceMethodInvoker.apply(ResourceMethodInvoker.java:81)
sample-app_1  | 	at org.glassfish.jersey.server.ServerRuntime$1.run(ServerRuntime.java:255)
sample-app_1  | 	at org.glassfish.jersey.internal.Errors$1.call(Errors.java:248)
sample-app_1  | 	at org.glassfish.jersey.internal.Errors$1.call(Errors.java:244)
sample-app_1  | 	at org.glassfish.jersey.internal.Errors.process(Errors.java:292)
sample-app_1  | 	at org.glassfish.jersey.internal.Errors.process(Errors.java:274)
sample-app_1  | 	at org.glassfish.jersey.internal.Errors.process(Errors.java:244)
sample-app_1  | 	at org.glassfish.jersey.process.internal.RequestScope.runInScope(RequestScope.java:265)
sample-app_1  | 	at org.glassfish.jersey.server.ServerRuntime.process(ServerRuntime.java:234)
sample-app_1  | 	at org.glassfish.jersey.server.ApplicationHandler.handle(ApplicationHandler.java:680)
sample-app_1  | 	at org.glassfish.jersey.servlet.WebComponent.serviceImpl(WebComponent.java:394)
sample-app_1  | 	at org.glassfish.jersey.servlet.WebComponent.service(WebComponent.java:346)
sample-app_1  | 	at org.glassfish.jersey.servlet.ServletContainer.service(ServletContainer.java:366)
sample-app_1  | 	at org.glassfish.jersey.servlet.ServletContainer.service(ServletContainer.java:319)
sample-app_1  | 	at org.glassfish.jersey.servlet.ServletContainer.service(ServletContainer.java:205)
sample-app_1  | 	at org.apache.catalina.core.StandardWrapper.service(StandardWrapper.java:1637)
sample-app_1  | 	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:259)
sample-app_1  | 	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:160)
sample-app_1  | 	at org.apache.catalina.core.StandardPipeline.doInvoke(StandardPipeline.java:757)
sample-app_1  | 	at org.apache.catalina.core.StandardPipeline.invoke(StandardPipeline.java:577)
sample-app_1  | 	at com.sun.enterprise.web.WebPipeline.invoke(WebPipeline.java:99)
sample-app_1  | 	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:158)
sample-app_1  | 	at org.apache.catalina.connector.CoyoteAdapter.doService(CoyoteAdapter.java:371)
sample-app_1  | 	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:238)
sample-app_1  | 	at com.sun.enterprise.v3.services.impl.ContainerMapper$HttpHandlerCallable.call(ContainerMapper.java:520)
sample-app_1  | 	at com.sun.enterprise.v3.services.impl.ContainerMapper.service(ContainerMapper.java:217)
sample-app_1  | 	at org.glassfish.grizzly.http.server.HttpHandler.runService(HttpHandler.java:182)
sample-app_1  | 	at org.glassfish.grizzly.http.server.HttpHandler.doHandle(HttpHandler.java:156)
sample-app_1  | 	at org.glassfish.grizzly.http.server.HttpServerFilter.handleRead(HttpServerFilter.java:218)
sample-app_1  | 	at org.glassfish.grizzly.filterchain.ExecutorResolver$9.execute(ExecutorResolver.java:95)
sample-app_1  | 	at org.glassfish.grizzly.filterchain.DefaultFilterChain.executeFilter(DefaultFilterChain.java:260)
sample-app_1  | 	at org.glassfish.grizzly.filterchain.DefaultFilterChain.executeChainPart(DefaultFilterChain.java:177)
sample-app_1  | 	at org.glassfish.grizzly.filterchain.DefaultFilterChain.execute(DefaultFilterChain.java:109)
sample-app_1  | 	at org.glassfish.grizzly.filterchain.DefaultFilterChain.process(DefaultFilterChain.java:88)
sample-app_1  | 	at org.glassfish.grizzly.ProcessorExecutor.execute(ProcessorExecutor.java:53)
sample-app_1  | 	at org.glassfish.grizzly.nio.transport.TCPNIOTransport.fireIOEvent(TCPNIOTransport.java:524)
sample-app_1  | 	at org.glassfish.grizzly.strategies.AbstractIOStrategy.fireIOEvent(AbstractIOStrategy.java:89)
sample-app_1  | 	at org.glassfish.grizzly.strategies.WorkerThreadIOStrategy.run0(WorkerThreadIOStrategy.java:94)
sample-app_1  | 	at org.glassfish.grizzly.strategies.WorkerThreadIOStrategy.access$100(WorkerThreadIOStrategy.java:33)
sample-app_1  | 	at org.glassfish.grizzly.strategies.WorkerThreadIOStrategy$WorkerThreadRunnable.run(WorkerThreadIOStrategy.java:114)
sample-app_1  | 	at org.glassfish.grizzly.threadpool.AbstractThreadPool$Worker.doWork(AbstractThreadPool.java:569)
sample-app_1  | 	at org.glassfish.grizzly.threadpool.AbstractThreadPool$Worker.run(AbstractThreadPool.java:549)
sample-app_1  | 	at java.lang.Thread.run(Thread.java:748)
```
