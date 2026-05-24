# tDolphin — Contexto del proyecto para Claude Code

## Qué es este proyecto

tDolphin es una librería ORM/acceso a MariaDB/MySQL para Harbour + FiveWin.
Clases principales: `TDolphinSrv` (conexión), `TDolphinQry` (query/resultado), `TDolphinExport` (exportación).

Fuentes propios del proyecto:
- `source/prg/tdolpsrv.prg` — clase TDolphinSrv (servidor/conexión)
- `source/prg/tdolpqry.prg` — clase TDolphinQry (queries, CRUD)
- `source/prg/tdolpexp.prg` — clase TDolphinExport (exportación DBF/Excel/HTML/Word)

## Modificaciones de Biel fusionadas (mayo 2026)

Se fusionaron los cambios que Biel tenía en `C:\appl\fwh\crico\coffeesys\source\` hacia este
repositorio. Todos los cambios llevan comentario `//Biel` o marcadores `//<begin> Biel MMAA`.

### tdolpqry.prg

| Zona | Cambio |
|------|--------|
| Includes | Añadido `#include "bielsys.ch"` |
| Declaración `IsSingleTable()` | Cambiada de INLINE a método completo (detecta JOIN en nombre de tabla) |
| `New()` line ~277 | Se mantiene `TransformQueryParams(cQuery, uParams)` — **sin** `Lower()` para no romper comparaciones case-sensitive |
| `BuildDatas()` | Extracción de columnas SELECT por `SubStr/RAt('FROM')` antes del tokenizer; CASE 1 comentado |
| `Delete()` | Check cambiado de `!IsSingleTable()` a `Len(::aTables) > 1` para permitir DELETE en queries con JOIN de tabla única |
| `Delete()` | Parsing del nombre de tabla con espacios (`nPos := At(' ',...)`) con comentarios Biel 1409 |
| `IsSingleTable()` | Cuerpo completo del método: devuelve `.F.` si hay múltiples tablas O si el nombre contiene 'JOIN' |
| `LoadQuery()` | Rellena `MYSQL_FS_DEF` via `b6Def()` para que `GetBlankRow()` tenga los DEFAULT del schema |
| `Refresh()` | `BuildQuery()` comentado — usa directamente `LoadQuery()` sin reconstruir la SQL (agosto 2025) |
| `Save()` lAppend | `lChanged` ya no es siempre `.T.`: numéricos siempre se graban, otros solo si `!Empty()` |
| `Save()` UPDATE | Condición de cambio simplificada: `!( uValue == uOldValue )` |
| `CASE "T"` | Manejo específico de TIMESTAMP: `HB_TTOS(cField)` si el valor es tipo T, `""` si no |

### tdolpsrv.prg

| Zona | Cambio |
|------|--------|
| `ClipValue2SQL()` | Guard: si `ValType(Value) != cType` muestra MsgInfo diagnóstico y retorna el valor sin procesar |
| `Dolphin_DefError()` | `oError:Description` usa solo `oServer:ErrorTxt()` — se eliminó llamada a `DOL_GETERROTEXT` que causaba ACCESS_VIOLATION |

### tdolpexp.prg

| Zona | Cambio |
|------|--------|
| Export DBF — `USE` | Añadida cláusula `NEW` para abrir en área independiente |
| Export DBF — cierre | `DBCloseArea()` para cerrar el área al terminar la exportación |

## Decisiones de diseño tomadas

- **`Lower()` en queries**: Se evaluó añadir `Lower(cQuery)` en `New()` para evitar configurar
  `lower_case_tables` en MariaDB, pero se descartó porque puede romper comparaciones
  case-sensitive en cláusulas WHERE. La solución correcta es configurar MariaDB.

- **`TransformQueryParams`**: Se mantiene para compatibilidad con otros usuarios de tDolphin.
  Permite queries parametrizadas con `&nombre` o `&1`. Si `uParams` es NIL no tiene coste.

- **`IsSingleTable()` vs `Len(::aTables) > 1`**: En `Delete()` se usa el check directo
  `Len > 1` (no llama a `IsSingleTable()`) para permitir DELETE en queries con JOIN que
  referencian una sola tabla física.

## Compilación

### Con BCC 7.7 (entorno actual — recomendado)

```
build_bcc77.bat
```

Genera `lib\tdolphin.lib`. Para rebuild completo borrar `lib\.hbmk\` y `lib\tdolphin.lib` primero.

**Rutas del entorno BCC 7.7:**
- Harbour: `C:\FW\bcc770_32_20250515\`
- hbmk2: `C:\FW\bcc770_32_20250515\bin\win\bcc\hbmk2.exe`
- BCC 7.7: `C:\Borland\bcc77\bin\bcc32.exe`
- Libs Harbour: `C:\FW\bcc770_32_20250515\lib\` (plano, sin subcarpeta)

**Flags especiales:**
- `-cflag=-w-` — necesario porque BCC 7.7 trata ciertos warnings del Windows SDK como errores
- `BielSys.ch` debe estar en `.\include\` (ya está en el include path del .hbp)

### Con BCC 5.82 u otros compiladores

Requiere variables de entorno configuradas con uno de los scripts `setenv*.bat`:
- `setenvh.bat` — Harbour + BCC 5.82
- `setenvhbcc77.bat` — Harbour + BCC 7.7 (via win-make)
- `setenvhg.bat` — Harbour + MinGW
- `setenvhm.bat` — Harbour + MSVC

### Fixes de compatibilidad BCC 7.7 aplicados

| Fichero | Fix |
|---------|-----|
| `include/mysql.h` | `winsock2.h` incluido para `_WIN32` (no solo `__LCC__`) — define SOCKET antes de mysql_com.h |
| `source/c/function.c` | `#include <winsock2.h>` añadido antes de `<windows.h>` |
