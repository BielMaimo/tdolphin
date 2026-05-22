#rules.mak
##################################################################
#PRG_COMPILER
#   HARBOUR
#      PRG_COMP_PATH -> \harbour
#   XHARBOUR
#      PRG_COMP_PATH -> \xharbour
##################################################################
#      PRG_COMP_BIN_PATH -> $(PRG_COMP_PATH)\bin
#      PRG_COMP_LIB_PATH -> $(PRG_COMP_PATH)\lib\win\bcc
#      PRG_COMP_INC_PATH -> $(PRG_COMP_PATH)\include
##################################################################
#C_COMPILER
#   BCC    -> BORLAND
#      C_COMP_PATH -> \bcc582
#      C_COMP_BIN_PATH=$(C_COMP_PATH)\bin
#      C_COMP_LIB_PATH=$(C_COMP_PATH)\lib;$(C_COMP_PATH)\lib\psdk
#      C_COMP_INC_PATH=$(C_COMP_PATH)\include
#   MINGW  -> MINGW32
#      C_COMP_PATH -> \mingw
#      C_COMP_BIN_PATH=$(C_COMP_PATH)\bin
#      C_COMP_LIB_PATH=$(C_COMP_PATH)\lib
#      C_COMP_INC_PATH=$(C_COMP_PATH)\include
#   MSVC32 -> MICROSOFT 32 BITS
#      C_COMP_PATH -> %ProgramFiles%\Microsoft Visual Studio 9.0\vc
#   MSVC64 -> MICROSOFT 64 BITS
#      C_COMP_PATH -> "%ProgramFiles(x86)%\Microsoft Visual Studio 9.0\vc"
##################################################################
# for microsoft compiler call $(C_COMP_PATH)\vcvarsall.bat
# otherwise
##################################################################
# output 
# HARBOUR
#    LIBNAME=dolphinh
# XHARBOUR
#    LIBNAME=dolphinx
#
# DOLPHIN_INC=.\include
# DOLPHIN_OBJ  = obj\$(PRG_COMPILER)\$(C_COMPILER)
# DOLPHIN_LIB  = lib\$(PRG_COMPILER)\$(C_COMPILER)
##################################################################
# user variables
# USER_DEFINE=
# USER_INCLUDE=
##################################################################

# --------------------------------------------------------
#default values
# --------------------------------------------------------
SEPARATOR=$(subst /,\,/)
DEFX=__HARBOUR__
ifeq ($(DEBUG),)
	DEBUG=__NODEBUG__
endif
ifeq ($(PRG_COMPILER),XHARBOUR)
	DEFX=__XHARBOUR__
endif

# --------------------------------------------------------
# prg compiler
# --------------------------------------------------------
ifeq ($(PRG_COMPILER),)
	PRG_COMPILER=HARBOUR
endif
ifeq ($(PRG_COMP_PATH),)
	PRG_COMP_PATH=$(SEPARATOR)harbour
endif
ifeq ($(PRG_COMP_BIN_PATH),)
	PRG_COMP_BIN_PATH=$(PRG_COMP_PATH)$(SEPARATOR)bin
endif
ifeq ($(PRG_COMP_LIB_PATH),)
	PRG_COMP_LIB_PATH=$(PRG_COMP_PATH)$(SEPARATOR)lib$(SEPARATOR)win$(SEPARATOR)bcc
endif
ifeq ($(PRG_COMP_INC_PATH),)
	PRG_COMP_INC_PATH=$(PRG_COMP_PATH)$(SEPARATOR)include
endif
# --------------------------------------------------------
# C compiler
# --------------------------------------------------------
ifeq ($(C_COMPILER),)
	C_COMPILER=BCC
endif
ifeq ($(C_COMPILER),BCC)
	ifeq ($(C_COMP_PATH),)
		C_COMP_PATH=$(SEPARATOR)bcc582
	endif
	ifeq ($(C_COMP_BIN_PATH),)
		C_COMP_BIN_PATH=$(C_COMP_PATH)$(SEPARATOR)bin
	endif
	ifeq ($(C_COMP_LIB_PATH),)
		C_COMP_LIB_PATH=$(C_COMP_PATH)$(SEPARATOR)lib;$(C_COMP_PATH)$(SEPARATOR)lib$(SEPARATOR)psdk
	endif
	ifeq ($(C_COMP_INC_PATH),)
		C_COMP_INC_PATH=$(C_COMP_PATH)$(SEPARATOR)include
	endif
