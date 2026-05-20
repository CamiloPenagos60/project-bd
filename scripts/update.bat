@echo off
docker run --rm --network host ^
  -v "%cd%":/workspace ^
  -w /workspace ^
  liquibase/liquibase:4.24.0 ^
  --defaultsFile=liquibase.properties ^
  update
pause