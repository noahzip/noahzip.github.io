@echo off
for %%i in (*.jpg *.png) do (
  convert "%%i" -resize 1920x1080 "resized_%%i"
)