endif
ifeq ($(C_COMPILER),MSVC32)
	_MSVC=yes
endif
ifeq ($(C_COMPILER),MSVC64)
	_MSVC=yes
endif

ifeq ($(_MSVC),yes)
	ifeq ($(NO_VC_BAT),1)
		ifeq ($(C_COMP_PATH),)
			ERROR_MSG = C_COMP_PATH
		endif
		ifeq ($(C_COMP_BIN_PATH),)
			ifneq ($(ERROR_MSG),)
				ERROR_MSG+=, 
			endif
			ERROR_MSG+=C_COMP_BIN_PATH
		endif
		ifeq ($(C_COMP_LIB_PATH),)
			ifneq ($(ERROR_MSG),)
				ERROR_MSG+=, 
			endif
			ERROR_MSG+=C_COMP_LIB_PATH
		endif
		ifeq ($(C_COMP_INC_PATH),)
			ifneq ($(ERROR_MSG),)
				ERROR_MSG+=, 
			endif	
			ERROR_MSG+=C_COMP_INC_PATH
		endif
	endif
endif

# --------------------------------------------------------
# dolphin default values
# --------------------------------------------------------

DOLPHIN_INC=$(ROOT)$(SEPARATOR)include
PRG_SOURCE_PATH=$(ROOT)$(SEPARATOR)source$(SEPARATOR)prg
C_SOURCE_PATH=$(ROOT)$(SEPARATOR)source$(SEPARATOR)c
LANG_SOURCE_PATH=$(ROOT)$(SEPARATOR)source$(SEPARATOR)lang
DOLPHIN_OBJ  = $(ROOT)$(SEPARATOR)obj$(SEPARATOR)$(PRG_COMPILER)$(SEPARATOR)$(C_COMPILER)
DOLPHIN_LIB  = $(ROOT)$(SEPARATOR)lib$(SEPARATOR)$(PRG_COMPILER)$(SEPARATOR)$(C_COMPILER)
GT_LIB=$(BLD_TYPE)
ifeq ($(LIBNAME),)
	LIBNAME=dolphin
endif
ifeq ($(C_COMPILER),MINGW32)
	LIB_PREF=lib
	LIB_EXT=a
	OBJ_EXT=o	
else
	OBJ_EXT=obj
	LIB_EXT=lib
endif
DOLPHIN_LIBNAME=$(LIB_PREF)$(LIBNAME).$(LIB_EXT)
ifeq ($(DOLPHIN_LIB),)
	DOLPHIN_LIB=$(ROOT)$(SEPARATOR)lib
endif

# --------------------------------------------------------
# PRG FLAGS 
# --------------------------------------------------------
ifeq ($(SAMPLE),)
	PRG_FLAGS=-D$(USER_DEFINE) -D__WIN__ -D$(DEBUG) -q0 /N /W /w /es2 /O$(DOLPHIN_OBJ)$(SEPARATOR) /I$(DOLPHIN_INC);$(PRG_COMP_INC_PATH);$(USER_INCLUDE)
else
	PRG_FLAGS=-D$(USER_DEFINE) -D__WIN__ -D$(DEBUG) -q0 /n /i$(DOLPHIN_INC);$(PRG_COMP_INC_PATH);$(USER_INCLUDE);$(GUI_INC)
endif
# --------------------------------------------------------
# LIBRARIES
# --------------------------------------------------------


ifeq ($(PRG_COMPILER),HARBOUR)
	ifeq ($(C_COMPILER),MINGW32)
		LD_LIB= $(GUI_LIB) $(GT_LIB) user32 winspool comctl32 comdlg32 gdi32 ole32 oleaut32 uuid winmm vfw32 wsock32 msimg32 hbcommon hbcpage hbcplr \
		hbct hbhsx hblang hbmacro hbmainstd hbmisc hbmzip hbnf hbodbc odbc32 hbpcre hbpp hbrdd hbrtl hbsix hbtip hbusrrdd hbvm hbwin hbzlib \
		rddcdx rddfpt rddntx xhb	

	else
		LD_LIB=\
	  $(GUI_LIB)\
		hbcommon \
		hbvm \
		hbrtl \
		hbdebug \
		hbpcre \
		$(GT_LIB) \
		hblang \
		hbrdd \
		hbmacro \
		hbpp \
		hbhsx \
		hbsix \
		hbwin \
		hbct \
		hbtip \
		hbzlib \
		xhb \
		rddcdx \
		rddfpt \
		rddntx \
		hbusrrdd \
		hbcpage \
		hbcplr
	endif
