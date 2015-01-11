SRT subtitle offset sync
========================

Just a quick script I threw together.

Due to differences in video files, the offsets for subtitles may be off sync. Sometimes it may be difficult to find subtitles that were meant for the video file you have and this script will help you quickly sync up the SRT file.

### How to run

`perl srt_offset.pl <source srt file> <timestamp of first subtitle to sync>`

Crop your srt file to the first valid subtitle for your video file, then run the aforementioned command with the first timestamp of the first subtitle from the video file to sync. The timestamp should be in the format `hh:mm:ss,fff`. The subtitle number entries in the srt file are ignored and will start back at 1 (so you can crop without worrying about those numbers).

Finally this has to go back into a file so... Just use redirection.

`perl srt_offset.pl <source srt file> <timestamp of first subtitle to sync> > /path/to/your/new/srt/file.srt`