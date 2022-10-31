# AnimeRSSMove
Made to move input anime episodes from torrent client downloading from RSS feed to an automatically created subdirectory with proper anime name.

I use this with Tixati with the file completion shell command:

```
file:powershell "C:\Scripts\AnimeRSSMove.ps1 -OutputPath X:\ -InputFile \"$basepath$name$ext\""
```

![image](https://user-images.githubusercontent.com/469830/198966587-96007574-ebfb-457b-8fb4-42a91879e173.png)

Could probably be modified to copy instead if you want seeding to continue.
