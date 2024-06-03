## Useful Tools and Commands

> It seems that above tools are included in ubi-minimal image of infinispan/server.

| Task                                          | Command                          |
|-----------------------------------------------|----------------------------------| 
| Text editor                                   | vi                               |
| Get the PID of the java process               | ps -fC java                      | 
| Get socket/file information                   | lsof                             | 
| List all open files excluding network sockets | lsof        \| grep -v "IPv[46]" | 
| List all TCP sockets                          | ss -t -a                         | 
| List all UDP sockets                          | ss -u -a                         | 
| Network configuration                         | ip                               | 
| Show unicast routes                           | ip route                         | 
| Show multicast routes                         | ip maddress                      |

TODO check for these commands in docker image!