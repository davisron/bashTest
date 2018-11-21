#!/usr/bin/expect
foreach number {
spawn cat ~/ip.list
192.168.100.101
192.168.100.102
192.168.100.103
192.168.100.104
} {

       puts "$number"
}

