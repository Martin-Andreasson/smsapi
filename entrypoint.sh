#!/bin/bash
telegraf --config https://influx.visiba.cloud/api/v2/telegrafs/08d0472f6e048000 & python3 /app/wsgi.py
 