else	
	ifeq ($(C_COMPILER),MINGW32)
		LD_LIB= $(GUI_LIB) $(GT_LIB) user32 winspool comctl32 comdlg32 gdi32 ole32 oleaut32 uuid \
		winmm vfw32 wsock32 msimg32 common codepage \
		ct hsx lang macro libmisc zlib hbsix hbodbc pcrepos pp rdd rtl sixcdx tip usrrdd vm \
		dbfcdx dbffpt dbfntx
	else
		LD_LIB= $(GUI_LIB) rtl hsx hbsix vm $(GT_LIB) Lang macro rdd dbfntx dbfcdx common libmisc CodePage DbfFpt pcrepos ct
	endif
endif

# --------------------------------------------------------
# C COMPILER
# --------------------------------------------------------

# --------------------------------------------------------
# BORLAND
# --------------------------------------------------------
ifeq ($(C_COMPILER),BCC)
	ifeq ($(SAMPLE),)
		C_FLAGS=-c -D__WIN__ -D$(DEFX) -DHB_LEGACY_TYPES_ON -tWM -w-8071 -w-8060 -w-8004 -I$(PRG_COMP_INC_PATH) -I$(DOLPHIN_INC) -o$@ $<
	else
		C_FLAGS=-c -D__WIN__ -D$(DEFX) -DHB_LEGACY_TYPES_ON -M -e$(SAMPLE).exe -w-8071 -w-8060 -w-8004 -I$(PRG_COMP_INC_PATH) -I$(DOLPHIN_INC) -o$@ $<
	endif
	
	ifeq ($(LIBMYSQL),)
		ifeq ($(EMBEDDED),no)
			LIBMYSQL := libmysql
		else 
			LIBMYSQL := libmysqld
		endif
	endif	
	
	STD_LIBS = cw32 import32 psapi
	
	ifeq ($(BLD_TYPE),gtgui)
		STD_OBJS=c0w32.obj
		LIBS= $(GUILIB) $(DOLPHIN_LIBNAME) $(addsuffix .$(LIB_EXT), $(LIBMYSQL) $(LD_LIB) $(STD_LIBS) )	  
		LD_FLAGS=-Gn -aa -Tpe -s -x \
		-L$(C_COMP_PATH)$(SEPARATOR)lib \
		-L$(C_COMP_PATH)$(SEPARATOR)lib$(SEPARATOR)psdk \
		-L$(DOLPHIN_LIB) -L$(ROOT)$(SEPARATOR)lib$(SEPARATOR)mysql$(SEPARATOR)omf \
		-L$(PRG_COMP_LIB_PATH)
	else
		STD_OBJS=c0x32.obj
		LIBS=$(DOLPHIN_LIBNAME)  $(addsuffix .$(LIB_EXT), $(LIBMYSQL) $(LD_LIB) $(STD_LIBS) )
		LD_FLAGS=-Gn -Tpe -s -L$(C_COMP_PATH)$(SEPARATOR)lib \
		-L$(C_COMP_PATH)$(SEPARATOR)lib$(SEPARATOR)psdk \
		-L$(DOLPHIN_LIB) -L$(ROOT)$(SEPARATOR)lib$(SEPARATOR)mysql$(SEPARATOR)omf \
		-L$(PRG_COMP_LIB_PATH)
	endif	
	CC=bcc32
	LD=ilink32
	AR=tlib
	
	RC=brc32
	RC_FLAGS = -x -r -i"$(C_COMP_INC_PATH)" -fo"$@"
	RCC_CMD  = $(C_COMP_BIN_PATH)\$(RC) $(RC_FLAGS) "$<"	
	
	LIB_FLAGS=$(addprefix +-,$(filter %.obj,$^)) /0 /P32,,
	LD_CMD   = $(C_COMP_PATH)$(SEPARATOR)bin$(SEPARATOR)$(LD) $(LD_FLAGS) $(STD_OBJS) $(filter %.obj,$^), $@.exe,$@.map, $(LIBS),,$(filter %.res,$^)
