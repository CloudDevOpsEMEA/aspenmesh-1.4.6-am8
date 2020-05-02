#!/bin/bash
#
# Small script to show the difference between the standard helm values 
# for Aspen Mesh and the one used for this installation
#

echo "The difference between the standard values-aspenmesh.yaml and the one used for this installation"

grc diff -u values-aspenmesh.yaml ./install/kubernetes/helm/istio/values-aspenmesh.yaml

