# tDolphin

**ORM/acceso a MariaDB/MySQL para Harbour + FiveWin**

Fork mantenido de [TDolphin](https://bitbucket.org/USUARIO_ORIGINAL/tdolphin) (Daniel García-Gil) con optimizaciones y adaptaciones para uso propio.

## Clases principales

| Clase | Descripción |
|-------|-------------|
| `TDolphinSrv` | Conexión al servidor MariaDB/MySQL |
| `TDolphinQry` | Queries, resultados y operaciones CRUD |
| `TDolphinExport` | Exportación a DBF, Excel, HTML, Word |

## Compilación

```batch
build_bcc77.bat
```

Requiere Harbour + BCC 7.7. Ver `CLAUDE.md` para detalles del entorno y decisiones de diseño.
