param (
   [String] $com = "COM1",
   [String] $msg = ""
)

$port = new-Object System.IO.Ports.SerialPort $com,9600,None,8,one
$port.open()
$port.WriteLine($msg)
$port.Close()