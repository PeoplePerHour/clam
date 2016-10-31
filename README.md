# Peopleperhour antivirus clamd server

## About this Repo

This Git repo of the clamd antivirus server that listen to TCP socket for commands.

## Why we needed this 

This gives us the ability to scan remotely files for known various and sanitize our S3 bucket. 

## Technology 

This is a clamav antivirus running inside a container. This is done in order to scale easily our scanning capacity.

The container is managed by a python supervisor that starts 2 main programs, the freshclam and clamd. The first will update the clam database every `FRESHCLAM_UPDATE` (default 2) times a day, and the second will start clamav process. Everytime freshclam performs an update it will notify clam of the update to reload the database.

## Sending commands.

This container accepts TCP commands, more information about the TCP commands can be found here `http://manpages.ubuntu.com/manpages/trusty/man8/clamd.8.html`

KEEP IN MIND: that this container should be reside in your private network because it can be abused by DDoS attack, so please keep this protected.