endif

# --------------------------------------------------------
# MICROSOFT 32
# --------------------------------------------------------
ifeq ($(C_COMPILER),MSVC32)
	C_FLAGS=-c -D__WIN__ -D$(DEFX) -DHB_LEGACY_TYPES_ON -I$(PRG_COMP_INC_PATH) -I$(DOLPHIN_INC) -nologo -Fo$@ $<
	
	ifeq ($(LIBMYSQL),)
		ifeq ($(EMBEDDED),no)
			LIBMYSQL := libmysqlm
		else 
			LIBMYSQL := libmysqldm
		endif
	endif		
	
	MSVC_LIB=\
	kernel32 \
	user32 \
	gdi32 \
	winspool \
	comctl32 \
	comdlg32 \
	advapi32 \
	shell32 \
	ole32 \
	oleaut32 \
	uuid \
	odbc32 \
	odbccp32 \
	iphlpapi \
	mpr \
	version \
	wsock32 \
	msimg32 \
	oledlg
	
	CC=cl
	LD=link
	AR=lib
	LIB_FLAGS= /OUT:$(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).$(LIB_EXT) $(filter %.obj,$^)

	ifeq ($(BLD_TYPE),gtgui)
		LIBS=$(GUILIB) $(DOLPHIN_LIBNAME) $(LIBMYSQL) $(addsuffix .$(LIB_EXT), $(LD_LIB) $(MSVC_LIB))
		LD_FLAGS=/LIBPATH:"$(C_COMP_PATH)$(SEPARATOR)lib" \ 
		/LIBPATH:"$(DOLPHIN_LIB)" \ 
		/LIBPATH:"$(ROOT)$(SEPARATOR)lib$(SEPARATOR)mysql$(SEPARATOR)coff" \
		/LIBPATH:"$(PRG_COMP_LIB_PATH)" /NOLOGO /SUBSYSTEM:WINDOWS /FORCE:MULTIPLE /IGNORE:4006
	else
		LIBS=$(DOLPHIN_LIBNAME) $(addsuffix .$(LIB_EXT), $(LIBMYSQL) $(LD_LIB) $(MSVC_LIB))
		LD_FLAGS=/LIBPATH:"$(C_COMP_PATH)$(SEPARATOR)lib" \
		/LIBPATH:"$(DOLPHIN_LIB)" \
		/LIBPATH:"$(ROOT)$(SEPARATOR)lib$(SEPARATOR)mysql$(SEPARATOR)coff" \
		/LIBPATH:"$(PRG_COMP_LIB_PATH)" /NOLOGO /SUBSYSTEM:CONSOLE /FORCE:MULTIPLE /IGNORE:4006  
	endif
	LD_CMD= "$(C_COMP_PATH)$(SEPARATOR)bin$(SEPARATOR)$(LD)" $(LD_FLAGS) $@.$(OBJ_EXT) $(LIBS)
endif


# --------------------------------------------------------
# MICROSOFT 64
# --------------------------------------------------------

