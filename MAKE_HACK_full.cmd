@echo off

@rem USAGE: "MAKE HACK_full.cmd" [quick]
@rem If first argument is "quick", then this will not update text, maps, or generate a patch
@rem "MACK HACK_quick.cmd" simply calls this but with the quick argument, for convenience

@rem defining buildfile config

set "source_rom=%~dp0FE7_clean.gba"

set "main_event=%~dp0ROMBuildfile.event"

set "target_rom=%~dp0FE7_Hack.gba"
@rem set "target_ups=%~dp0SkillsTest.ups"
@rem set "target_sym=%~dp0SkillsTest.sym"

@rem defining tools

set "textprocess=%~dp0Tools\TextProcess\text-process-classic"
set "ups=%~dp0Tools\ups\ups"
set "parsefile=%~dp0EventAssembler\Tools\ParseFileUTF8.exe"
set "tmx2ea=%~dp0Tools\tmx2ea\tmx2ea"
set symcombo=%~dp0Tools\sym\SymCombo.exe

@rem set %~dp0 into a variable because batch is stupid and messes with it when using conditionals?

set "base_dir=%~dp0"

@rem do the actual building

echo Copying ROM

copy "%source_rom%" "%target_rom%"

if /I not [%1]==[quick] (

  @rem only do the following if this isn't a make hack quick

  echo:
  echo Processing text

  cd "%base_dir%Text"
  echo: | ("%textprocess%" text_buildfile.txt --parser-exe "%parsefile%" --installer "InstallTextData.event" --definitions "TextDefinitions.event")

  echo:
  echo Processing maps

  cd "%base_dir%Maps"
  echo: | ("%tmx2ea%" -s -O "MasterMapInstaller.event")

)

echo:
echo Building skill ASM

cd "%base_dir%"
python "%base_dir%Tools\build_skill_asm.py"
if errorlevel 1 (
  echo Skill ASM build failed.
  pause
  exit /b 1
)

echo:
echo Dumping FE7 text table
python "%base_dir%Tools\dump_fe7_text_table.py" --rom "%source_rom%" --out "%base_dir%Text\NewTextTable.dmp"

echo:
echo Assembling

cd "%base_dir%EventAssembler"
ColorzCore A FE7 "-output:%target_rom%" "-input:%main_event%" --nocash-sym
set "assemble_error=%ERRORLEVEL%"

if /I not [%1]==[quick] (

  @rem only do the following if this isn't a make hack quick

  echo:
  echo Generating patch

  cd "%base_dir%"
  "%ups%" diff -b "%source_rom%" -m "%target_rom%" -o "%target_ups%"

)

@rem echo:
@rem echo Generating sym file

@rem echo: | ( "%symcombo%" "%target_sym%" "%target_sym%" "%base_dir%\Tools\sym\VanillaOffsets.sym" )

if not "%assemble_error%"=="0" (
  echo Assemble failed.
  pause
  exit /b %assemble_error%
)

echo:
echo Running ROM tests
python "%base_dir%tests\test_get_string_table.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_hook_unit_loading.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_skill_definitions.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_skill_table_defines.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_growth_toggle_bg.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_durability_based_items.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_icon_rework.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_skill_scroll_id.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)
python "%base_dir%tests\test_prep_skill_scroll.py"
if errorlevel 1 (
  echo ROM tests failed.
  pause
  exit /b 1
)

echo Closing existing NO$GBA
taskkill /F /IM NO$GBA.EXE >nul 2>&1
taskkill /F /IM no$gba.exe >nul 2>&1

echo Launching NO$GBA
start "" "%base_dir%..\no$gba\NO$GBA.EXE" "%target_rom%"

pause
