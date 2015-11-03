#!/usr/bin/python

import socket
import os
import os.path
import re
import time
import sys
import ipaddr
import commands
from subprocess import call
from subprocess import check_output
from infrastructure_config import *

def addHost(net, switch, name, ip, mac):
    containerID=launchContainer()

def launchContainer(host,containerImage):
    containerID= check_output(['docker','run','-d','--net=none','--name=%s'%host['name'],'-h',host['name'],'-t', '-i','-v','/vagrant:/vagrant','--privileged=True',containerImage,'/bin/bash']) #docker run -d --net=none --name={name} -h {name} -t -i {image} /bin/bash
    #print "created container:", containerID[:-1]
    return containerID[:-1] #Remove extraneous \n from output of above

def connectContainerToSwitch(sw,host,containerID,of_port):
    hostIP=host['ip']
    mac=host['mac']
    nw = ipaddr.IPv4Network(hostIP)
    broadcast = "{}".format(nw.broadcast)
    router = "{}".format(nw.network + 1)
    cmd=['/vagrant/ovswork.sh',sw,containerID,hostIP,broadcast,router,mac,of_port,host['name']]
    if host.has_key('vlan'):
        cmd.append(host['vlan'])
    call(cmd)

def doCmd(cmd):
    listcmd=cmd.split()
    print check_output(listcmd)

def launch(switches, hosts, contIP='127.0.0.1'):

    for sw in switches:
        ports=0
        for host in hosts:
            if host['switch'] == sw['name']:
                containerImage=defaultContainerImage #from Config
                if host.has_key('container_image'): #from Config
                    containerImage=host['container_image']
                containerID=launchContainer(host,containerImage)
                ports+=1
                connectContainerToSwitch(sw['name'],host,containerID,str(ports))
                host['port-name']='vethl-'+host['name']
                print "Created container: %s with IP: %s. Connect using 'docker attach %s', disconnect with ctrl-p-q." % (host['name'],host['ip'],host['name'])

if __name__ == "__main__" :
    sw_index=int(socket.gethostname().split("sfcpxy",1)[1])-1
    if sw_index in range(0,len(switches)+1):

       controller=os.environ.get('ODL')
       sw_type = switches[sw_index]['type']
       sw_name = switches[sw_index]['name']

       sw_config_path = "/vagrant/%s-config.sh" % socket.gethostname()
       if os.path.exists(sw_config_path):
           doCmd("sudo %s" % sw_config_path)


