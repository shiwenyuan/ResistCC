# ResistCC
项目由来
```$xslt
近期公司网站反馈说加载速度较慢，就去找了一下原因,结果发现有几个IP每天都在疯狂请求(每分钟大概在5000左右)。这时就意识到了网站被别人发起了cc攻击
```

## 什么是洪水攻击

```$xslt
洪水攻击（FLOOD ATTACK）指的是利用计算机网络技术向目标机发送大量的无用数据报文，使得目标主机忙于处理无用的数据报文而无法提供正常服务的网络行为。洪水攻击主要分为ICMP、UDP和SYN攻击3种类型
```
## ICMP洪水攻击主要有3种方式
- 1 直接洪水攻击
- 2 伪装IP攻击
- 3 反射攻击

### 1 直接洪水攻击
```$xslt
主机与目标的带宽比拼，用性能砸死他，让目标机造成宕机。缺点：目标机可以根据源ip，屏蔽攻击源，甚至可能被反向攻击。
```

### 2 伪装IP攻击
```$xslt
将发送方ip用伪装ip代替，是直接洪水攻击的改进版。 
```

### 3 反射攻击
```$xslt
并非自身攻击，而是利用伪装ip，让其他主机误认为目标机在向其发送ICMP请求，结果：目标主机需要对所有请求进行ICMP应答发送 
```

## 攻击方式分析
```$xslt
应该是每天都会重启一次攻击脚本，当天的攻击ip拉黑后就不会再次攻击，只有到了第二天重启之后会换ip再次攻击 此时他应当`伪装IP攻击`或者`反射攻击`
```

## 抵御办法

```$xslt
分析nginx的log，通过log查询出来有问题的ip然后通过ipset去做一个黑名单的配置管理
```


```$xslt
目前是做了一个基于分钟的，通过blacklist.conf去配置执行间隔,然后通过crontab 去执行。具体参数见blacklist.conf
```

## nginxlog的格式
```$xslt
121.41.112.148 56888563 - 0.002 0.002 [28/Jun/2018:10:12:00 +0800] "iz25ndyf9bxz" "HEAD / HTTP/1.1" 302 0 mod_gzip: -pct "-" "-" "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)" ssl:"" server_port:"7080" scripts:/
```
如果格式不一样可以去改一下nginx access.log 配置
```$xslt
log_format main '$remote_addr $connection $remote_user $request_time $upstream_response_time [$time_local] "$hostname" "$request" $status $body_bytes_sent mod_gzip: -pct "$http_referer" "$http_cookie" "$http_user_agent" ssl:"$https" server_port:"$server_port" scripts:$document_root$fastcgi_script_name';
```
### 最后
```$xslt
如果这个脚本对你有帮助的话欢迎star
```