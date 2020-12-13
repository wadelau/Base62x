<?php

include("./Base62x.class.php");


$s = "中文测试";

print "enc: ".($senc=Base62x::encode($s))."\n";
print "dec-$senc: ".Base62x::decode($senc)."\n";
print "dec-vBYjvfQ7vhMBwAx2: ".Base62x::decode("vBYjvfQ7vhMBwAx2")."\n";
print "dec-vBYjvfQ7vhMBwAx: ".Base62x::decode("vBYjvfQ7vhMBwAx")."\n";
print "dec-vBYjvfQ7vhMBwA: ".Base62x::decode("vBYjvfQ7vhMBwA")."\n";
print "dec-vBYjvfQ7vhMBw: ".Base62x::decode("vBYjvfQ7vhMBw")."\n";
print "dec-vBYjvfQ7vhMB: ".Base62x::decode("vBYjvfQ7vhMB")."\n";

?>
