@ECHO OFF
SET HBMK2=C:\FW\bcc770_32_20250515\bin\win\bcc\hbmk2.exe
SET PATH=C:\Borland\bcc77\bin;C:\FW\bcc770_32_20250515\bin;%PATH%
%HBMK2% tdolphin.hbp -comp=bcc -cflag=-w-
