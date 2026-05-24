#define TITDLG(cTxt) '('+hb_FNameNameExt( ProcFile() )+' '+lower(ProcName())+') '+cTxt
#define TITWIN(cTxt) '('+hb_FNameNameExt( ProcFile() )+' '+lower(ProcName())+') '+cTxt
#define TITVEN(cTxt) '('+hb_FNameNameExt( ProcFile() )+' '+lower(ProcName())+') '+cTxt

#ifdef __NODEBUG__

# xtranslate DEBUG <clauses, ...> =>

#else

#translate ASSTRING( <x> ) => If( <x> == NIL, 'NIL', Transform( <x> , NIL ) ) + Chr(13)+Chr(10)

#xcommand DEBUG <cString1>[, <cStringN>] ;
         => ;
          OutputDebugString( ProcName() +"("+LTrim(Str(ProcLine())) +") - " ) ; OutputDebugString( <"cString1">+" ("+ValType( <cString1> )+"): " ) ; OutputDebugString( ASSTRING( <cString1> ) ) ;
          [ ; OutputDebugString( ProcName() +"("+LTrim(Str(ProcLine())) +") - " ) ; OutputDebugString( <"cStringN">+" ("+ValType( <cStringN> )+"): " ) ; OutputDebugString( ASSTRING( <cStringN> ) ) ]

#endif

#xcommand TEXT INTO <v> => #pragma __cstream|<v>:=%s
#xcommand TEXT INTO <v> ADDITIVE => #pragma __cstream|<v>+=%s



*********************************************************************
* tb6Combo desarrollado por Biel Maimo, basado sobre DBCombo Sept. 2009
* File Name:	DBCombo.ch
* Author:	Elliott Whitticar
* Created:	04/23/96
* Description:  Preprocessor directives for TDBCombo class.
*********************************************************************
#ifndef _DBCOMBO_CH
#define _DBCOMBO_CH

/*----------------------------------------------------------------------------//
!short: DBCOMBO */

#xcommand @ <nRow>, <nCol> DBCOMBO [ <oCbx> VAR ] <cVar> ;
             [ ITEMS <aItems> ] ;
             [ SIZE <nWidth>, <nHeight> ] ;
             [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ VALID <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <pixel: PIXEL> ] ;
             [ FONT <oFont> ] ;
             [ <update: UPDATE> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ <design: DESIGN> ] ;
             [ BITMAPS <acBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
             [ ALIAS <cAlias> ] ;
             [ ITEMFIELD <cFldItem> ] ;
             [ LISTFIELD <cFldList> ] ;
             [ <list: LIST, PROMPTS> <aList> ] ;
             [ TABLE <cTable>];
             [ WHERE <cWhere>];
       => ;
          [ <oCbx> := ] tB6Combo():New( <nRow>, <nCol>, bSETGET(<cVar>),;
             <aItems>, <nWidth>, <nHeight>, <oWnd>, <nHelpId>,;
             [{|Self|<uChange>}], <{uValid}>, <nClrText>, <nClrBack>,;
             <.pixel.>, <oFont>, <cMsg>, <.update.>, <{uWhen}>,;
             <.design.>, <acBitmaps>, [{|nItem|<uBmpSelect>}], ;
             <cAlias>, <(cFldItem)>, <(cFldList)>, <aList>, <cTable>, <cWhere> )

#xcommand REDEFINE DBCOMBO [ <oCbx> VAR ] <cVar> ;
             [ <items: ITEMS> <aItems> ] ;
             [ ID <nId> ] ;
             [ <dlg:OF,WINDOW,DIALOG> <oWnd> ] ;
             [ <help:HELPID, HELP ID> <nHelpId> ] ;
             [ ON CHANGE <uChange> ] ;
             [ VALID   <uValid> ] ;
             [ <color: COLOR,COLORS> <nClrText> [,<nClrBack>] ] ;
             [ <update: UPDATE> ] ;
             [ MESSAGE <cMsg> ] ;
             [ WHEN <uWhen> ] ;
             [ BITMAPS <acBitmaps> ] ;
             [ ON DRAWITEM <uBmpSelect> ] ;
             [ ALIAS <cAlias> ] ;
             [ ITEMFIELD <cFldItem> ] ;
             [ LISTFIELD <cFldList> ] ;
             [ <list: LIST, PROMPTS> <aList> ] ;
             [ TABLE <cTable>];
             [ WHERE <cWhere>];
       => ;
          [ <oCbx> := ] tB6Combo():ReDefine( <nId>, bSETGET(<cVar>),;
             <aItems>, <oWnd>, <nHelpId>, <{uValid}>, [{|Self|<uChange>}],;
             <nClrText>, <nClrBack>, <cMsg>, <.update.>, <{uWhen}>,;
             <acBitmaps>, [{|nItem|<uBmpSelect>}], ;
             <cAlias>, <(cFldItem)>, <(cFldList)>, <aList>, <cTable>, <cWhere> )

#endif
// MySQL field structure
//#define  MYSQL_FS_NAME           1     /* Name of column */
//#define  MYSQL_FS_TABLE          2     /* Table of column if column was a field */
//#define  MYSQL_FS_DEF            3     /* Default value (set by mysql_list_fields) */
//#define  MYSQL_FS_TYPE           4     /* Type of field. Se mysql_com.h for types */
//#define  MYSQL_FS_LENGTH         5     /* Width of column */
//#define  MYSQL_FS_MAXLEN         6     /* Max width of selected set */
//#define  MYSQL_FS_FLAGS          7     /* Div flags */
//#define  MYSQL_FS_DECIMALS       8     /* Number of decimals in field */
//#define  MYSQL_FS_CLIP_TYPE      9     /* Type of field. clipper field type */
