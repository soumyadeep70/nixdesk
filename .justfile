set shell := ["bash", "-euo", "pipefail", "-c"]

repo := `pwd`
host := `hostname`
nh := "nh"

default:
    just --list

switch target=host:
    NIXDESK_ROOT="{{repo}}" \
    {{nh}} os switch . --hostname {{target}} --impure

boot target=host:
    NIXDESK_ROOT="{{repo}}" \
    {{nh}} os boot . --hostname {{target}} --impure

test target=host:
    NIXDESK_ROOT="{{repo}}" \
    {{nh}} os test . --hostname {{target}} --impure

check:
    NIXDESK_ROOT="{{repo}}" \
    nix flake check
