@echo off
docker run --rm --network host ^
  -v %cd%\liquibase:/liquibase/changelog/liquibase ^
  -v %cd%\liquibase.properties:/liquibase/changelog/liquibase.properties ^
  liquibase/liquibase:4.24.0 ^
  --defaultsFile=/liquibase/changelog/liquibase.properties ^
  update
pause