rm livedl.exe
go run updatebuildno.go
go build src/livedl.go
.\build-386.ps1
go build livedl-logger.go

# hide local path
perl replacelocal.pl

# Generate Readme.txt
perl readme-gen.pl

# livedl test run(nico)
$process = Start-Process -FilePath livedl.exe -ArgumentList '-nicotestrun -nicotesttimeout 7 -nicotestfmt "testrec/?UNAME?/?PID?-?UNAME?-?TITLE?"' -PassThru
$process.WaitForExit(1000 * 61)
$process.Kill()

$process = Start-Process -FilePath livedl.x86.exe -ArgumentList '-nicotestrun -nicotesttimeout 7 -nicotestfmt "testrec/?UNAME?/?PID?-?UNAME?-?TITLE?"' -PassThru
$process.WaitForExit(1000 * 30)
$process.Kill()

$dir = "livedl"
$zip = "$dir.zip"
if(Test-Path -PathType Leaf $zip) {
	rm $zip
}
if(Test-Path -PathType Container $dir) {
	rmdir -Recurse $dir
}
mkdir $dir
cp livedl.exe $dir
cp livedl.x86.exe $dir
cp livedl-logger.exe $dir
cp Readme.txt $dir

cp livedl-gui.exe $dir
cp livedl-gui.exe.config $dir
cp Newtonsoft.Json.dll $dir
cp Newtonsoft.Json.xml $dir

Compress-Archive -Path $dir -DestinationPath $zip

if(Test-Path -PathType Container $dir) {
	rmdir -Recurse $dir
}

