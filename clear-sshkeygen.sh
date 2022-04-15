#!/bin/bash

ssh-keygen -f "$HOME/.ssh/known_hosts" -R "bastion1"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "bastion2"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker1"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker2"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker3"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "worker4"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "master1"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "master2"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "master3"
