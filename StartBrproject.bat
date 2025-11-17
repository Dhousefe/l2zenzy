@echo off
title Login Server - RusAcis
color 0B
cd /d "%~dp0"
java -Xms256m -Xmx512m -cp "libs/*" ext.mods.security.LicenseInit
pause
