param (
   [String] $com = "COM1"
)


$port = new-Object System.IO.Ports.SerialPort $com,9600,None,8,one
$port.open()
$stream = $port.BaseStream
$stream.ReadTimeout = 1000
$buffer = ""
do {
	try {
		$b = $stream.ReadByte()
	} catch [Exception] {
		$b = -1
	}
	if ( $b -gt -1 ) { $buffer = $buffer + ([char]$b) }
} while ( $b -gt -1 )
echo $buffer
$port.Close()