default:
  @just --list

local:
  open http://localhost:1313
  hugo server 


build:
  hugo build