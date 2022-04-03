local audio = {
	-- "Play Audio","Pause Audio","Resume Audio","Rewind Audio","Stop Audio","Set Volume","Mute/Unmute","Record Audio"
	recordAudio = {
		mmFile = ".pcm",
		malfa =  0.7, --"dim/100",
		duration = 1000,
		audiotype = "UI",
	},
	muteUnmute = {
		videos = {}
	},
	playAudio = {
		vvol    = "",
		vchan   = "",
		vdelay  = "",
		vrepeat = "",
		vaudio  = "",
		vloop   = "",
		toFade  = "",
		audiotype = "",
		trigger = "",
		tm =  'newTimer_'
	},
	rewindAudio = {
		vaudio  = "",
		vchan   = "",
		vrepeat = "",
		audiotype = ""
	},
	pauseAudio ={
		vaudio  = "",
		vchan   = "",
		vrepeat = "",
		audiotype = ""
	},
	stopAudio = {
		vaudio  = "",
		vchan   = "",
		vrepeat = "",
		audiotype = ""
	},
	resumeAudio = {
		vaudio  = "",
		vchan   = "",
		vrepeat = "",
		audiotype = ""
	},
	setVolume = {
		vvol    = "",
		vchan   = "",
		vrepeat = "",
		audiotype = "",
	}
}
return audio