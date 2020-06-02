flag=0
sudo modprobe v4l2loopback exclusive_caps=1
if [ $(v4l2-ctl --list-devices | grep -c "Dummy") -eq 1 ];then
	flag=1
fi;
if [ $flag -eq 1 ];then
	cam=$(v4l2-ctl --list-devices | grep  -2 "Dummy" | cut -d ':' -f 3 | tr -d '[:space:]')
	echo $cam
	file=$(zenity --file-selection --title "Select Video File" --file-filter="*.mp4 *.avi *.mpeg")
	echo $file
	if [ $(ffmpeg -i "$file" 2>&1 | grep -c "yuv420p" ) -eq 1  ];then
		echo "correct file format detected.."
		#ffmpeg -stream_loop -1 -re -i "$file" -f v4l2 "$cam"
		ffmpeg -re -i "$file" -f v4l2 "$cam"
	else
		zenity --error --width 300 --text "Not a supported format."
	fi;
fi;