ifeq ($(C_COMPILER),MSVC64)
	C_FLAGS=-c -D__WIN__ -D$(DEFX) -DHB_LEGACY_TYPES_ON -TP -I$(PRG_COMP_INC_PATH) -I$(DOLPHIN_INC) -nologo -Fo$@ $<

	ifeq ($(LIBMYSQL),)
		LIBMYSQL = libmysql64
	endif		

	MSVC_LIB=\
	kernel32 \
	user32 \
	gdi32 \
	libcmt \
	oldnames \
	uuid \
	ole32 \
	oleaut32

	CC=cl
	LD=link
	AR=lib

	ifeq ($(BLD_TYPE),gtgui)
		LIBS=$(GUILIB) $(DOLPHIN_LIBNAME) $(addsuffix .$(LIB_EXT), $(LIBMYSQL) $(LD_LIB) $(MSVC_LIB))
		LD_FLAGS=/LIBPATH:"$(C_COMP_PATH)$(SEPARATOR)lib" \
		/LIBPATH:"$(DOLPHIN_LIB)" \
		/LIBPATH:"$(ROOT)$(SEPARATOR)lib$(SEPARATOR)lib64" \
		/LIBPATH:"$(PRG_COMP_LIB_PATH)" /NOLOGO /SUBSYSTEM:WINDOWS /FORCE:MULTIPLE /IGNORE:4006 /MACHINE:X64
	else
		LIBS=$(DOLPHIN_LIBNAME) $(addsuffix .$(LIB_EXT), $(LIBMYSQL) $(LD_LIB) $(MSVC_LIB))
		LD_FLAGS=/LIBPATH:"$(C_COMP_PATH)$(SEPARATOR)lib" \
		/LIBPATH:"$(DOLPHIN_LIB)" \
		/LIBPATH:"$(ROOT)$(SEPARATOR)lib$(SEPARATOR)lib64" \
		/LIBPATH:"$(PRG_COMP_LIB_PATH)" /NOLOGO /SUBSYSTEM:CONSOLE /FORCE:MULTIPLE /IGNORE:4006 /MACHINE:X64 /NODEFAULTLIB:libcmt.lib
	endif
	LD_CMD= "$(C_COMP_PATH)$(SEPARATOR)bin$(SEPARATOR)$(LD)" $(LD_FLAGS) $@.$(OBJ_EXT) $(LIBS)
	
	LIB_FLAGS= /MACHINE:X64 /OUT:$(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).$(LIB_EXT) $(filter %.$(OBJ_EXT),$^)
endif

# --------------------------------------------------------
# MINIGW 32
# --------------------------------------------------------

ifeq ($(C_COMPILER),MINGW32)
	$(LIB_EXT)=a
	C_FLAGS=-c -D__WIN__ -D$(DEFX) -DHB_LEGACY_TYPES_ON -I$(PRG_COMP_INC_PATH) -I$(DOLPHIN_INC) -I$(C_COMP_INC_PATH) -o$@ $< 

	ifeq ($(LIBMYSQL),)
		ifeq ($(EMBEDDED),no)
			LIBMYSQL := -llibmysqlm
		else 
			LIBMYSQL := -llibmysqldm
		endif
	endif	

  MINIGW_LIB=-ldolphin $(addprefix -l, $(LIBMYSQL) $(LD_LIB))
	LD_FLAGS= -o$@.exe $@.$(OBJ_EXT) -Wall -s -mconsole -L$(C_COMP_PATH)$(SEPARATOR)lib \
	-L$(DOLPHIN_LIB) -L$(ROOT)$(SEPARATOR)lib$(SEPARATOR)mysql$(SEPARATOR)coff \
	-L$(PRG_COMP_LIB_PATH) \
  -mno-cygwin -Wl,--start-group -lsupc++

	CC=gcc
	LD=gcc
	AR=ar
	LIB_FLAGS= rc $(DOLPHIN_LIB)$(SEPARATOR)$(DOLPHIN_LIBNAME) $(filter %.$(OBJ_EXT),$^)	
	LD_CMD= "$(C_COMP_PATH)$(SEPARATOR)bin$(SEPARATOR)$(LD)" $(LD_FLAGS) $(MINIGW_LIB) -Wl,--end-group

endif

OBJ_FILES = $(addprefix $(DOLPHIN_OBJ)$(SEPARATOR),$(addsuffix .$(OBJ_EXT),$(PRG_FILES)))\
						 $(addprefix $(DOLPHIN_OBJ)$(SEPARATOR),$(addsuffix .$(OBJ_EXT),$(C_FILES))) \
						 $(addprefix $(DOLPHIN_OBJ)$(SEPARATOR),$(addsuffix .$(OBJ_EXT),$(LANG_FILES))) \

#prg compiler commnad
ifeq ($(PRG_COMP_BIN_PATH),)
	PRG_COMP_CMD=harbour.exe $< $(PRG_FLAGS) 
else
	PRG_COMP_CMD=$(PRG_COMP_BIN_PATH)$(SEPARATOR)harbour.exe $< $(PRG_FLAGS)
