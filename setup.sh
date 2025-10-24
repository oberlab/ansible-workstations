#!/bin/bash

ansible-playbook -i "localhost," -c local setup.yaml --ask-become-pass $@
