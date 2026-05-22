/*
 * TDOLPHIN PROJECT source code:
 * Messages Language Support
 *
 * Copyright 2011 Daniel Garcia-Gil<danielgarciagil@gmail.com>
 * www - http://tdolphin.blogspot.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the tdolphin Project gives permission for
 * additional uses of the text contained in its release of tdolphin.
 *
 * The exception is that, if you link the tdolphin libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the tdolphin library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the tdolphin
 * Project under the name tdolphin.  If you copy code from other
 * tdolphin Project or Free Software Foundation releases into a copy of
 * tdolphin, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for tdolphin, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */


#include "hbapi.h"
#include "hbapilng.h"
#include "gerrapi.h"
#include "hbapierr.h"
#include "dolerr.ch"

#define STARTCODE 9000

static G_LANG * pLangActive;

static G_LANG LangInstalled[] = {
  { "EN", &LoadMsgsEN, 0 },
  { "ES", &LoadMsgsES, 0 },
  { "es.ESWIN", &LoadMsgsES, 0 }  
};

static G_ERRMSG * pErrMessage = NULL;
  
static const char * sIDLang = NULL;


//--------------------------------------------------------------//

static void LoadMsgs( void )
{
  const char * sID = hb_langID();
  
  if( ! sIDLang || hb_stricmp( sIDLang, sID ) != 0 ){    
    int iLen = sizeof( LangInstalled ) / sizeof( G_LANG );
    int i;
    sIDLang = sID;    

    for( i=0; i < iLen; i++ )
    {
      if( hb_stricmp( LangInstalled[ i ].sLang, sID ) == 0 ){
         int (*fp)();
         pLangActive = &LangInstalled[ i ];
         fp = (int(*)(void))pLangActive->pFuncLang;
         pLangActive->lTotalMsgs = (*fp)();
      }
    }
  }
}

//--------------------------------------------------------------//  
  
static char * GetGErrorMsg( HB_ERRCODE iCode, const char * sAux )
{
  int iPos = ( int ) iCode - STARTCODE;
  char * cMsg = ( char * )hb_xgrab( 128 );

  LoadMsgs();

  if( iPos >= 0 && iPos < pLangActive->lTotalMsgs )
  {
    if( sAux != NULL )
    {
       
       sprintf( cMsg,  pErrMessage[ iPos ].sDescription, sAux );
       return ( char * )cMsg;
    }else
    {
      hb_snprintf( cMsg, strlen( pErrMessage[ iPos ].sDescription ) + 1, "%s", pErrMessage[ iPos ].sDescription );
      //memcpy( cMsg, pErrMessage[ iPos ].sDescription, strlen( pErrMessage[ iPos ].sDescription ) );
      return cMsg;
    }
  }
  return NULL;
}

//--------------------------------------------------------------//  

static char * GetGErrorMsg1( HB_ERRCODE iCode )
{
  return GetGErrorMsg( iCode, NULL );
}


//--------------------------------------------------------------//

void BuildErrMsg( G_ERRMSG *ErrMsg, int iSize )
{
  
  if( pErrMessage )
    hb_xfree( pErrMessage );
  
  pErrMessage = ( G_ERRMSG * ) hb_xgrab( iSize );
  
  memcpy( pErrMessage, ErrMsg, iSize );

  return;
}

HB_FUNC( DOL_GETERROTEXT )
{
   hb_retc( GetGErrorMsg1( hb_parnl( 1 ) ) );
}