endif
ifeq ($(C_COMP_BIN_PATH),)
	C_COMP_CMD=$(CC) $(C_FLAGS)
	ifeq ($(C_COMPILER),MINGW32)
		LIB_CMD=$(AR) $(LIB_FLAGS)
	else
		LIB_CMD=$(AR) $(DOLPHIN_LIB)$(SEPARATOR)$(DOLPHIN_LIBNAME) $(LIB_FLAGS)
	endif
	ifeq ($(_MSVC),yes)
		MSVC_LIB_DEF=$(AR) /DEF:$(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def  /OUT:$(DOLPHIN_LIB)$(SEPARATOR)$(DOLPHIN_LIBNAME)
	endif
else
	C_COMP_CMD=$(C_COMP_BIN_PATH)$(SEPARATOR)$(CC) $(C_FLAGS)
	ifeq ($(C_COMPILER),MINGW32)
		LIB_CMD=$(C_COMP_BIN_PATH)$(SEPARATOR)$(AR) $(LIB_FLAGS)
	else	
		LIB_CMD=$(C_COMP_BIN_PATH)$(SEPARATOR)$(AR) $(DOLPHIN_LIB)$(SEPARATOR)$(DOLPHIN_LIBNAME) $(LIB_FLAGS)	
	endif
	ifeq ($(_MSVC),yes)
		MSVC_LIB_DEF=$(C_COMP_BIN_PATH)$(SEPARATOR)$(AR) /DEF:$(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def  /OUT:$(DOLPHIN_LIB)$(SEPARATOR)$(DOLPHIN_LIBNAME)
	else
		MSVC_LIB_DEF=@echo. >>make.log
	endif
endif


define HAR_CMD
	@echo Compiling $<
	@echo Compiling $< >> make.log
	@$(PRG_COMP_CMD) >> make.log
endef

define C_CMD
	@echo Compiling $<
	@echo Compiling $< >> make.log
	@$(C_COMP_CMD) >> make.log
	@echo # ----------------------------------------------------------------------- >> make.log
endef

define LIB_CMD1
	@$(MSVC_LIB_DEF) >> make.log
	@$(LIB_CMD)  >> make.log	
	@echo. >> make.log
endef

define BUILD_SAMPLE
	@echo Linking $<
	@$(LD_CMD)
endef

define RC_CMD
	@echo Compiling $<	
	@$(RCC_CMD) >> make.log
	@echo. >> make.log	
endef

ifeq ($(SAMPLE),)
.PHONY: lib clean

ifeq ($(ERROR_MSG),)

ifeq ($(_MSVC),yes)
lib : logfile dir builddef $(DOLPHIN_LIBNAME)
else
lib : logfile dir $(DOLPHIN_LIBNAME)
endif
else
	
lib : error

endif
else

ifneq ($(FILE_RC),)
FILE_RES = $(SAMPLE).res
endif


.PHONY: sample cleansample 

sample : samplelog cleansample $(SAMPLE)

endif

logfile:
	@echo. > make.log
	@echo # ----------------------------------------------------------------------- >> make.log
	@echo # Building $(DOLPHIN_LIBNAME)                                             >> make.log
	@echo #                                                                         >> make.log
	@echo # C COMPILER    :$(C_COMPILER)                                            >> make.log
	@echo # PRG COMPILER  :$(PRG_COMPILER)                                          >> make.log
	@echo # ----------------------------------------------------------------------- >> make.log
	@echo # -----------------------------------------------------------------------
	@echo # Building $(DOLPHIN_LIBNAME)
	@echo #
	@echo # C COMPILER    :$(C_COMPILER) 
	@echo # PRG COMPILER  :$(PRG_COMPILER) 
	@echo # -----------------------------------------------------------------------
	
samplelog:
	@echo. > make.log
	@echo # ----------------------------------------------------------------------- >> make.log
	@echo # Building sample $(SAMPLE).prg EMBEDDED : $(EMBEDDED)                    >> make.log
	@echo #                                                                         >> make.log
	@echo # C COMPILER    :$(C_COMPILER)                                            >> make.log
	@echo # PRG COMPILER  :$(PRG_COMPILER)                                          >> make.log
	@echo # ----------------------------------------------------------------------- >> make.log
	@echo # -----------------------------------------------------------------------
	@echo # Building sample $(SAMPLE).prg EMBEDDED : $(EMBEDDED)
	@echo #
	@echo # C COMPILER    :$(C_COMPILER) 
	@echo # PRG COMPILER  :$(PRG_COMPILER) 
	@echo # -----------------------------------------------------------------------	
	
$(DOLPHIN_LIBNAME) : $(OBJ_FILES)
	@echo $(LIB_CMD) >> make.log
	$(LIB_CMD1)
	
$(DOLPHIN_OBJ)%.c: $(PRG_SOURCE_PATH)%.prg
	@echo $(PRG_COMP_CMD) >> make.log
	$(HAR_CMD)
	
$(DOLPHIN_OBJ)%.$(OBJ_EXT): $(DOLPHIN_OBJ)%.c
	@echo $(C_COMP_CMD) >> make.log
	$(C_CMD)

$(DOLPHIN_OBJ)%.$(OBJ_EXT): $(C_SOURCE_PATH)%.c
	@echo $(C_COMP_CMD) >> make.log
	$(C_CMD)

$(DOLPHIN_OBJ)%.$(OBJ_EXT): $(LANG_SOURCE_PATH)%.c
	@echo $(C_COMP_CMD) >> make.log
	$(C_CMD)	

builddef:
	@echo LIBRARY $(LIBNAME) > $(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def
	@echo. >> $(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def
	@echo EXPORTS >> $(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def
	@echo. >> $(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def
	@echo            dummy      @1 >> $(DOLPHIN_LIB)$(SEPARATOR)$(LIBNAME).def

# -----------------------------------------------------
# dir
# -----------------------------------------------------

dir: $(DOLPHIN_OBJ) $(DOLPHIN_LIB)

$(DOLPHIN_OBJ) :
	@if not exist $@ md $@

$(DOLPHIN_LIB) :
	@if not exist $@ md $@
	
clean:
	@if EXIST $(DOLPHIN_OBJ)$(SEPARATOR)*.* del /F /Q $(DOLPHIN_OBJ)$(SEPARATOR)*.*
	@if EXIST $(DOLPHIN_LIB)$(SEPARATOR)*.* del /F /Q $(DOLPHIN_LIB)$(SEPARATOR)*.*
	@if EXIST *.bak del /F /Q *.bak
	@if EXIST *.log del /F /Q *.log
	@if EXIST lib$(SEPARATOR)$(DOLPHIN_LIB) rd lib$(SEPARATOR)$(DOLPHIN_LIB) /S /Q
	@if EXIST lib$(SEPARATOR)$(DOLPHIN_LIB) rd lib$(SEPARATOR)$(DOLPHIN_LIB) /S /Q
	@if EXIST obj$(SEPARATOR)$(DOLPHIN_OBJ) rd obj$(SEPARATOR)$(DOLPHIN_OBJ) /S /Q
	@if EXIST obj$(SEPARATOR)$(DOLPHIN_OBJ) rd obj$(SEPARATOR)$(DOLPHIN_OBJ) /S /Q

error:
	@echo $(ERROR_MSG) IS REQUIRED

# --------------------------------------------------------
# Build samples
# --------------------------------------------------------

$(SAMPLE) : $(SAMPLE).$(OBJ_EXT) $(FILE_RES)
	@echo $(LD_CMD) >> make.log
	$(BUILD_SAMPLE)
ifneq ($(C_COMPILER),MSVC64)
	$(SAMPLE).exe
else
	@copy $(SAMPLE).exe samples64
	@cd samples64
	samples64\$(SAMPLE).exe
endif	
	

$(SAMPLE).c: $(SAMPLE).prg
	@echo $(PRG_COMP_CMD) >> make.log
	$(HAR_CMD)

$(SAMPLE).$(OBJ_EXT): $(SAMPLE).c
	@echo $(C_COMP_CMD) >> make.log
	$(C_CMD)
	
$(FILE_RES): $(FILE_RC)
	@echo  $(RCC_CMD) >> make.log
	$(RC_CMD)
	
cleansample :	
	@rm -f $(SAMPLE).exe 
	@rm -f $(SAMPLE).o 
	@rm -f $(SAMPLE).obj 
	@rm -f $(SAMPLE).c 
	@rm -f $(SAMPLE).map 
	@rm -f $(SAMPLE).ilc 
	@rm -f $(SAMPLE).ild 
	@rm -f $(SAMPLE).lib 
	@rm -f *.log
	@rm -f samples64$(SEPARATOR)$(SAMPLE).exe
	
cleansamples :	
	@rm -f *.exe 
	@rm -f *.o 
	@rm -f *.obj 
	@rm -f *.c 
	@rm -f *.map 
	@rm -f *.ilc 
	@rm -f *.ild 
	@rm -f *.lib 
	@rm -f *.log 
